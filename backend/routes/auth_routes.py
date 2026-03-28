from flask import Blueprint, request, jsonify, current_app
from datetime import datetime
from bson import ObjectId
from bson.errors import InvalidId

auth_bp = Blueprint('auth', __name__)


# ── REGISTER ──────────────────────────────────────────────
@auth_bp.route('/register', methods=['POST'])
def register():
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    if not data.get('email') or not data.get('password') or not data.get('name'):
        return jsonify({"error": "name, email and password are required"}), 400

    # Check if email already exists
    if db.users.find_one({"email": data['email']}):
        return jsonify({"error": "Email already registered"}), 400

    user = {
        "name":       data['name'],
        "email":      data['email'],
        "password":   data['password'],   # plain text - college project
        "phone":      data.get('phone', ''),
        "address":    data.get('address', ''),
        "created_at": datetime.now().isoformat()
    }

    result = db.users.insert_one(user)
    return jsonify({"message": "User registered successfully", "user_id": str(result.inserted_id)}), 201


# ── LOGIN ──────────────────────────────────────────────────
@auth_bp.route('/login', methods=['POST'])
def login():
    db = current_app.db
    data = request.json
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    if not data.get('email') or not data.get('password'):
        return jsonify({"error": "email and password are required"}), 400

    user = db.users.find_one({"email": data['email'], "password": data['password']})
    if not user:
        return jsonify({"error": "Invalid email or password"}), 401

    return jsonify({
        "message": "Login successful",
        "user_id": str(user['_id']),
        "name":    user['name'],
        "email":   user['email']
    }), 200


# ── GET USER PROFILE ───────────────────────────────────────
@auth_bp.route('/user/<user_id>', methods=['GET'])
def get_user(user_id):
    db = current_app.db
    try:
        oid = ObjectId(user_id)
    except InvalidId:
        return jsonify({"error": "Invalid user ID format"}), 400

    user = db.users.find_one({"_id": oid})
    if not user:
        return jsonify({"error": "User not found"}), 404

    return jsonify({
        "user_id":  str(user['_id']),
        "name":     user['name'],
        "email":    user['email'],
        "phone":    user.get('phone', ''),
        "address":  user.get('address', '')
    }), 200
