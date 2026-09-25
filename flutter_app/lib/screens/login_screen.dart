import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_provider.dart';
import '../services/cart_provider.dart';
import '../services/app_utils.dart';
import '../services/design_system.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool isLoading = false;
  bool obscurePass = true;
  bool keepSignedIn = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void login() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      _showSnack('Please enter your email and password!', Colors.redAccent);
      return;
    }
    setState(() => isLoading = true);
    try {
      final res = await ApiService.login(emailCtrl.text.trim(), passwordCtrl.text.trim());
      setState(() => isLoading = false);
      if (res.containsKey('user_id')) {
        if (!mounted) return;
        Provider.of<UserProvider>(context, listen: false).login(res);
        await Provider.of<CartProvider>(context, listen: false).loadCart(res['user_id']);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
      } else {
        _showSnack(res['error'] ?? 'Login failed', Colors.redAccent);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnack('Invalid Credentials', Colors.redAccent);
    }
  }

  void _showSnack(String msg, Color color) {
    AppUtils.showSnack(context, msg, isError: color == Colors.redAccent || color == Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DS.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(
            'assets/images/hero.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          
          // 2. Gradients & Overlays
          Container(color: Colors.black.withOpacity(0.6)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black87, Colors.transparent, Colors.black],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // 3. Top Nav (Static)
          Positioned(
            top: 0, left: 0, right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('BMW', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4)),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.white, size: 24),
                      const SizedBox(width: 24),
                      const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        width: 500,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 56 : 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            const Text(
                              'SIGN IN',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: -1, height: 1),
                            ),
                            const SizedBox(height: 16),
                            Center(child: Container(width: 48, height: 4, color: DS.primary)),
                            const SizedBox(height: 24),
                            const Text(
                              'EXPERIENCE THE WORLD OF BAYERISCHE PRECISION',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2),
                            ),
                            const SizedBox(height: 48),

                            // Form fields
                            _buildFieldLabel('IDENTIFICATION'),
                            _buildInput(controller: emailCtrl, hint: 'EMAIL OR BMW ID', icon: Icons.person_outline),
                            const SizedBox(height: 32),
                            
                            _buildFieldLabel('SECURITY CODE'),
                            _buildInput(
                              controller: passwordCtrl, 
                              hint: 'PASSWORD', 
                              icon: Icons.lock_outline, 
                              isPassword: true, 
                              obscure: obscurePass,
                              onToggle: () => setState(() => obscurePass = !obscurePass)
                            ),
                            const SizedBox(height: 32),

                            // Extra options
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => keepSignedIn = !keepSignedIn),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16, height: 16,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                                        ),
                                        child: keepSignedIn ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Text('KEEP ME SIGNED IN', style: TextStyle(color: DS.onSurfaceMid.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                    ],
                                  ),
                                ),
                                const Text('RECOVERY OPTIONS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, decoration: TextDecoration.underline, decorationColor: Colors.white, decorationThickness: 1.5)),
                              ],
                            ),
                            const SizedBox(height: 48),

                            // Submit Button
                            _buildLoginBtn(),
                            const SizedBox(height: 48),

                            // Footer Link
                            const Text(
                              'NEW TO THE JOY OF DRIVING?',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: DS.onSurfaceDim, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3),
                            ),
                            const SizedBox(height: 12),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                                child: Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
                                    ),
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: const Text('CREATE BMW ACCOUNT', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 5. Bottom Footer
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: isWide(context) 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('© 2024 BAYERISCHE MOTOREN WERKE AG', style: TextStyle(color: DS.onSurfaceDim, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3)),
                      Row(
                        children: ['PRIVACY', 'LEGAL', 'CONTACT', 'COOKIES']
                            .map((t) => Padding(
                                  padding: const EdgeInsets.only(left: 32),
                                  child: Text(t, style: const TextStyle(color: DS.onSurfaceDim, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3)),
                                ))
                            .toList(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Text('© 2024 BAYERISCHE MOTOREN WERKE AG', style: TextStyle(color: DS.onSurfaceDim, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3)),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24, runSpacing: 16,
                        children: ['PRIVACY', 'LEGAL', 'CONTACT', 'COOKIES']
                            .map((t) => Text(t, style: const TextStyle(color: DS.onSurfaceDim, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3)))
                            .toList(),
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  bool isWide(BuildContext context) => MediaQuery.of(context).size.width > 800;

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 3)),
    );
  }

  Widget _buildInput({required TextEditingController controller, required String hint, required IconData icon, bool isPassword = false, bool obscure = false, VoidCallback? onToggle}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.5),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF454747), fontSize: 14, letterSpacing: 1.5),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: DS.onSurfaceMid, size: 20),
              onPressed: onToggle,
            ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading ? null : login,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isLoading ? DS.surfaceMid : Colors.white,
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                : const Text('SIGN IN', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 4)),
          ),
        ),
      ),
    );
  }
}
