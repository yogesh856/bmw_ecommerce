from flask import Blueprint, request, jsonify, current_app
from bson import ObjectId
from bson.errors import InvalidId

car_bp = Blueprint('cars', __name__)


def car_to_dict(car):
    car['_id'] = str(car['_id'])
    return car


# ── GET ALL CARS ───────────────────────────────────────────
@car_bp.route('/', methods=['GET'])
def get_all_cars():
    db = current_app.db
    category = request.args.get('category')   # e.g. ?category=SUV
    query = {"category": category} if category else {}
    cars = list(db.cars.find(query))
    return jsonify([car_to_dict(c) for c in cars]), 200


# ── SEARCH CARS ────────────────────────────────────────────
# NOTE: /search must be registered BEFORE /<car_id> to avoid route conflict
@car_bp.route('/search', methods=['GET'])
def search_cars():
    db = current_app.db
    query_text = request.args.get('q', '')
    cars = list(db.cars.find({
        "$or": [
            {"name":     {"$regex": query_text, "$options": "i"}},
            {"category": {"$regex": query_text, "$options": "i"}},
            {"model":    {"$regex": query_text, "$options": "i"}}
        ]
    }))
    return jsonify([car_to_dict(c) for c in cars]), 200


# ── GET SINGLE CAR ─────────────────────────────────────────
@car_bp.route('/<car_id>', methods=['GET'])
def get_car(car_id):
    db = current_app.db
    try:
        oid = ObjectId(car_id)
    except InvalidId:
        return jsonify({"error": "Invalid car ID format"}), 400

    car = db.cars.find_one({"_id": oid})
    if not car:
        return jsonify({"error": "Car not found"}), 404
    return jsonify(car_to_dict(car)), 200


# ── ADD CAR (Admin) ────────────────────────────────────────
@car_bp.route('/add', methods=['POST'])
def add_car():
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    if not data.get('name') or not data.get('model') or not data.get('category') or not data.get('price'):
        return jsonify({"error": "name, model, category and price are required"}), 400

    car = {
        "name":        data['name'],
        "model":       data['model'],
        "category":    data['category'],
        "price":       data['price'],
        "color":       data.get('color', 'White'),
        "fuel_type":   data.get('fuel_type', 'Petrol'),
        "engine":      data.get('engine', ''),
        "horsepower":  data.get('horsepower', ''),
        "description": data.get('description', ''),
        "image_url":   data.get('image_url', ''),
        "in_stock":    data.get('in_stock', True),
        "features":    data.get('features', [])
    }

    result = db.cars.insert_one(car)
    return jsonify({"message": "Car added", "car_id": str(result.inserted_id)}), 201


# ── UPDATE CAR ─────────────────────────────────────────────
@car_bp.route('/update/<car_id>', methods=['PUT'])
def update_car(car_id):
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    try:
        oid = ObjectId(car_id)
    except InvalidId:
        return jsonify({"error": "Invalid car ID format"}), 400

    db.cars.update_one({"_id": oid}, {"$set": data})
    return jsonify({"message": "Car updated"}), 200


# ── DELETE CAR ─────────────────────────────────────────────
@car_bp.route('/delete/<car_id>', methods=['DELETE'])
def delete_car(car_id):
    db = current_app.db
    try:
        oid = ObjectId(car_id)
    except InvalidId:
        return jsonify({"error": "Invalid car ID format"}), 400

    db.cars.delete_one({"_id": oid})
    return jsonify({"message": "Car deleted"}), 200


# ── DELETE ALL CARS ────────────────────────────────────────
@car_bp.route('/delete-all', methods=['DELETE'])
def delete_all_cars():
    db = current_app.db
    result = db.cars.delete_many({})
    return jsonify({"message": f"All cars deleted", "count": result.deleted_count}), 200
