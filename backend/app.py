from flask import Flask
from flask_cors import CORS
from pymongo import MongoClient

from routes.auth_routes import auth_bp
from routes.car_routes import car_bp
from routes.order_routes import order_bp
from routes.cart_routes import cart_bp

app = Flask(__name__)
CORS(app, origins=["http://localhost:*", "http://127.0.0.1:*"])

# MongoDB Connection
client = MongoClient('mongodb://localhost:27017/')
db = client['bmw_ecommerce']
app.db = db

# Register Blueprints
app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(car_bp, url_prefix='/api/cars')
app.register_blueprint(order_bp, url_prefix='/api/orders')
app.register_blueprint(cart_bp, url_prefix='/api/cart')

@app.route('/')
def index():
    return {"message": "BMW E-Commerce API Running!", "status": "ok"}

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
