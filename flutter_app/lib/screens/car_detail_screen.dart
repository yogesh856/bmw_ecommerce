import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_provider.dart';
import '../services/cart_provider.dart';
import '../services/app_utils.dart';
import '../services/design_system.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class CarDetailScreen extends StatefulWidget {
  final String carId;
  final String carName;
  const CarDetailScreen(
      {super.key, required this.carId, required this.carName});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  Map<String, dynamic>? car;
  List<dynamic> otherCars = [];
  bool isLoading = true;
  bool reserving = false;
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    try {
      final data = await ApiService.getCarById(widget.carId);
      final others = await ApiService.getAllCars();
      setState(() {
        car = data;
        otherCars =
            others.where((c) => c['_id'] != widget.carId).take(4).toList();
        selectedColor = car?['color'];
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void _reserveVehicle() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final cp = Provider.of<CartProvider>(context, listen: false);
    if (user.userId == null) {
      _snack('Please login to reserve!', isError: true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
    setState(() => reserving = true);
    try {
      await cp.addItem(user.userId!, car!['_id'],
          color: selectedColor ?? car!['color']);
      if (!mounted) return;
      setState(() => reserving = false);
      _showReservationDialog();
    } catch (e) {
      setState(() => reserving = false);
      _snack(e.toString().replaceAll('Exception: ', ''), isError: true);
    }
  }

  void _showReservationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: DS.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 36, 32, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                    color: DS.primary, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              const Text('VEHICLE RESERVED',
                  style: TextStyle(
                      color: DS.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1)),
              const SizedBox(height: 12),
              Text(
                'Your ${car!['name'] ?? 'vehicle'} has been successfully reserved. Our team will contact you shortly.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: DS.onSurfaceMid, fontSize: 13, height: 1.6),
              ),
              const SizedBox(height: 28),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      color: DS.surfaceHigh,
                      child: const Center(
                        child: Text('CONTINUE',
                            style: TextStyle(
                                color: DS.onSurfaceMid,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CartScreen()));
                    },
                    child: Container(
                      height: 44,
                      color: DS.primary,
                      child: const Center(
                        child: Text('VIEW CART',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5)),
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _snack(String msg, {bool isError = false}) {
    AppUtils.showSnack(context, msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: DS.bg,
        body: Center(child: CircularProgressIndicator(color: DS.primary)),
      );
    }
    if (car == null) {
      return Scaffold(
        backgroundColor: DS.bg,
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Car not found', style: TextStyle(color: DS.onSurface)),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Go back', style: TextStyle(color: DS.primary))),
        ])),
      );
    }

    final features = List<String>.from(car!['features'] ?? []);
    final isWide = MediaQuery.of(context).size.width > 750;
    final modelName = (car!['name'] ?? '').toString().toUpperCase();

    return Scaffold(
      backgroundColor: DS.bg,
      body: CustomScrollView(
        slivers: [
          // ── NAV BAR ─────────────────────────────────────
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: DS.surface.withOpacity(0.97),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.arrow_back_ios, color: DS.onSurface, size: 16),
                ],
              ),
            ),
            title: const Text('BMW',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3)),
            centerTitle: false,
            actions: [
              Consumer<CartProvider>(
                  builder: (_, cp, __) => Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined,
                                color: DS.onSurfaceMid),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CartScreen())),
                          ),
                          if (cp.itemCount > 0)
                            Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                      color: DS.primary,
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Text('${cp.itemCount}',
                                          style: const TextStyle(
                                              fontSize: 8,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                )),
                        ],
                      )),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HERO ────────────────────────────────────
                SizedBox(
                  height: isWide ? 460 : 320,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Car image
                      car!['image_url'] != null &&
                              car!['image_url'].toString().isNotEmpty
                          ? Image.network(car!['image_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: DS.surfaceMid))
                          : Container(color: DS.surfaceMid),
                      // Left gradient
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.transparent, DS.bg],
                            stops: [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Bottom gradient
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [DS.bg, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                      // Category badge + title
                      Positioned(
                        left: 28,
                        bottom: 36,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              color: DS.primary,
                              child: Text(
                                (car!['category'] ?? '')
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'THE ${modelName.replaceAll('BMW', '').trim()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: isWide ? 64 : 40,
                                height: 0.95,
                                letterSpacing: -2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── DESCRIPTION ─────────────────────────────
                Container(
                  color: DS.surface,
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: isWide ? 520 : double.infinity,
                        child: Text(car!['description'] ?? '',
                            style: const TextStyle(
                                color: DS.onSurfaceMid,
                                fontSize: 15,
                                height: 1.7)),
                      ),
                    ],
                  ),
                ),

                // ── KEY STATS ────────────────────────────────
                Container(
                  color: DS.surfaceLow,
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
                  child: isWide
                      ? Row(children: _statWidgets(car!))
                      : Wrap(
                          spacing: 24,
                          runSpacing: 20,
                          children: _statWidgets(car!)),
                ),

                // ── FEATURE SECTIONS ─────────────────────────
                if (features.isNotEmpty) ...[
                  // Feature 1 — image left, text right
                  Container(
                    color: DS.surfaceMid,
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: _featureImage(car!['image_url'])),
                              Expanded(
                                  flex: 4,
                                  child: _featureText(
                                    'Executive Lounge',
                                    car!['description'] ?? '',
                                    features.take(2).toList(),
                                  )),
                            ],
                          )
                        : Column(children: [
                            _featureImage(car!['image_url'], height: 220),
                            _featureText(
                                'Executive Lounge',
                                car!['description'] ?? '',
                                features.take(2).toList()),
                          ]),
                  ),

                  // Feature 2 — text left, image right
                  Container(
                    color: DS.surfaceLow,
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: _featureText(
                                    features.length > 2
                                        ? features[2]
                                        : 'Premium Experience',
                                    'Precision-engineered for the ultimate driving experience. Every detail crafted to perfection.',
                                    features.skip(2).take(2).toList(),
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: _featureImage(car!['image_url'])),
                            ],
                          )
                        : Column(children: [
                            _featureText(
                              features.length > 2
                                  ? features[2]
                                  : 'Premium Experience',
                              'Precision-engineered for the ultimate driving experience.',
                              features.skip(2).take(2).toList(),
                            ),
                            _featureImage(car!['image_url'], height: 220),
                          ]),
                  ),
                ],

                // ── CUSTOMIZATION ───────────────────────────
                Container(
                  color: DS.surface,
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Expanded(child: _customizationPanel(car!)),
                              const SizedBox(width: 40),
                              Expanded(child: _carVisualPanel(car!)),
                            ])
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              _customizationPanel(car!),
                              const SizedBox(height: 32),
                              _carVisualPanel(car!),
                            ]),
                ),

                // ── EXPLORE THE LINEUP ───────────────────────
                if (otherCars.isNotEmpty) ...[
                  Container(
                    color: DS.surfaceLow,
                    padding: const EdgeInsets.fromLTRB(28, 40, 0, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('EXPLORE THE LINEUP',
                                style: TextStyle(
                                    color: DS.onSurface,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: otherCars.length,
                            itemBuilder: (_, i) =>
                                _LineupCard(car: otherCars[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── FOOTER ───────────────────────────────────
                const _DetailFooter(),
              ],
            ),
          ),
        ],
      ),

      // ── STICKY BOTTOM BAR ───────────────────────────────
      bottomNavigationBar: Container(
        color: DS.surface,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('STARTING AT',
                    style: TextStyle(
                        color: DS.onSurfaceDim,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2)),
                Text(AppUtils.formatPrice(car!['price']),
                    style: const TextStyle(
                        color: DS.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(width: 20),
            // Reserve Vehicle
            Expanded(
              child: _ActionBtn(
                label: reserving ? 'RESERVING...' : 'RESERVE VEHICLE',
                icon: reserving
                    ? Icons.hourglass_top_rounded
                    : Icons.bookmark_add_outlined,
                onTap: reserving ? null : _reserveVehicle,
                isPrimary: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _statWidgets(Map car) {
    final stats = [
      {
        'label': '0 TO 100',
        'unit': 's',
        'value': _extractStat(car['horsepower'] ?? '', '4.7')
      },
      {'label': 'MAX RANGE', 'unit': 'km', 'value': _extractRange(car)},
      {
        'label': 'MAX POWER',
        'unit': 'hp',
        'value': _extractHP(car['horsepower'] ?? '')
      },
    ];
    return stats
        .expand((s) => [
              _StatTile(
                  label: s['label']!, value: s['value']!, unit: s['unit']!),
              if (s != stats.last)
                Container(
                    width: 1,
                    height: 60,
                    color: DS.outlineVariant.withOpacity(0.2)),
            ])
        .toList();
  }

  String _extractStat(String _, String fallback) => fallback;
  String _extractRange(Map car) {
    if (car['fuel_type'] == 'Electric') return '630';
    if (car['fuel_type'] == 'Hybrid') return '900';
    return '1100';
  }

  String _extractHP(String hp) {
    final match = RegExp(r'(\d+)').firstMatch(hp);
    return match?.group(1) ?? '—';
  }

  Widget _featureImage(String? url, {double height = 340}) => SizedBox(
        height: height,
        child: Stack(fit: StackFit.expand, children: [
          Container(color: DS.surfaceMid),
          if (url != null && url.isNotEmpty)
            Image.network(url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink()),
        ]),
      );

  Widget _featureText(String title, String body, List<String> bullets) =>
      Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    color: DS.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5)),
            const SizedBox(height: 14),
            Text(body,
                style: const TextStyle(
                    color: DS.onSurfaceMid, fontSize: 13, height: 1.7)),
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 20),
              ...bullets.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(children: [
                      Container(width: 4, height: 4, color: DS.primary),
                      const SizedBox(width: 10),
                      Text(b,
                          style: const TextStyle(
                              color: DS.onSurfaceMid, fontSize: 12)),
                    ]),
                  )),
            ],
          ],
        ),
      );

  Widget _customizationPanel(Map car) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CUSTOMIZATION',
              style: TextStyle(
                  color: DS.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5)),
          const SizedBox(height: 28),
          const Text('EXTERIOR FINISH',
              style: TextStyle(
                  color: DS.onSurfaceDim,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2)),
          const SizedBox(height: 12),
          // Color swatches - Row 1
          Row(children: [
            _colorSwatch(const Color(0xFF1A1A1A), 'Black Night'),
            const SizedBox(width: 10),
            _colorSwatch(const Color(0xFF6B6B6B), 'Arctic Grey'),
            const SizedBox(width: 10),
            _colorSwatch(DS.primary, 'M Phytonic Blue'),
          ]),
          const SizedBox(height: 10),
          // Color swatches - Row 2
          Row(children: [
            _colorSwatch(const Color(0xFFE5E2E1), 'Alpine White'),
            const SizedBox(width: 10),
            _colorSwatch(const Color(0xFFB91C1C), 'Melbourne Red'),
            const SizedBox(width: 10),
            _colorSwatch(const Color(0xFF166534), 'San Remo Green'),
          ]),
          const SizedBox(height: 28),
          Text(selectedColor ?? car['color'] ?? '',
              style: const TextStyle(color: DS.onSurfaceMid, fontSize: 12)),
          const SizedBox(height: 28),
          // Specs row
          const Text('SPECIFICATIONS',
              style: TextStyle(
                  color: DS.onSurfaceDim,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2)),
          const SizedBox(height: 14),
          _specRow('Engine', car['engine'] ?? '—'),
          _specRow('Fuel Type', car['fuel_type'] ?? '—'),
          _specRow('Horsepower', car['horsepower'] ?? '—'),
          _specRow('Year', car['model'] ?? '—'),
        ],
      );

  Color get _selectedColorValue {
    switch (selectedColor) {
      case 'Black Night':
        return const Color(0xFF1A1A1A);
      case 'Arctic Grey':
        return const Color(0xFF6B6B6B);
      case 'M Phytonic Blue':
        return DS.primary;
      case 'Alpine White':
        return const Color(0xFFE5E2E1);
      case 'Melbourne Red':
        return const Color(0xFFB91C1C);
      case 'San Remo Green':
        return const Color(0xFF166534);
      default:
        return Colors.transparent;
    }
  }

  Widget _colorSwatch(Color color, String name) {
    final sel = selectedColor == name;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = name),
      child: Column(children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            border: sel
                ? Border.all(color: DS.primary, width: 2)
                : Border.all(color: DS.outlineVariant.withOpacity(0.2)),
          ),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: DS.onSurfaceDim, fontSize: 8)),
      ]),
    );
  }

  Widget _specRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(
                      color: DS.onSurfaceDim,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(color: DS.onSurface, fontSize: 12))),
        ]),
      );

  Widget _carVisualPanel(Map car) {
    // For realistic car visualization with color customization
    // Using car images with color blend mode (since free BMW 3D models aren't available)
    final imageUrl = car['image_url'] ?? 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800';
    
    return Container(
        height: 380,
        color: DS.surfaceMid,
        child: Stack(fit: StackFit.expand, children: [
          // Base car image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: DS.surfaceMid,
              child: const Center(
                child: Icon(Icons.directions_car, color: DS.onSurfaceMid, size: 80),
              ),
            ),
          ),
          // Color overlay using blend mode for realistic color change
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _selectedColorValue == Colors.transparent
                      ? Colors.transparent
                      : _selectedColorValue.withOpacity(0.45),
                  _selectedColorValue == Colors.transparent
                      ? Colors.transparent
                      : _selectedColorValue.withOpacity(0.25),
                ],
              ),
              backgroundBlendMode: BlendMode.color,
            ),
          ),
          // Bottom fade gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [DS.surfaceMid, Colors.transparent],
                ),
              ),
            ),
          ),
          // Color indicator badge
          Positioned(
            top: 16,
            right: 16,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: DS.surface.withOpacity(0.9),
                border: Border.all(color: _selectedColorValue == Colors.transparent 
                    ? DS.outlineVariant.withOpacity(0.3) 
                    : _selectedColorValue.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _selectedColorValue == Colors.transparent 
                          ? DS.onSurfaceMid 
                          : _selectedColorValue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedColor ?? car['color'] ?? 'SELECT COLOR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Color customization hint
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: DS.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.palette_outlined, color: DS.onSurfaceMid, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'SELECT COLOR BELOW',
                      style: TextStyle(
                        color: DS.onSurfaceMid,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      );
  }
}

// ─────────────────────────────────────────────────────────
// STAT TILE
// ─────────────────────────────────────────────────────────
class _StatTile extends StatelessWidget {
  final String label, value, unit;
  const _StatTile(
      {required this.label, required this.value, required this.unit});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(
                    color: DS.onSurfaceDim,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2)),
            const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(value,
                  style: const TextStyle(
                      color: DS.onSurface,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1)),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(unit,
                    style: const TextStyle(
                        color: DS.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// LINEUP CARD
// ─────────────────────────────────────────────────────────
class _LineupCard extends StatelessWidget {
  final Map<String, dynamic> car;
  const _LineupCard({required this.car});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    CarDetailScreen(carId: car['_id'], carName: car['name']))),
        child: Container(
          width: 200,
          margin: const EdgeInsets.only(right: 12),
          color: DS.surfaceHigh,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 130,
              child: Stack(fit: StackFit.expand, children: [
                Container(color: DS.surfaceMid),
                if (car['image_url'] != null)
                  Image.network(car['image_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((car['fuel_type'] ?? '').toString().toUpperCase(),
                        style: const TextStyle(
                            color: DS.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 4),
                    Text(car['name'] ?? '',
                        style: const TextStyle(
                            color: DS.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w900),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text('From ${AppUtils.formatPriceShort(car['price'])}',
                        style: const TextStyle(
                            color: DS.onSurfaceMid, fontSize: 11)),
                  ]),
            ),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// BOTTOM BAR BUTTONS
// ─────────────────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  const _ActionBtn(
      {required this.label,
      required this.icon,
      required this.onTap,
      required this.isPrimary});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          color: isPrimary ? DS.primary : DS.surfaceHigh,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon,
                color: isPrimary ? Colors.white : DS.onSurfaceMid, size: 16),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: isPrimary ? Colors.white : DS.onSurfaceMid,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5)),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// DETAIL FOOTER (compact)
// ─────────────────────────────────────────────────────────
class _DetailFooter extends StatelessWidget {
  const _DetailFooter();
  @override
  Widget build(BuildContext context) => Container(
        color: DS.surface,
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 1, color: DS.outlineVariant.withOpacity(0.15)),
          const SizedBox(height: 24),
          Row(children: [
            const Text('BMW',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3)),
            const Spacer(),
            ...['Legal Notice', 'Cookie Policy', 'Privacy Policy'].map((l) =>
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(l,
                        style: const TextStyle(
                            color: DS.onSurfaceDim, fontSize: 11)))),
          ]),
          const SizedBox(height: 12),
          const Text('© 2024 BMW AG. All rights reserved.',
              style: TextStyle(color: DS.onSurfaceDim, fontSize: 11)),
        ]),
      );
}
