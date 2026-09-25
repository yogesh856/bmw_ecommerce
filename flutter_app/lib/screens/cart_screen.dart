import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../services/cart_provider.dart';
import '../services/api_service.dart';
import '../services/app_utils.dart';
import '../services/design_system.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isPlacing = false;

  // ── BMW Showrooms List ──
  static const List<Map<String, String>> _showrooms = [
    {'name': 'BMW Mumbai - Navnit Motors', 'address': 'Navnit Motors, Western Express Highway, Goregaon East, Mumbai - 400063'},
    {'name': 'BMW Delhi - Bird Automotive', 'address': 'Bird Automotive, Nelson Mandela Road, Vasant Kunj, New Delhi - 110070'},
    {'name': 'BMW Bangalore - Navnit Motors', 'address': 'Navnit Motors, Lavelle Road, Ashok Nagar, Bangalore - 560001'},
    {'name': 'BMW Hyderabad - Landmark', 'address': 'Landmark Cars, Road No. 2, Banjara Hills, Hyderabad - 500034'},
    {'name': 'BMW Pune - Rohan Rajdeep', 'address': 'Rohan Rajdeep Motors, Nagar Road, Yerawada, Pune - 411006'},
    {'name': 'BMW Chennai - Kun Exclusive', 'address': 'Kun Exclusive, Anna Salai, Teynampet, Chennai - 600006'},
    {'name': 'BMW Ahmedabad - Gallops', 'address': 'Gallops Automobiles, SG Highway, Makarba, Ahmedabad - 380051'},
    {'name': 'BMW Kolkata - Galaxy Motors', 'address': 'Galaxy Motors, 8 Lee Road, Bhowanipore, Kolkata - 700020'},
  ];

  // ── Show address + payment dialog before placing order ──
  Future<void> _showCheckoutDialog(BuildContext context, String userId, List items) async {
    String? selectedShowroom;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          backgroundColor: DS.surfaceMid,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: DS.ghostBorder),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ──
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: DS.primary.withOpacity(0.15),
                        ),
                        child: const Icon(Icons.location_on_outlined, color: DS.primary, size: 22),
                      ),
                      const SizedBox(width: 16),
                      const Text('CHECKOUT DETAILS',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Nearest BMW Showroom ──
                  Row(
                    children: [
                      const Icon(Icons.store_mall_directory_outlined, color: DS.primary, size: 16),
                      const SizedBox(width: 8),
                      const Text('SELECT NEAREST BMW SHOWROOM',
                        style: TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: DS.surface,
                      border: Border.fromBorderSide(DS.ghostBorder),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: DS.surfaceMid,
                        hint: const Text('SELECT A SHOWROOM',
                          style: TextStyle(color: DS.onSurfaceDim, fontSize: 12, letterSpacing: 1.5)),
                        value: selectedShowroom,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: DS.primary),
                        style: const TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 1),
                        items: _showrooms.map((s) => DropdownMenuItem(
                          value: s['name'],
                          child: Text(s['name']!.toUpperCase(), overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        )).toList(),
                        onChanged: (val) {
                          setDlg(() {
                            selectedShowroom = val;
                          });
                        },
                      ),
                    ),
                  ),
                  // Selected showroom badge
                  if (selectedShowroom != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: DS.primary.withOpacity(0.05),
                        border: Border.all(color: DS.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check, color: DS.primary, size: 14),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text('SHOWROOM CONFIRMED',
                              style: TextStyle(color: DS.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                          ),
                          GestureDetector(
                            onTap: () => setDlg(() => selectedShowroom = null),
                            child: const Icon(Icons.close, color: DS.onSurfaceMid, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // ── Payment Method ──
                  const Text('PAYMENT METHOD',
                    style: TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  // Pay at Showroom
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: DS.surface,
                      border: Border.fromBorderSide(DS.ghostBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_box, color: Colors.white, size: 18),
                        const SizedBox(width: 12),
                        const Icon(Icons.store_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('PAY AT SHOWROOM',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: DS.primary.withOpacity(0.1),
                            border: Border.all(color: DS.primary.withOpacity(0.4)),
                          ),
                          child: const Text('EXCLUSIVE',
                            style: TextStyle(color: DS.primary, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ── Buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          style: OutlinedButton.styleFrom(
                            side: DS.ghostBorder,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: const Text('CANCEL', style: TextStyle(color: DS.onSurfaceMid, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedShowroom == null) {
                              AppUtils.showSnack(context, 'Please select a BMW Showroom first.', isError: true);
                              return;
                            }
                            Navigator.pop(ctx, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: const Text('CONFIRM', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 3)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (result == true && mounted) {
      final showroomPayMethod = await _showShowroomPaymentDialog(context);
      if (showroomPayMethod != null && mounted) {
        final addr = _showrooms.firstWhere((s) => s['name'] == selectedShowroom!)['address']!;
        _placeOrder(context, userId, items, addr, 'Pay at Showroom ($showroomPayMethod)');
      }
    }
  }

  // ── Step-2: Showroom payment method dialog ──
  Future<String?> _showShowroomPaymentDialog(BuildContext context) async {
    String selected = 'Cash';

    final methods = [
      {'label': 'CASH PAY', 'sub': 'AT SHOWROOM COUNTER', 'icon': Icons.money},
      {'label': 'CARD PAY', 'sub': 'POS SWIPE', 'icon': Icons.credit_card},
      {'label': 'EMI', 'sub': 'MONTHLY INSTALMENTS', 'icon': Icons.calendar_month_outlined},
    ];

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          backgroundColor: DS.surfaceMid,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: DS.ghostBorder),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.store_outlined, color: Colors.black, size: 22),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PAYMENT OPTIONS',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
                          SizedBox(height: 4),
                          Text('SELECT YOUR PREFERRED METHOD',
                            style: TextStyle(color: DS.onSurfaceMid, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Options ──
                ...methods.map((m) {
                  final label = m['label'] as String;
                  final sub   = m['sub']   as String;
                  final icon  = m['icon']  as IconData;
                  final isSel = selected == label;
                  return GestureDetector(
                    onTap: () => setDlg(() => selected = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSel ? Colors.white.withOpacity(0.05) : DS.surface,
                        border: isSel ? Border.all(color: Colors.white, width: 1.5) : Border.fromBorderSide(DS.ghostBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: isSel ? Colors.white : DS.onSurfaceMid, size: 20),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(label,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : DS.onSurfaceMid,
                                    fontSize: 13,
                                    fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                                    letterSpacing: 2,
                                  )),
                                const SizedBox(height: 4),
                                Text(sub,
                                  style: TextStyle(color: isSel ? DS.onSurfaceMid : DS.onSurfaceDim, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              ],
                            ),
                          ),
                          Icon(
                            isSel ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: isSel ? Colors.white : DS.onSurfaceDim,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 32),
                // ── Buttons ──
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, null),
                        style: OutlinedButton.styleFrom(
                          side: DS.ghostBorder,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text('BACK', style: TextStyle(color: DS.onSurfaceMid, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, selected),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text('FINALIZE',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 3)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context, String userId, List items, String address, String paymentMethod) async {
    setState(() => _isPlacing = true);
    try {
      final res = await ApiService.placeOrder(userId, items, address, paymentMethod);
      if (!mounted) return;
      setState(() => _isPlacing = false);
      if (res.containsKey('order_id')) {
        Provider.of<CartProvider>(context, listen: false).clearLocal();
        AppUtils.showSnack(context, 'ORDER CONFIRMED');
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPlacing = false);
      AppUtils.showSnack(context, 'ERROR: ${e.toString().replaceAll("Exception: ", "")}', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: DS.bg,
      appBar: AppBar(
        backgroundColor: DS.bg,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text('MY CART', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 16)),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 48, color: DS.onSurfaceMid),
                  const SizedBox(height: 24),
                  const Text('CART IS EMPTY', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4)),
                  const SizedBox(height: 12),
                  const Text('DISCOVER BAYERISCHE PERFECTION', style: TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) {
                      final item = cart.items[i];
                      return Container(
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: DS.surface,
                          border: Border.fromBorderSide(DS.ghostBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Car image
                            Container(
                              width: 120,
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(color: DS.outlineVariant, width: 0.15)),
                              ),
                              child: item['image_url'] != null && item['image_url'].toString().isNotEmpty
                                  ? Image.network(item['image_url'], fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.directions_car,
                                          color: DS.onSurfaceMid, size: 36))
                                  : const Icon(Icons.directions_car, color: DS.onSurfaceMid, size: 36),
                            ),
                            // Details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text((item['name'] ?? '').toUpperCase(),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
                                    const SizedBox(height: 6),
                                    Text('MODEL: ${(item['model'] ?? '').toUpperCase()}',
                                      style: const TextStyle(color: DS.onSurfaceMid, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                    if (item['color'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text('COLOR: ${(item['color'] ?? '').toUpperCase()}',
                                          style: const TextStyle(color: DS.primary, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                      ),
                                    const Spacer(),
                                    Text(AppUtils.formatPrice(item['price']),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 1)),
                                  ],
                                ),
                              ),
                            ),
                            // Delete
                            InkWell(
                              onTap: () => Provider.of<CartProvider>(context, listen: false)
                                  .removeItem(user.userId!, item['car_id'], color: item['color']),
                              child: Container(
                                width: 50,
                                decoration: const BoxDecoration(
                                  border: Border(left: BorderSide(color: DS.outlineVariant, width: 0.15)),
                                ),
                                child: const Center(
                                  child: Icon(Icons.close, color: DS.onSurfaceMid, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── CHECKOUT PANEL ──────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 32, 40, 48),
                  decoration: const BoxDecoration(
                    color: DS.bg,
                    border: Border(top: BorderSide(color: DS.outlineVariant, width: 0.3)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ORDER SUMMARY (${cart.itemCount})', style: const TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                            Text(AppUtils.formatPrice(cart.total),
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _isPlacing ? null : () => _showCheckoutDialog(context, user.userId!, cart.items),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: _isPlacing ? DS.surfaceMid : Colors.white,
                              ),
                              child: Center(
                                child: _isPlacing
                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                    : const Text('PROCEED TO CHECKOUT', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 4)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
