import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../services/cart_provider.dart';
import '../services/design_system.dart';
import 'login_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('MY PROFILE',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Profile Avatar Section ──────────────────
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: DS.surface,
                border: Border.fromBorderSide(DS.ghostBorder),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: DS.surfaceMid,
                      border: Border.all(color: DS.primary, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(user.name ?? 'U'),
                        style: const TextStyle(
                          color: DS.primary,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    (user.name ?? 'User').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(
                      color: DS.onSurfaceMid,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: DS.primary.withOpacity(0.1),
                      border: Border.all(color: DS.primary.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'BMW MEMBER',
                      style: TextStyle(
                        color: DS.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Account Info Section ──────────────────
            Container(
              decoration: BoxDecoration(
                color: DS.surface,
                border: Border.fromBorderSide(DS.ghostBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: DS.surfaceMid,
                      border: Border(
                          bottom: BorderSide(
                              color: DS.outlineVariant, width: 0.15)),
                    ),
                    child: const Text(
                      'ACCOUNT DETAILS',
                      style: TextStyle(
                        color: DS.onSurfaceDim,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  _infoRow('NAME', user.name ?? '-'),
                  _divider(),
                  _infoRow('EMAIL', user.email ?? '-'),
                  _divider(),
                  _infoRow('USER ID',
                      user.userId?.substring(0, 8).toUpperCase() ?? '-'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Quick Actions Section ──────────────────
            Container(
              decoration: BoxDecoration(
                color: DS.surface,
                border: Border.fromBorderSide(DS.ghostBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: DS.surfaceMid,
                      border: Border(
                          bottom: BorderSide(
                              color: DS.outlineVariant, width: 0.15)),
                    ),
                    child: const Text(
                      'QUICK ACTIONS',
                      style: TextStyle(
                        color: DS.onSurfaceDim,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  _actionTile(
                    icon: Icons.receipt_long_outlined,
                    label: 'ORDER HISTORY',
                    subtitle: 'View your past orders',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen()),
                    ),
                  ),
                  _divider(),
                  _actionTile(
                    icon: Icons.support_agent_outlined,
                    label: 'SUPPORT',
                    subtitle: 'Get help with your account',
                    onTap: () => _showSupportDialog(context),
                  ),
                  _divider(),
                  _actionTile(
                    icon: Icons.info_outline,
                    label: 'ABOUT',
                    subtitle: 'App version & information',
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Logout Button ──────────────────
            GestureDetector(
              onTap: () => _showLogoutConfirmation(context, user),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.08),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent, size: 18),
                    SizedBox(width: 12),
                    Text(
                      'LOGOUT',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),

            // ── Footer ──────────────────
            const Text(
              'BMW STORE',
              style: TextStyle(
                color: DS.onSurfaceDim,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'THE ULTIMATE DRIVING MACHINE',
              style: TextStyle(
                color: DS.onSurfaceDim,
                fontSize: 8,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: DS.onSurfaceDim,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _divider() {
    return Container(
      height: 0.15,
      color: DS.outlineVariant,
    );
  }

  static Widget _actionTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: DS.surfaceMid,
                border: Border.fromBorderSide(DS.ghostBorder),
              ),
              child: Icon(icon, color: DS.onSurfaceMid, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: DS.onSurfaceMid,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: DS.onSurfaceDim, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, UserProvider user) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: DS.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: DS.outlineVariant.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withOpacity(0.1),
                ),
                child:
                    const Icon(Icons.logout, color: Colors.redAccent, size: 28),
              ),
              const SizedBox(height: 24),
              const Text(
                'LOGOUT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  color: DS.onSurfaceMid,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: DS.outlineVariant.withOpacity(0.3)),
                        ),
                        child: const Center(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: DS.onSurfaceMid,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(ctx);
                        final cp =
                            Provider.of<CartProvider>(context, listen: false);
                        await user.logout();
                        cp.clearLocal();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                        ),
                        child: const Center(
                          child: Text(
                            'LOGOUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: DS.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: DS.outlineVariant.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.support_agent, color: DS.primary, size: 48),
              const SizedBox(height: 24),
              const Text(
                'BMW SUPPORT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'support@bmw.com\n+1-800-831-1117',
                style: TextStyle(
                  color: DS.onSurfaceMid,
                  fontSize: 12,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: DS.primary,
                  ),
                  child: const Center(
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: DS.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: DS.outlineVariant.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'BMW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'STORE',
                style: TextStyle(
                  color: DS.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: DS.onSurfaceMid,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The Ultimate Driving Machine',
                style: TextStyle(
                  color: DS.onSurfaceDim,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: DS.primary,
                  ),
                  child: const Center(
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
