import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_provider.dart';
import '../services/cart_provider.dart';
import '../services/app_utils.dart';
import '../services/design_system.dart';
import 'car_detail_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'login_screen.dart';

class VehicleInventoryScreen extends StatefulWidget {
  final String? initialCategory;
  const VehicleInventoryScreen({super.key, this.initialCategory});
  @override
  State<VehicleInventoryScreen> createState() => _VehicleInventoryScreenState();
}

class _VehicleInventoryScreenState extends State<VehicleInventoryScreen> {
  List<dynamic> cars     = [];
  List<dynamic> filtered = [];
  bool isLoading         = true;
  String selCategory     = 'All';
  String selFuel         = 'All';
  final searchCtrl       = TextEditingController();

  final categories = ['All', 'Sedan', 'SUV', 'Coupe', 'Sports', 'Electric SUV', 'Luxury Sedan'];
  final fuels      = ['All', 'Petrol', 'Hybrid', 'Electric'];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      selCategory = widget.initialCategory!;
    }
    _load();
  }
  @override
  void dispose()   { searchCtrl.dispose(); super.dispose(); }

  void _load() async {
    try {
      final data = await ApiService.getAllCars();
      setState(() { cars = data; filtered = data; isLoading = false; });
    } catch (_) { setState(() => isLoading = false); }
  }

  void _applyFilters() {
    final q = searchCtrl.text.toLowerCase();
    setState(() {
      filtered = cars.where((c) {
        final catOk  = selCategory == 'All' || c['category'] == selCategory;
        final fuelOk = selFuel == 'All' || c['fuel_type'] == selFuel;
        final nameOk = q.isEmpty || (c['name'] ?? '').toLowerCase().contains(q);
        return catOk && fuelOk && nameOk;
      }).toList();
    });
  }

  void _setCategory(String v) { selCategory = v; _applyFilters(); }
  void _setFuel(String v)     { selFuel = v;     _applyFilters(); }

  @override
  Widget build(BuildContext context) {
    final user  = Provider.of<UserProvider>(context);
    final cart  = Provider.of<CartProvider>(context);
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: DS.bg,
      body: Column(
        children: [
          // ── TOP NAV BAR ───────────────────────────────
          Container(
            height: 64,
            color: DS.surface.withOpacity(0.97),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: DS.onSurface, size: 16),
                      SizedBox(width: 8),
                      Text('BMW',
                        style: TextStyle(color: Colors.white, fontSize: 18,
                            fontWeight: FontWeight.w900, letterSpacing: 3)),
                    ],
                  ),
                ),
                const Spacer(),
                // Search
                SizedBox(
                  width: 200, height: 32,
                  child: Container(
                    color: DS.surfaceHigh,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (_) => _applyFilters(),
                      style: const TextStyle(color: DS.onSurface, fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Search models...',
                        hintStyle: TextStyle(color: DS.onSurfaceDim, fontSize: 11),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 7),
                        prefixIcon: Icon(Icons.search, color: DS.primary, size: 14),
                        prefixIconConstraints: BoxConstraints(minWidth: 28),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Cart icon
                Stack(children: [
                  _iconBtn(Icons.shopping_bag_outlined, () =>
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
                  if (cart.itemCount > 0)
                    Positioned(right: 4, top: 4, child: Container(
                      width: 14, height: 14,
                      decoration: const BoxDecoration(color: DS.primary, shape: BoxShape.circle),
                      child: Center(child: Text('${cart.itemCount}',
                          style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold))),
                    )),
                ]),
                const SizedBox(width: 2),
                _iconBtn(Icons.receipt_long_outlined, () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()))),
                const SizedBox(width: 2),
                _iconBtn(Icons.person_outline, () {
                  final cp = Provider.of<CartProvider>(context, listen: false);
                  user.logout(); cp.clearLocal();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                }),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── HERO HEADER ───────────────────────
                  Container(
                    color: DS.surface,
                    padding: const EdgeInsets.fromLTRB(32, 52, 32, 44),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('THE MODELS',
                          style: TextStyle(
                            color: DS.onSurface,
                            fontSize: isWide ? 88 : 52,
                            fontWeight: FontWeight.w900,
                            height: 0.95,
                            letterSpacing: -2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(
                          width: 420,
                          child: Text(
                            'Experience the ultimate driving machine. From the precision of the M series to the innovative electric future of the i series.',
                            style: TextStyle(color: DS.onSurfaceMid, fontSize: 14, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── MAIN CONTENT ─────────────────────
                  Container(
                    color: DS.surfaceLow,
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 220, child: _Sidebar(
                                selCategory: selCategory, onCategory: _setCategory,
                                selFuel: selFuel, onFuel: _setFuel,
                                categories: categories, fuels: fuels,
                              )),
                              Container(width: 1, color: DS.outlineVariant.withOpacity(0.15)),
                              Expanded(child: _GridArea(
                                filtered: filtered, isLoading: isLoading,
                                count: filtered.length,
                              )),
                            ],
                          )
                        : Column(children: [
                            _MobileFilters(
                              selCategory: selCategory, onCategory: _setCategory,
                              categories: categories,
                            ),
                            _GridArea(
                              filtered: filtered, isLoading: isLoading,
                              count: filtered.length,
                            ),
                          ]),
                  ),

                  // ── FOOTER ───────────────────────────
                  const _InventoryFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: SizedBox(width: 36, height: 36,
      child: Icon(icon, color: DS.onSurfaceMid, size: 20)),
  );
}

// ─────────────────────────────────────────────────────────
// SIDEBAR
// ─────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final String selCategory;
  final Function(String) onCategory;
  final String selFuel;
  final Function(String) onFuel;
  final List<String> categories;
  final List<String> fuels;
  const _Sidebar({required this.selCategory, required this.onCategory,
    required this.selFuel, required this.onFuel,
    required this.categories, required this.fuels});

  @override
  Widget build(BuildContext context) => Container(
    color: DS.surfaceMid,
    padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('BODY STYLE'),
        const SizedBox(height: 10),
        ...categories.map((cat) => _catItem(cat)),
        const SizedBox(height: 28),
        _label('FUEL TYPE'),
        const SizedBox(height: 10),
        ...fuels.map((f) => _fuelItem(f)),
      ],
    ),
  );

  Widget _label(String txt) => Text(txt,
    style: const TextStyle(color: DS.onSurfaceDim, fontSize: 10,
        fontWeight: FontWeight.w700, letterSpacing: 2));

  Widget _catItem(String val) {
    final active = val == selCategory;
    return GestureDetector(
      onTap: () => onCategory(val),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(
            color: active ? DS.primary : Colors.transparent, width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(val, style: TextStyle(
            color: active ? Colors.white : DS.onSurfaceMid,
            fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.normal,
          )),
        ),
      ),
    );
  }

  Widget _fuelItem(String val) {
    final active = val == selFuel;
    return GestureDetector(
      onTap: () => onFuel(val),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              color: active ? DS.primary : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: active ? DS.primary : DS.outlineVariant),
            ),
            child: active ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
          ),
          const SizedBox(width: 10),
          Text(val, style: TextStyle(
            color: active ? Colors.white : DS.onSurfaceMid, fontSize: 13)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// MOBILE FILTERS
// ─────────────────────────────────────────────────────────
class _MobileFilters extends StatelessWidget {
  final String selCategory;
  final Function(String) onCategory;
  final List<String> categories;
  const _MobileFilters({required this.selCategory, required this.onCategory, required this.categories});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final cat = categories[i];
        final sel = cat == selCategory;
        return GestureDetector(
          onTap: () => onCategory(cat),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: sel ? DS.primary : DS.surfaceHigh,
            child: Center(child: Text(cat, style: TextStyle(
              color: sel ? Colors.white : DS.onSurfaceMid,
              fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1,
            ))),
          ),
        );
      },
    ),
  );
}

// ─────────────────────────────────────────────────────────
// GRID AREA
// ─────────────────────────────────────────────────────────
class _GridArea extends StatelessWidget {
  final List<dynamic> filtered;
  final bool isLoading;
  final int count;
  const _GridArea({required this.filtered, required this.isLoading, required this.count});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final crossCount = w > 1100 ? 3 : w > 750 ? 2 : 1;

    return Container(
      color: DS.surfaceLow,
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SHOWING $count VEHICLES',
            style: const TextStyle(color: DS.onSurfaceDim, fontSize: 11,
                fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 28),
          isLoading
              ? const Center(child: Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: CircularProgressIndicator(color: DS.primary)))
              : filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Text('No models found',
                          style: TextStyle(color: DS.onSurfaceDim)))
                  : _buildGrid(crossCount),

          if (!isLoading && filtered.isNotEmpty) ...[
            const SizedBox(height: 44),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: DS.outlineVariant.withOpacity(0.3)),
                ),
                child: const Text('SHOW MORE MODELS',
                  style: TextStyle(color: DS.onSurfaceMid, fontSize: 12,
                      fontWeight: FontWeight.w700, letterSpacing: 2)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid(int crossCount) {
    final rows = <Widget>[];
    for (var i = 0; i < filtered.length; i += crossCount) {
      final rowItems = <Widget>[];
      for (var j = i; j < i + crossCount && j < filtered.length; j++) {
        rowItems.add(Expanded(child: _CarCard(car: filtered[j])));
        if (j < i + crossCount - 1 && j < filtered.length - 1) {
          rowItems.add(const SizedBox(width: 12));
        }
      }
      if (rowItems.length < crossCount * 2 - 1) {
        final filled = (rowItems.length + 1) ~/ 2;
        for (var k = filled; k < crossCount; k++) {
          rowItems.add(const SizedBox(width: 12));
          rowItems.add(const Expanded(child: SizedBox.shrink()));
        }
      }
      rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: rowItems));
      if (i + crossCount < filtered.length) rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }
}

// ─────────────────────────────────────────────────────────
// CAR CARD
// ─────────────────────────────────────────────────────────
class _CarCard extends StatefulWidget {
  final Map<String, dynamic> car;
  const _CarCard({required this.car});
  @override State<_CarCard> createState() => _CarCardState();
}
class _CarCardState extends State<_CarCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) =>
                CarDetailScreen(carId: car['_id'], carName: car['name']))),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_hovered ? 1.02 : 1.0),
          color: DS.surfaceHigh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(fit: StackFit.expand, children: [
                  Container(color: DS.surfaceMid),
                  car['image_url'] != null && car['image_url'].toString().isNotEmpty
                      ? Image.network(car['image_url'], fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.directions_car, color: DS.primary, size: 48)))
                      : const Center(child: Icon(Icons.directions_car, color: DS.primary, size: 48)),
                  Container(decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.35)],
                    ),
                  )),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${car['fuel_type'] ?? ''} · ${car['horsepower'] ?? ''}',
                      style: const TextStyle(color: DS.primary, fontSize: 10,
                          fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                    const SizedBox(height: 6),
                    Text((car['name'] ?? '').toString().toUpperCase(),
                      style: const TextStyle(color: DS.onSurface, fontSize: 20,
                          fontWeight: FontWeight.w900, letterSpacing: -0.4, height: 1.1),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 14),
                    const Text('STARTING AT',
                      style: TextStyle(color: DS.onSurfaceDim, fontSize: 9,
                          fontWeight: FontWeight.w700, letterSpacing: 2)),
                    const SizedBox(height: 3),
                    Text(AppUtils.formatPrice(car['price']),
                      style: const TextStyle(color: DS.onSurface, fontSize: 22,
                          fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(child: _GhostBtn(label: 'EXPLORE', onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            CarDetailScreen(carId: car['_id'], carName: car['name']))))),
                      const SizedBox(width: 8),
                      Expanded(child: _PrimaryBtn(label: 'BOOK NOW', onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            CarDetailScreen(carId: car['_id'], carName: car['name']))))),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// BUTTONS
// ─────────────────────────────────────────────────────────
class _PrimaryBtn extends StatefulWidget {
  final String label; final VoidCallback onTap;
  const _PrimaryBtn({required this.label, required this.onTap});
  @override State<_PrimaryBtn> createState() => _PrimaryBtnState();
}
class _PrimaryBtnState extends State<_PrimaryBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40,
        color: _h ? DS.primaryGlow.withOpacity(0.2) : DS.primary,
        child: Center(child: Text(widget.label,
          style: const TextStyle(color: Colors.white, fontSize: 11,
              fontWeight: FontWeight.w700, letterSpacing: 1.5))),
      ),
    ),
  );
}

class _GhostBtn extends StatefulWidget {
  final String label; final VoidCallback onTap;
  const _GhostBtn({required this.label, required this.onTap});
  @override State<_GhostBtn> createState() => _GhostBtnState();
}
class _GhostBtnState extends State<_GhostBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40,
        decoration: BoxDecoration(
          color: _h ? DS.surfaceTop : Colors.transparent,
          border: Border.all(color: DS.outlineVariant.withOpacity(0.3)),
        ),
        child: Center(child: Text(widget.label,
          style: const TextStyle(color: DS.onSurfaceMid, fontSize: 11,
              fontWeight: FontWeight.w700, letterSpacing: 1.5))),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────
class _InventoryFooter extends StatelessWidget {
  const _InventoryFooter();
  @override
  Widget build(BuildContext context) => Container(
    color: DS.surface,
    padding: const EdgeInsets.fromLTRB(32, 44, 32, 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: DS.outlineVariant.withOpacity(0.15)),
        const SizedBox(height: 24),
        Row(children: [
          const Text('BMW', style: TextStyle(color: Colors.white,
              fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 3)),
          const Spacer(),
          ...['Legal Notice', 'Cookie Policy', 'Privacy Policy'].map((l) =>
            Padding(padding: const EdgeInsets.only(left: 20),
              child: Text(l, style: const TextStyle(color: DS.onSurfaceDim, fontSize: 11)))),
        ]),
        const SizedBox(height: 12),
        const Text('© 2024 BMW AG. All rights reserved.',
          style: TextStyle(color: DS.onSurfaceDim, fontSize: 11)),
      ],
    ),
  );
}
