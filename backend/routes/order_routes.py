from flask import Blueprint, request, jsonify, current_app
from bson import ObjectId
from bson.errors import InvalidId
from datetime import datetime

order_bp = Blueprint('orders', __name__)


def order_to_dict(order):
    order['_id'] = str(order['_id'])
    return order


# ── PLACE ORDER ────────────────────────────────────────────
@order_bp.route('/place', methods=['POST'])
def place_order():
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    if not data.get('user_id') or not data.get('items'):
        return jsonify({"error": "user_id and items are required"}), 400

    # Calculate total from items
    total = sum(item['price'] * item.get('quantity', 1) for item in data['items'])

    order = {
        "user_id":          data['user_id'],
        "items":            data['items'],
        "total_amount":     total,
        "shipping_address": data.get('address', ''),
        "payment_method":   data.get('payment_method', 'Cash on Delivery'),
        "status":           "Pending",
        "ordered_at":       datetime.now().isoformat()
    }

    result = db.orders.insert_one(order)

    # Clear cart after order
    db.carts.update_one({"user_id": data['user_id']}, {"$set": {"items": []}})

    return jsonify({"message": "Order placed successfully!", "order_id": str(result.inserted_id)}), 201


# ── GET USER ORDERS ────────────────────────────────────────
@order_bp.route('/user/<user_id>', methods=['GET'])
def get_user_orders(user_id):
    db = current_app.db
    orders = list(db.orders.find({"user_id": user_id}))
    return jsonify([order_to_dict(o) for o in orders]), 200


# ── GET SINGLE ORDER ───────────────────────────────────────
@order_bp.route('/<order_id>', methods=['GET'])
def get_order(order_id):
    db = current_app.db
    try:
        oid = ObjectId(order_id)
    except InvalidId:
        return jsonify({"error": "Invalid order ID format"}), 400

    order = db.orders.find_one({"_id": oid})
    if not order:
        return jsonify({"error": "Order not found"}), 404
    return jsonify(order_to_dict(order)), 200


# ── UPDATE ORDER STATUS (Admin) ────────────────────────────
@order_bp.route('/status/<order_id>', methods=['PUT'])
def update_status(order_id):
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    if not data.get('status'):
        return jsonify({"error": "status is required"}), 400

    try:
        oid = ObjectId(order_id)
    except InvalidId:
        return jsonify({"error": "Invalid order ID format"}), 400

    db.orders.update_one({"_id": oid}, {"$set": {"status": data['status']}})
    return jsonify({"message": "Order status updated"}), 200


# ── ALL ORDERS (Admin) ─────────────────────────────────────
@order_bp.route('/all', methods=['GET'])
def get_all_orders():
    db = current_app.db
    orders = list(db.orders.find())
    return jsonify([order_to_dict(o) for o in orders]), 200
