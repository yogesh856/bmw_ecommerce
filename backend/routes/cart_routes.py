from flask import Blueprint, request, jsonify, current_app
from bson import ObjectId
from bson.errors import InvalidId

cart_bp = Blueprint('cart', __name__)


# ── GET CART ───────────────────────────────────────────────
@cart_bp.route('/<user_id>', methods=['GET'])
def get_cart(user_id):
    db = current_app.db
    cart = db.carts.find_one({"user_id": user_id})
    if not cart:
        return jsonify({"user_id": user_id, "items": [], "total": 0}), 200

    cart['_id'] = str(cart['_id'])
    return jsonify(cart), 200


# ── ADD TO CART ────────────────────────────────────────────
@cart_bp.route('/add', methods=['POST'])
def add_to_cart():
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    if not data.get('user_id') or not data.get('car_id'):
        return jsonify({"error": "user_id and car_id are required"}), 400

    user_id = data['user_id']
    car_id  = data['car_id']

    try:
        oid = ObjectId(car_id)
    except InvalidId:
        return jsonify({"error": "Invalid car ID format"}), 400

    car = db.cars.find_one({"_id": oid})
    if not car:
        return jsonify({"error": "Car not found"}), 404

    cart = db.carts.find_one({"user_id": user_id})

    item = {
        "car_id":    car_id,
        "name":      car['name'],
        "model":     car['model'],
        "price":     car['price'],
        "image_url": car.get('image_url', ''),
        "quantity":  1
    }

    if not cart:
        db.carts.insert_one({"user_id": user_id, "items": [item]})
    else:
        # Check if car already in cart
        existing = next((i for i in cart['items'] if i['car_id'] == car_id), None)
        if existing:
            db.carts.update_one(
                {"user_id": user_id, "items.car_id": car_id},
                {"$inc": {"items.$.quantity": 1}}
            )
        else:
            db.carts.update_one({"user_id": user_id}, {"$push": {"items": item}})

    return jsonify({"message": "Added to cart"}), 200


# ── REMOVE FROM CART ───────────────────────────────────────
@cart_bp.route('/remove', methods=['POST'])
def remove_from_cart():
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    if not data.get('user_id') or not data.get('car_id'):
        return jsonify({"error": "user_id and car_id are required"}), 400

    db.carts.update_one(
        {"user_id": data['user_id']},
        {"$pull": {"items": {"car_id": data['car_id']}}}
    )
    return jsonify({"message": "Item removed"}), 200


# ── CLEAR CART ─────────────────────────────────────────────
@cart_bp.route('/clear/<user_id>', methods=['DELETE'])
def clear_cart(user_id):
    db = current_app.db
    db.carts.update_one({"user_id": user_id}, {"$set": {"items": []}})
    return jsonify({"message": "Cart cleared"}), 200
