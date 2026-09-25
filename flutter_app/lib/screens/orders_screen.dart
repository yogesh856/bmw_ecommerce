import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_provider.dart';
import '../services/design_system.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() { super.initState(); loadOrders(); }

  void loadOrders() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId!;
    try {
      final data = await ApiService.getUserOrders(userId);
      setState(() { orders = data.reversed.toList(); isLoading = false; });
    } catch (_) { setState(() => isLoading = false); }
  }

  String formatPrice(dynamic price) {
    int p = (price as num).toInt();
    if (p >= 10000000) return '₹${(p / 10000000).toStringAsFixed(2)} Cr';
    if (p >= 100000)   return '₹${(p / 100000).toStringAsFixed(2)} L';
    return '₹$p';
  }

  String formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) { return raw.length >= 10 ? raw.substring(0, 10).toUpperCase() : raw.toUpperCase(); }
  }

  Map<String, dynamic> _statusStyle(String status) {
    switch (status) {
      case 'Delivered': return {'color': Colors.greenAccent, 'icon': Icons.check};
      case 'Shipped':   return {'color': Colors.blueAccent,  'icon': Icons.local_shipping_outlined};
      case 'Cancelled': return {'color': Colors.redAccent,   'icon': Icons.close};
      default:          return {'color': DS.onSurfaceMid, 'icon': Icons.access_time};
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('ORDER HISTORY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 16)),
        actions: [
          if (!isLoading && orders.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Center(
                child: Text('${orders.length} RECORDS',
                  style: const TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_outlined, size: 48, color: DS.onSurfaceMid),
                      const SizedBox(height: 24),
                      const Text('NO PAST ORDERS', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4)),
                      const SizedBox(height: 12),
                      const Text('EXPERIENCE BAYERISCHE PERFECTION', style: TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: orders.length,
                  itemBuilder: (_, i) {
                    final order  = orders[i];
                    final items  = (order['items'] as List?) ?? [];
                    final status = order['status'] ?? 'Pending';
                    final style  = _statusStyle(status);
                    final color  = style['color'] as Color;
                    final icon   = style['icon'] as IconData;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: DS.surface,
                        border: Border.fromBorderSide(DS.ghostBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: DS.surfaceMid,
                              border: Border(bottom: BorderSide(color: DS.outlineVariant, width: 0.15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text('REF:', style: TextStyle(color: DS.onSurfaceDim, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 2)),
                                    const SizedBox(width: 8),
                                    Text('#${order['_id'].toString().substring(0, 8).toUpperCase()}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.05),
                                    border: Border.all(color: color.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(icon, color: color, size: 10),
                                      const SizedBox(width: 8),
                                      Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Body
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _infoTile('DATE', formatDate(order['ordered_at']?.toString())),
                                    Container(width: 1, height: 24, color: DS.outlineVariant.withOpacity(0.2)),
                                    _infoTile('TOTAL', formatPrice(order['total_amount'])),
                                    Container(width: 1, height: 24, color: DS.outlineVariant.withOpacity(0.2)),
                                    _infoTile('METHOD', (order['payment_method'] ?? 'COD').toUpperCase()),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Text('VEHICLES', style: TextStyle(color: DS.onSurfaceDim, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2)),
                                const SizedBox(height: 12),
                                // ── Items list ──────────────────
                                if (items.isNotEmpty) ...[
                                  ...items.map<Widget>((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48, height: 48,
                                          decoration: BoxDecoration(
                                            color: DS.surfaceLow,
                                            border: Border.fromBorderSide(DS.ghostBorder),
                                          ),
                                          child: item['image_url'] != null && item['image_url'].toString().isNotEmpty
                                              ? Image.network(item['image_url'], fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => const Icon(Icons.directions_car,
                                                      color: DS.onSurfaceMid, size: 20))
                                              : const Icon(Icons.directions_car, color: DS.onSurfaceMid, size: 20),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${item['name'] ?? 'BMW'}'.toUpperCase(),
                                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'MODEL: ${(item['model'] ?? '').toUpperCase()}',
                                                style: const TextStyle(color: DS.onSurfaceMid, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(formatPrice(item['price']),
                                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1)),
                                      ],
                                    ),
                                  )),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _infoTile(String label, String text) => Expanded(
    child: Column(
      children: [
        Text(label, style: const TextStyle(color: DS.onSurfaceDim, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2)),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
          textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
      ],
    ),
  );
}
