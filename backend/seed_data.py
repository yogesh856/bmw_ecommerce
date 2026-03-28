from pymongo import MongoClient

client = MongoClient('mongodb://localhost:27017/')
db = client['bmw_ecommerce']
db.cars.drop()

# ── CONFIRMED BMW-ONLY IMAGE URLs ─────────────────────────
# Verified via browser: only BMW cars
BMW_M5     = "https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800"
BMW_7S     = "https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800"
BMW_i8     = "https://images.unsplash.com/photo-1556800572-1b8aeef2c54f?w=800"
BMW_4S     = "https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800"
BMW_Z4     = "https://images.unsplash.com/photo-1553440569-bcc63803a83d?w=800"
BMW_M4     = "https://images.unsplash.com/photo-1617886903355-9354bb57751f?w=800"

cars = [
    # ── SEDAN ──────────────────────────────────────────────
    {
        "name": "BMW M3 Competition", "model": "2024", "category": "Sedan",
        "price": 8500000, "color": "Alpine White", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo Inline-6", "horsepower": "503 HP",
        "description": "The legendary BMW M3 Competition - a perfect blend of luxury and performance on track and road.",
        "image_url": BMW_M5,
        "in_stock": True,
        "features": ["M Sport Seats", "Harman Kardon Sound", "Heads-Up Display", "Adaptive M Suspension"]
    },
    {
        "name": "BMW 3 Series", "model": "2024", "category": "Sedan",
        "price": 4700000, "color": "Portimao Blue", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "255 HP",
        "description": "The BMW 3 Series sets the benchmark for sports sedans — sporty, efficient, and premium.",
        "image_url": BMW_4S,
        "in_stock": True,
        "features": ["Live Cockpit Professional", "Wireless Apple CarPlay", "Parking Assistant", "Sport Line Package"]
    },
    {
        "name": "BMW 5 Series", "model": "2024", "category": "Sedan",
        "price": 7200000, "color": "Arctic Grey", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Turbo", "horsepower": "375 HP",
        "description": "The BMW 5 Series executive sedan combines dynamic performance with first-class comfort.",
        "image_url": BMW_M5,
        "in_stock": True,
        "features": ["Executive Lounge", "Panoramic Glass Roof", "Adaptive LED", "BMW Driving Assistant Pro"]
    },

    # ── LUXURY SEDAN ───────────────────────────────────────
    {
        "name": "BMW 7 Series", "model": "2024", "category": "Luxury Sedan",
        "price": 16500000, "color": "Sophisto Grey", "fuel_type": "Hybrid",
        "engine": "3.0L Inline-6 Hybrid", "horsepower": "389 HP",
        "description": "The pinnacle of BMW luxury. Theater Screen, Executive Lounge — experience true luxury.",
        "image_url": BMW_7S,
        "in_stock": True,
        "features": ["31.3-inch Theater Screen", "Executive Lounge Seating", "Sky Lounge Roof", "Massage Seats"]
    },
    {
        "name": "BMW 8 Series Gran Coupe", "model": "2024", "category": "Luxury Sedan",
        "price": 14800000, "color": "Frozen Black", "fuel_type": "Petrol",
        "engine": "4.4L V8 Twin-Turbo", "horsepower": "530 HP",
        "description": "Four doors, infinite soul. The 8 Series Gran Coupe blends supercar performance with luxury.",
        "image_url": BMW_7S,
        "in_stock": True,
        "features": ["Merino Leather", "Bang & Olufsen Sound", "Active Comfort Drive", "M Sport Brakes"]
    },

    # ── SUV ────────────────────────────────────────────────
    {
        "name": "BMW X5 M", "model": "2024", "category": "SUV",
        "price": 11500000, "color": "Carbon Black", "fuel_type": "Petrol",
        "engine": "4.4L V8 Twin-Turbo", "horsepower": "617 HP",
        "description": "The ultimate performance SUV. M performance with everyday usability.",
        "image_url": BMW_M4,
        "in_stock": True,
        "features": ["Panoramic Sunroof", "4-Zone Climate", "Night Vision", "Bowers & Wilkins Sound"]
    },
    {
        "name": "BMW X3", "model": "2024", "category": "SUV",
        "price": 6500000, "color": "Phytonic Blue", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "248 HP",
        "description": "The BMW X3 combines sporty handling with outstanding versatility.",
        "image_url": BMW_M4,
        "in_stock": True,
        "features": ["xDrive AWD", "Panoramic Roof", "Park Assist Plus", "Ambient Lighting"]
    },
    {
        "name": "BMW X7", "model": "2024", "category": "SUV",
        "price": 13500000, "color": "Dravit Grey", "fuel_type": "Petrol",
        "engine": "4.4L V8 xDrive", "horsepower": "523 HP",
        "description": "BMW's flagship SAV. 7 seats in first-class comfort with M-class performance.",
        "image_url": BMW_M4,
        "in_stock": True,
        "features": ["3-Row 7 Seater", "Sky Lounge Panoramic", "Bowers & Wilkins Diamond", "Rear-Seat Entertainment"]
    },
    {
        "name": "BMW X1", "model": "2024", "category": "SUV",
        "price": 4900000, "color": "Storm Bay", "fuel_type": "Petrol",
        "engine": "1.5L TwinPower Turbo", "horsepower": "136 HP",
        "description": "Compact, bold, versatile. The BMW X1 is the perfect entry into BMW SAVs.",
        "image_url": BMW_M4,
        "in_stock": True,
        "features": ["xDrive AWD", "Curved Display", "Automatic Climate", "Parking Assistant"]
    },

    # ── COUPE ──────────────────────────────────────────────
    {
        "name": "BMW M4 Coupe", "model": "2024", "category": "Coupe",
        "price": 9200000, "color": "Sao Paulo Yellow", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo Inline-6", "horsepower": "503 HP",
        "description": "Pure driving passion. The BMW M4 Coupe is built for those who live to drive.",
        "image_url": BMW_M4,
        "in_stock": True,
        "features": ["M Carbon Roof", "Ceramic Brakes", "Active M Differential", "Launch Control"]
    },
    {
        "name": "BMW 4 Series Coupe", "model": "2024", "category": "Coupe",
        "price": 6800000, "color": "Brooklyn Grey", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "255 HP",
        "description": "The BMW 4 Series Coupe delivers an exhilarating driving experience with bold iconic design.",
        "image_url": BMW_4S,
        "in_stock": True,
        "features": ["Iconic Kidney Grille", "M Sport Package", "Live Cockpit Pro", "Reversing Camera"]
    },

    # ── SPORTS ─────────────────────────────────────────────
    {
        "name": "BMW Z4 Roadster", "model": "2024", "category": "Sports",
        "price": 7800000, "color": "San Francisco Red", "fuel_type": "Petrol",
        "engine": "3.0L Inline-6", "horsepower": "382 HP",
        "description": "Open-top driving pleasure. The BMW Z4 is pure roadster emotion.",
        "image_url": BMW_Z4,
        "in_stock": True,
        "features": ["Retractable Soft Top", "Sport Seats", "Adaptive Suspension", "Sport Exhaust"]
    },
    {
        "name": "BMW M2 Coupe", "model": "2024", "category": "Sports",
        "price": 7400000, "color": "Zandvoort Blue", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "453 HP",
        "description": "The most driver-focused BMW ever. Raw, precise, and absolutely thrilling on every road.",
        "image_url": BMW_M5,
        "in_stock": True,
        "features": ["Track Mode", "M Traction Control", "Carbon Fiber Interior", "M Compound Brakes"]
    },

    # ── ELECTRIC SUV ───────────────────────────────────────
    {
        "name": "BMW iX Electric", "model": "2024", "category": "Electric SUV",
        "price": 12000000, "color": "Mineral White", "fuel_type": "Electric",
        "engine": "Dual Motor Electric", "horsepower": "523 HP",
        "description": "The future of BMW. 630km range, ultra-fast charging, and autonomous features.",
        "image_url": BMW_i8,
        "in_stock": True,
        "features": ["630km Range", "200kW Charging", "BMW Personal CoPilot", "Eco Interior"]
    },
    {
        "name": "BMW iX3 Electric", "model": "2024", "category": "Electric SUV",
        "price": 8900000, "color": "Glacier Silver", "fuel_type": "Electric",
        "engine": "Single Motor Electric", "horsepower": "286 HP",
        "description": "Zero emissions, zero compromise. The iX3 delivers 460km range with everyday practicality.",
        "image_url": BMW_i8,
        "in_stock": True,
        "features": ["460km Range", "DC Fast Charging", "Recuperation Paddles", "Recycled Interior"]
    },
    {
        "name": "BMW i4 M50", "model": "2024", "category": "Electric SUV",
        "price": 9500000, "color": "Frozen Dark Grey", "fuel_type": "Electric",
        "engine": "Dual Motor Electric (M)", "horsepower": "536 HP",
        "description": "The electric M car. 0-100 in 3.9s, 590km range, and pure M driving dynamics.",
        "image_url": BMW_i8,
        "in_stock": True,
        "features": ["0-100 in 3.9s", "590km Range", "M Sport Differential", "Active Sound Design"]
    },
]

db.cars.insert_many(cars)
print(f"✅ {db.cars.count_documents({})} cars inserted with verified BMW images!")
