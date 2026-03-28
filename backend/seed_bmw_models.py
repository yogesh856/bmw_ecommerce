from pymongo import MongoClient
import os

MONGO_URI = os.environ.get('MONGO_URI', 'mongodb://localhost:27017/')
client = MongoClient(MONGO_URI)
db = client['bmw_ecommerce']

# ── 6 VERIFIED BMW UNSPLASH PHOTOS (confirmed from Unsplash BMW search) ───────
BMW_M4_RED   = "https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=800"  # Red BMW M4 G82 ✅
BMW_M4_GREY  = "https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800"  # Grey BMW M4 G82 ✅
BMW_M5_WHT   = "https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800"     # White BMW M5 ✅
BMW_3S_SIL   = "https://images.unsplash.com/photo-1607853554439-0069ec0f29b6?w=800"  # Silver BMW 3/M3 ✅
BMW_X5_BLK   = "https://images.unsplash.com/photo-1615908397724-6dc711db34a7?w=800"  # Black BMW X5 ✅
BMW_I8_WHT   = "https://images.unsplash.com/photo-1667551181687-e3eb9babf037?w=800"  # White BMW i8 ✅

# Map to model categories
IMG_3S  = BMW_3S_SIL    # 3 Series Sedan
IMG_5S  = BMW_M5_WHT    # 5 Series
IMG_7S  = BMW_M5_WHT    # 7 Series Luxury
IMG_M3  = BMW_M4_GREY   # M3
IMG_M5  = BMW_M5_WHT    # M5
IMG_2S  = BMW_M4_RED    # 2 Series Coupe
IMG_4S  = BMW_M4_GREY   # 4 Series Coupe
IMG_M4  = BMW_M4_RED    # M4 Coupe
IMG_8S  = BMW_M4_GREY   # 8 Series
IMG_M2  = BMW_3S_SIL    # M2
IMG_M8  = BMW_M4_RED    # M8
IMG_X1  = BMW_X5_BLK    # X1 SUV
IMG_X2  = BMW_M4_RED    # X2
IMG_X3  = BMW_X5_BLK    # X3
IMG_X3M = BMW_M4_GREY   # X3 M
IMG_X4  = BMW_X5_BLK    # X4
IMG_X5  = BMW_X5_BLK    # X5
IMG_X5M = BMW_M4_GREY   # X5 M
IMG_X6  = BMW_M4_RED    # X6
IMG_X6M = BMW_M4_GREY   # X6 M
IMG_X7  = BMW_X5_BLK    # X7
IMG_XM  = BMW_M4_GREY   # XM
IMG_Z4  = BMW_M4_RED    # Z4 Roadster
IMG_I4  = BMW_I8_WHT    # i4 Electric
IMG_I5  = BMW_I8_WHT    # i5 Electric
IMG_I7  = BMW_I8_WHT    # i7 Electric
IMG_IX  = BMW_I8_WHT    # iX
IMG_IX1 = BMW_I8_WHT    # iX1
IMG_IX3 = BMW_I8_WHT    # iX3

cars = [

    # ════════════════════════════════════════════
    # 1-SERIES
    # ════════════════════════════════════════════
    {
        "name": "BMW 1 Series", "model": "2024", "category": "Sedan",
        "price": 4300000, "color": "Mineral White", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "170 HP",
        "description": "The entry into the BMW world. Compact, sporty with exceptional driving dynamics and a premium feel.",
        "image_url": IMG_3S, "in_stock": True,
        "features": ["Live Cockpit", "Parking Assist", "Sport Line", "LED Headlights"]
    },

    # ════════════════════════════════════════════
    # 2-SERIES
    # ════════════════════════════════════════════
    {
        "name": "BMW 2 Series Coupe", "model": "2024", "category": "Coupe",
        "price": 5100000, "color": "Zandvoort Blue", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "255 HP",
        "description": "The most driver-focused two-door BMW. Pure rear-wheel drive joy in a compact coupe package.",
        "image_url": IMG_2S, "in_stock": True,
        "features": ["Rear-Wheel Drive", "Sport Seats", "M Sport Package", "Digital Cockpit"]
    },
    {
        "name": "BMW M235i Gran Coupe", "model": "2024", "category": "Coupe",
        "price": 5600000, "color": "Storm Bay", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "306 HP",
        "description": "Four-door practicality meets coupe styling and M Performance. The best of both worlds.",
        "image_url": IMG_2S, "in_stock": True,
        "features": ["xDrive AWD", "M Sport Brakes", "Harman Kardon Sound", "Adaptive Suspension"]
    },

    # ════════════════════════════════════════════
    # 3-SERIES
    # ════════════════════════════════════════════
    {
        "name": "BMW 320d", "model": "2024", "category": "Sedan",
        "price": 4700000, "color": "Portimao Blue", "fuel_type": "Diesel",
        "engine": "2.0L Diesel TwinPower Turbo", "horsepower": "190 HP",
        "description": "The benchmark executive sedan. Efficient diesel power meets legendary BMW driving dynamics.",
        "image_url": IMG_3S, "in_stock": True,
        "features": ["Live Cockpit Professional", "Wireless Apple CarPlay", "Parking Assistant", "Ambient Lighting"]
    },
    {
        "name": "BMW 330i", "model": "2024", "category": "Sedan",
        "price": 5500000, "color": "Arctic Grey", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "255 HP",
        "description": "The heart of the 3 Series lineup. Perfect balance of sport, comfort and efficiency.",
        "image_url": IMG_3S, "in_stock": True,
        "features": ["Adaptive M Suspension", "Head-Up Display", "Active Cruise Control", "Sport Line"]
    },
    {
        "name": "BMW M3 Competition", "model": "2024", "category": "Sedan",
        "price": 8500000, "color": "Isle of Man Green", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "510 HP",
        "description": "The legendary high-performance sedan. 0-100 in 3.9s with xDrive precision.",
        "image_url": IMG_M3, "in_stock": True,
        "features": ["M Carbon Seats", "Ceramic Brakes", "M Drive Pro", "Launch Control"]
    },
    {
        "name": "BMW M3 Touring", "model": "2024", "category": "Sedan",
        "price": 9200000, "color": "Frozen Portimao Blue", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "510 HP",
        "description": "The world's first M3 wagon. All the performance of M3 with estate practicality.",
        "image_url": IMG_M3, "in_stock": True,
        "features": ["xDrive AWD", "Panoramic Roof", "M Carbon Roof", "Adaptive Suspension"]
    },

    # ════════════════════════════════════════════
    # 4-SERIES
    # ════════════════════════════════════════════
    {
        "name": "BMW 430i Coupe", "model": "2024", "category": "Coupe",
        "price": 6800000, "color": "Brooklyn Grey", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "255 HP",
        "description": "Iconic kidney grille, sweeping proportions and pure driving character.",
        "image_url": IMG_4S, "in_stock": True,
        "features": ["Iconic Kidney Grille", "M Sport Package", "Live Cockpit Pro", "Laser Lights"]
    },
    {
        "name": "BMW 440i Gran Coupe", "model": "2024", "category": "Coupe",
        "price": 7900000, "color": "Sapphire Black", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Turbo Inline-6", "horsepower": "374 HP",
        "description": "Four-door coupe with six-cylinder power. Grand Touring at its finest.",
        "image_url": IMG_4S, "in_stock": True,
        "features": ["xDrive AWD", "Reversing Camera", "Panoramic Roof", "Bowers & Wilkins Sound"]
    },
    {
        "name": "BMW M4 Coupe", "model": "2024", "category": "Coupe",
        "price": 9500000, "color": "Sao Paulo Yellow", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "510 HP",
        "description": "Pure driving passion in its most focused form. Track-honed and road-legal brilliance.",
        "image_url": IMG_M4, "in_stock": True,
        "features": ["M Carbon Roof", "Ceramic Brakes", "Active M Differential", "M Race Track Mode"]
    },
    {
        "name": "BMW M4 CSL", "model": "2024", "category": "Coupe",
        "price": 14500000, "color": "Brooklyn Grey", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "550 HP",
        "description": "The most extreme road-legal M4 ever. Lightweight, track-focused, and brutally fast.",
        "image_url": IMG_M4, "in_stock": True,
        "features": ["Full Carbon Package", "Fixed Back Seats", "CFRP Roof", "Track-Only Mode"]
    },
    {
        "name": "BMW M4 Competition Convertible", "model": "2024", "category": "Convertible",
        "price": 11000000, "color": "Fire Red", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "510 HP",
        "description": "Open-air M Performance. The M4 Convertible combines raw power with roofless driving joy.",
        "image_url": IMG_M4, "in_stock": True,
        "features": ["Retractable Hardtop", "M Compound Brakes", "Lane Keeping Assist", "Sport Exhaust"]
    },

    # ════════════════════════════════════════════
    # 5-SERIES
    # ════════════════════════════════════════════
    {
        "name": "BMW 520d", "model": "2024", "category": "Sedan",
        "price": 6600000, "color": "Carbon Black", "fuel_type": "Diesel",
        "engine": "2.0L Diesel TwinPower Turbo", "horsepower": "197 HP",
        "description": "Executive sedan with unmatched refinement and class-leading diesel efficiency.",
        "image_url": IMG_5S, "in_stock": True,
        "features": ["Panoramic Glass Roof", "Driving Assistant Pro", "Ambient Lighting", "Wireless Charging"]
    },
    {
        "name": "BMW 530i", "model": "2024", "category": "Sedan",
        "price": 7600000, "color": "Portimao Blue", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "252 HP",
        "description": "The mid-range 5 Series with the perfect balance of luxury and performance.",
        "image_url": IMG_5S, "in_stock": True,
        "features": ["Executive Pack", "Laser Headlights", "Gesture Control", "Live Cockpit Pro"]
    },
    {
        "name": "BMW 545e xDrive", "model": "2024", "category": "Sedan",
        "price": 9800000, "color": "Frozen Black", "fuel_type": "Hybrid",
        "engine": "3.0L Inline-6 Plug-In Hybrid", "horsepower": "394 HP",
        "description": "The most versatile 5 Series. Full EV range for daily commutes, petrol power for long trips.",
        "image_url": IMG_5S, "in_stock": True,
        "features": ["50km EV Range", "Wireless Charging", "Remote Park Assist", "Air Suspension"]
    },
    {
        "name": "BMW M5 Competition", "model": "2024", "category": "Sedan",
        "price": 16500000, "color": "Frozen Midnight Blue", "fuel_type": "Hybrid",
        "engine": "4.4L V8 M TwinPower + Electric", "horsepower": "727 HP",
        "description": "The most powerful M5 ever built. Hybrid hyper-sedan with 0-100 in 3.5 seconds.",
        "image_url": IMG_M5, "in_stock": True,
        "features": ["M xDrive AWD", "M Race Track Mode", "Sport Exhaust", "Active Rear Steering"]
    },

    # ════════════════════════════════════════════
    # 7-SERIES
    # ════════════════════════════════════════════
    {
        "name": "BMW 730Ld", "model": "2024", "category": "Luxury Sedan",
        "price": 14500000, "color": "Sophisto Grey", "fuel_type": "Diesel",
        "engine": "3.0L Diesel Inline-6", "horsepower": "286 HP",
        "description": "The 7 Series sets the standard for luxury. An unrivalled combination of space and technology.",
        "image_url": IMG_7S, "in_stock": True,
        "features": ["31.3'' Theater Screen", "Executive Lounge Seating", "Sky Lounge Roof", "Bowers & Wilkins Diamond"]
    },
    {
        "name": "BMW 740i", "model": "2024", "category": "Luxury Sedan",
        "price": 16500000, "color": "Cashmere Silver", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Inline-6", "horsepower": "375 HP",
        "description": "Pinnacle of BMW luxury. Theater Screen, Executive Lounge — redefining what a car can be.",
        "image_url": IMG_7S, "in_stock": True,
        "features": ["Theater Screen", "Massage Seats 4-Zone", "Night Vision", "Parking Assistant Plus"]
    },
    {
        "name": "BMW 750e xDrive", "model": "2024", "category": "Luxury Sedan",
        "price": 19500000, "color": "Mineral White", "fuel_type": "Hybrid",
        "engine": "3.0L Inline-6 PHEV", "horsepower": "490 HP",
        "description": "The ultimate luxury experience combined with the future of electrification.",
        "image_url": IMG_7S, "in_stock": True,
        "features": ["Rear Axle Steering", "Automatic Lane Change", "Remote Park Assist", "4-Zone AC"]
    },

    # ════════════════════════════════════════════
    # 8-SERIES
    # ════════════════════════════════════════════
    {
        "name": "BMW 840i Gran Coupe", "model": "2024", "category": "Luxury Sedan",
        "price": 13500000, "color": "Frozen Black", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Turbo Inline-6", "horsepower": "340 HP",
        "description": "Grand Touring for the bold. Four seats, coupe elegance, and exceptional GT performance.",
        "image_url": IMG_8S, "in_stock": True,
        "features": ["Merino Leather", "Panoramic Sunroof", "Bang & Olufsen Sound", "Laser Lights"]
    },
    {
        "name": "BMW M850i xDrive Coupe", "model": "2024", "category": "Coupe",
        "price": 16800000, "color": "Dravit Grey", "fuel_type": "Petrol",
        "engine": "4.4L V8 M TwinPower Turbo", "horsepower": "530 HP",
        "description": "Supercar performance wrapped in luxury. The M850i is the pinnacle of the 8 Series.",
        "image_url": IMG_8S, "in_stock": True,
        "features": ["xDrive AWD", "Active Exhaust", "M Sport Brakes", "Night Vision Assist"]
    },
    {
        "name": "BMW M8 Gran Coupe", "model": "2024", "category": "Coupe",
        "price": 21500000, "color": "Frozen Arctic Grey", "fuel_type": "Petrol",
        "engine": "4.4L V8 M TwinPower Turbo", "horsepower": "625 HP",
        "description": "The pinnacle of BMW performance. M8 Gran Coupe blends hypercar speed with daily luxury.",
        "image_url": IMG_M8, "in_stock": True,
        "features": ["M Carbon Ceramic Brakes", "M Driver Package", "Bowers & Wilkins Diamond", "M xDrive"]
    },
    {
        "name": "BMW M8 Competition Convertible", "model": "2024", "category": "Convertible",
        "price": 22500000, "color": "Fire Red", "fuel_type": "Petrol",
        "engine": "4.4L V8 M TwinPower Turbo", "horsepower": "625 HP",
        "description": "Open-air supercar experience. The fastest and most exclusive BMW convertible.",
        "image_url": IMG_M8, "in_stock": True,
        "features": ["Retractable Hardtop", "Carbon Fibre Trim", "Head-Up Display", "Sport Exhaust"]
    },

    # ════════════════════════════════════════════
    # X-SERIES (SAV)
    # ════════════════════════════════════════════
    {
        "name": "BMW X1", "model": "2024", "category": "SUV",
        "price": 4900000, "color": "Storm Bay", "fuel_type": "Petrol",
        "engine": "1.5L TwinPower Turbo", "horsepower": "136 HP",
        "description": "Compact, bold, versatile. The perfect entry into BMW's SAV lineup.",
        "image_url": IMG_X1, "in_stock": True,
        "features": ["Curved Display", "xDrive AWD", "Panoramic Roof", "Parking Assistant"]
    },
    {
        "name": "BMW X2 M35i xDrive", "model": "2024", "category": "SUV",
        "price": 5800000, "color": "Frozen Portimao Blue", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "300 HP",
        "description": "The sporty SAV-Coupe. Bold design, raised stance, and M Performance thrills.",
        "image_url": IMG_X2, "in_stock": True,
        "features": ["M Sport Seats", "Sport Exhaust", "Panoramic Roof", "Launch Control"]
    },
    {
        "name": "BMW X3 xDrive30i", "model": "2024", "category": "SUV",
        "price": 6800000, "color": "Phytonic Blue", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "248 HP",
        "description": "The ultimate mid-size SAV. Sporty, versatile, and packed with premium technology.",
        "image_url": IMG_X3, "in_stock": True,
        "features": ["xDrive AWD", "Panoramic Sunroof", "Driving Assistant Pro", "Park Assist Plus"]
    },
    {
        "name": "BMW X3 M Competition", "model": "2024", "category": "SUV",
        "price": 9900000, "color": "Sao Paulo Yellow", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "510 HP",
        "description": "M Performance in an SAV. Track-capable, yet school-run ready. The ultimate all-rounder.",
        "image_url": IMG_X3M, "in_stock": True,
        "features": ["M Compound Brakes", "Sport Exhaust", "Active M Differential", "Launch Control"]
    },
    {
        "name": "BMW X4 M40i", "model": "2024", "category": "SUV",
        "price": 8500000, "color": "Carbon Black", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Turbo Inline-6", "horsepower": "382 HP",
        "description": "SAV-Coupe style with M Performance. Stunning looks and driving dynamics.",
        "image_url": IMG_X4, "in_stock": True,
        "features": ["Coupe Roofline", "Panoramic Sunroof", "Bowers & Wilkins", "xDrive AWD"]
    },
    {
        "name": "BMW X5 xDrive40i", "model": "2024", "category": "SUV",
        "price": 9500000, "color": "Dravit Grey", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Inline-6", "horsepower": "340 HP",
        "description": "The original Sports Activity Vehicle. Exceptional versatility with first-class comfort.",
        "image_url": IMG_X5, "in_stock": True,
        "features": ["3rd Row Seating", "Panoramic Sky Lounge", "Night Vision", "Bowers & Wilkins Diamond"]
    },
    {
        "name": "BMW X5 M Competition", "model": "2024", "category": "SUV",
        "price": 13500000, "color": "Marina Bay Blue", "fuel_type": "Petrol",
        "engine": "4.4L V8 M TwinPower Turbo", "horsepower": "621 HP",
        "description": "The ultimate performance SAV. Supercar pace with 7-seat practicality.",
        "image_url": IMG_X5M, "in_stock": True,
        "features": ["M Ceramic Brakes", "M xDrive", "Sport Exhaust System", "M Active Roll Stabilisation"]
    },
    {
        "name": "BMW X6 M60i", "model": "2024", "category": "SUV",
        "price": 11500000, "color": "Frozen Black", "fuel_type": "Petrol",
        "engine": "4.4L V8 TwinPower Turbo", "horsepower": "530 HP",
        "description": "The iconic SAC — Sports Activity Coupe. Dominant presence and V8 muscle.",
        "image_url": IMG_X6, "in_stock": True,
        "features": ["Coupe Roofline", "Rear Entertainment", "Bang & Olufsen Diamond", "Air Suspension"]
    },
    {
        "name": "BMW X6 M Competition", "model": "2024", "category": "SUV",
        "price": 15500000, "color": "Tanzanite Blue", "fuel_type": "Petrol",
        "engine": "4.4L V8 M TwinPower Turbo", "horsepower": "621 HP",
        "description": "M Performance meets SAC styling. The most powerful coupe-SUV on Indian roads.",
        "image_url": IMG_X6M, "in_stock": True,
        "features": ["M Full Merino Leather", "M Headroom Display", "Night Vision Assist", "4-Wheel Steering"]
    },
    {
        "name": "BMW X7 xDrive40i", "model": "2024", "category": "SUV",
        "price": 13800000, "color": "Mineral White", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Inline-6", "horsepower": "340 HP",
        "description": "BMW's flagship 7-seat SAV. Grandeur, technology, and effortless M Performance.",
        "image_url": IMG_X7, "in_stock": True,
        "features": ["Sky Lounge Panoramic", "3-Row 7 Seats", "Bowers & Wilkins Diamond", "Rear-Axle Steering"]
    },
    {
        "name": "BMW XM", "model": "2024", "category": "SUV",
        "price": 26900000, "color": "Toronto Red", "fuel_type": "Hybrid",
        "engine": "4.4L V8 + Electric Motor (PHEV)", "horsepower": "653 HP",
        "description": "The first M car since M1 that M GmbH designed itself. A bold plug-in hybrid icon.",
        "image_url": IMG_XM, "in_stock": True,
        "features": ["82km EV Range", "M Carbon Ceramic Brakes", "Integral Active Steering", "M Sport Exhaust"]
    },
    {
        "name": "BMW XM Label Red", "model": "2024", "category": "SUV",
        "price": 35900000, "color": "Frozen Carbon Black", "fuel_type": "Hybrid",
        "engine": "4.4L V8 + Electric Motor (PHEV)", "horsepower": "748 HP",
        "description": "The most powerful production BMW ever. XM Label Red — for those who demand the extraordinary.",
        "image_url": IMG_XM, "in_stock": True,
        "features": ["0-100 in 3.8s", "Red Accent Package", "Full Carbon Interior", "Limited Edition"]
    },

    # ════════════════════════════════════════════
    # Z-SERIES (Roadster)
    # ════════════════════════════════════════════
    {
        "name": "BMW Z4 sDrive20i", "model": "2024", "category": "Convertible",
        "price": 6500000, "color": "Misano Blue", "fuel_type": "Petrol",
        "engine": "2.0L TwinPower Turbo", "horsepower": "197 HP",
        "description": "Entry into open-top roadster luxury. Elegant, lightweight, and driving-focused.",
        "image_url": IMG_Z4, "in_stock": True,
        "features": ["Retractable Soft Top", "Sport Seats", "Digital Cockpit", "Active Cruise Control"]
    },
    {
        "name": "BMW Z4 M40i", "model": "2024", "category": "Convertible",
        "price": 8500000, "color": "San Francisco Red", "fuel_type": "Petrol",
        "engine": "3.0L TwinPower Inline-6", "horsepower": "382 HP",
        "description": "Pure roadster emotion. The M40i Z4 delivers addictive open-air exhilaration.",
        "image_url": IMG_Z4, "in_stock": True,
        "features": ["Adaptive M Suspension", "Harman Kardon", "Sport Exhaust", "M Sport Brakes"]
    },

    # ════════════════════════════════════════════
    # M2/M3/M4/M5/M8 Pure
    # ════════════════════════════════════════════
    {
        "name": "BMW M2 Coupe", "model": "2024", "category": "Sports",
        "price": 8500000, "color": "Zandvoort Blue", "fuel_type": "Petrol",
        "engine": "3.0L Twin-Turbo S58", "horsepower": "460 HP",
        "description": "The most driver-focused BMW ever made. Raw, precise, and absolutely thrilling.",
        "image_url": IMG_M2, "in_stock": True,
        "features": ["Track Mode", "M Traction Control", "M Carbon Interior", "Launch Control"]
    },

    # ════════════════════════════════════════════
    # i-SERIES (Electric)
    # ════════════════════════════════════════════
    {
        "name": "BMW iX1 xDrive30", "model": "2024", "category": "Electric SUV",
        "price": 6700000, "color": "Phytonic Blue", "fuel_type": "Electric",
        "engine": "Dual Motor Electric", "horsepower": "313 HP",
        "description": "Compact electric SAV. Zero emissions with full xDrive performance and BMW premium.",
        "image_url": IMG_IX1, "in_stock": True,
        "features": ["440km Range", "DC Fast Charge 130kW", "Curved Display", "Parking Assist Plus"]
    },
    {
        "name": "BMW iX3 Electric", "model": "2024", "category": "Electric SUV",
        "price": 8900000, "color": "Glacier Silver", "fuel_type": "Electric",
        "engine": "Single Rear Motor Electric", "horsepower": "286 HP",
        "description": "Zero emissions, zero compromise. 460km range with everyday X3 practicality.",
        "image_url": IMG_IX3, "in_stock": True,
        "features": ["460km Range", "DC Fast Charging", "Recuperation Paddles", "Recycled Interior"]
    },
    {
        "name": "BMW i4 eDrive40", "model": "2024", "category": "Electric Sedan",
        "price": 7500000, "color": "Portimao Blue", "fuel_type": "Electric",
        "engine": "Single Rear Motor Electric", "horsepower": "340 HP",
        "description": "The electric 4 Gran Coupe. Seamless luxury with 590km of zero-emission range.",
        "image_url": IMG_I4, "in_stock": True,
        "features": ["590km Range", "DC Fast Charge 205kW", "Gran Coupe Styling", "Wireless CarPlay"]
    },
    {
        "name": "BMW i4 M50", "model": "2024", "category": "Electric Sedan",
        "price": 9500000, "color": "Frozen Dark Grey", "fuel_type": "Electric",
        "engine": "Dual Motor Electric (M)", "horsepower": "536 HP",
        "description": "The electric M car. 0-100 in 3.9 seconds, 520km range, and pure M dynamics.",
        "image_url": IMG_I4, "in_stock": True,
        "features": ["0-100 in 3.9s", "M Sport Differential", "Active Sound Design", "M Compound Brakes"]
    },
    {
        "name": "BMW i5 M60 xDrive", "model": "2024", "category": "Electric Sedan",
        "price": 13500000, "color": "Carbon Black", "fuel_type": "Electric",
        "engine": "Dual Motor Electric (M)", "horsepower": "601 HP",
        "description": "The M performance electric 5 Series. Effortless power with executive luxury.",
        "image_url": IMG_I5, "in_stock": True,
        "features": ["0-100 in 3.8s", "582km Range", "M Sport Pro Package", "Executive Lounge"]
    },
    {
        "name": "BMW iX xDrive50", "model": "2024", "category": "Electric SUV",
        "price": 12000000, "color": "Mineral White", "fuel_type": "Electric",
        "engine": "Dual Motor Electric", "horsepower": "523 HP",
        "description": "The future of BMW. 630km range with ultra-fast charging and autonomous tech.",
        "image_url": IMG_IX, "in_stock": True,
        "features": ["630km Range", "200kW Charging", "BMW Personal CoPilot", "Sustainable Interior"]
    },
    {
        "name": "BMW iX M60", "model": "2024", "category": "Electric SUV",
        "price": 15500000, "color": "Frozen Deep Grey", "fuel_type": "Electric",
        "engine": "Dual Motor Electric (M)", "horsepower": "619 HP",
        "description": "M Performance meets electric future. The fastest BMW electric SAV with 0-100 in 3.8s.",
        "image_url": IMG_IX, "in_stock": True,
        "features": ["0-100 in 3.8s", "566km Range", "M Compound Brakes", "Bowers & Wilkins Diamond"]
    },
    {
        "name": "BMW i7 xDrive60", "model": "2024", "category": "Electric Sedan",
        "price": 22000000, "color": "Sophisto Grey", "fuel_type": "Electric",
        "engine": "Dual Motor Electric", "horsepower": "544 HP",
        "description": "The pinnacle of electric luxury. 31.3-inch Theatre Screen and 625km of silent range.",
        "image_url": IMG_I7, "in_stock": True,
        "features": ["625km Range", "Theater Screen 31.3''", "Executive Lounge Plus", "Sky Lounge Roof"]
    },
    {
        "name": "BMW i7 M70 xDrive", "model": "2024", "category": "Electric Sedan",
        "price": 26500000, "color": "Frozen Black", "fuel_type": "Electric",
        "engine": "Dual Motor Electric (M)", "horsepower": "660 HP",
        "description": "The world's first M Performance electric 7 Series. 0-100 in 3.7s with ultimate luxury.",
        "image_url": IMG_I7, "in_stock": True,
        "features": ["0-100 in 3.7s", "M Sport Package Pro", "Bowers & Wilkins Diamond", "Theater Screen"]
    },
]

# ── Drop existing cars and insert all new ones ──
db.cars.drop()
result = db.cars.insert_many(cars)
print(f"✅ {len(result.inserted_ids)} BMW models inserted successfully!")
print("Models added:")
for car in cars:
    print(f"  • {car['name']} ({car['model']}) - ₹{car['price']:,} - {car['category']}")
