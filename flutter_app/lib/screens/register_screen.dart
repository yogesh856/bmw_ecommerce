import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/design_system.dart';
import '../services/app_utils.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  bool isLoading = false;
  bool obscurePass = true;
  bool obscureConfirm = true;

  String? _validateEmail(String email) {
    final re = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!re.hasMatch(email)) return 'Enter a valid email (e.g. you@gmail.com)';
    return null;
  }

  void register() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final confirm = confirmCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill all required fields!', Colors.redAccent); return;
    }
    final emailErr = _validateEmail(email);
    if (emailErr != null) { _showSnack(emailErr, Colors.redAccent); return; }
    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters', Colors.redAccent); return;
    }
    if (password != confirm) {
      _showSnack('Passwords do not match!', Colors.redAccent); return;
    }

    setState(() => isLoading = true);
    try {
      final res = await ApiService.register(name, email, password, phone);
      setState(() => isLoading = false);
      if (res.containsKey('user_id')) {
        if (!mounted) return;
        _showSnack('Account created! Please login 🎉', Colors.green);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        _showSnack(res['error'] ?? 'Registration failed', Colors.redAccent);
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showSnack('Could not connect to server!', Colors.redAccent);
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
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBsnI9x7pXG6v-yZWDH9Qh4SIde6xwHXg7r3troeZ5_V4-2VQ2MUzcxMK3qIE6kTvK8QE7XSq3xVnK9847yKZunevToAblHJ_r5VasNvkbtYOsLGpkFd6FrFZwyIHb7Vq48GAqV2TU2qDcdM4ozRzFtZqqMTlCNWQzokqXMZYnfe_7PGD50BSXnXTOa3cpkka9GxknQJPj0KCetuQWKpApi0dBzjJrkB1296a8DSuiXtcunD2Xvt4I82WnB0gBUxuJo_1C7xAuVH-pw',
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

          // 3. Top Nav
          Positioned(
            top: 0, left: 0, right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('BMW', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
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
                    borderRadius: BorderRadius.zero,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Container(
                        width: 500,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 56 : 32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414).withOpacity(0.7),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            const Text(
                              'CREATE ACCOUNT',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1, height: 1),
                            ),
                            const SizedBox(height: 16),
                            Center(child: Container(width: 48, height: 4, color: DS.primary)),
                            const SizedBox(height: 24),
                            const Text(
                              'JOIN THE EXCLUSIVE BMW CLUB',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: DS.onSurfaceMid, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2),
                            ),
                            const SizedBox(height: 40),

                            // Form fields
                            _buildFieldLabel('FULL NAME'),
                            _buildInput(controller: nameCtrl, hint: 'ENTER YOUR NAME', icon: Icons.person_outline),
                            const SizedBox(height: 24),

                            _buildFieldLabel('EMAIL ADDRESS'),
                            _buildInput(controller: emailCtrl, hint: 'ENTER YOUR EMAIL', icon: Icons.email_outlined),
                            const SizedBox(height: 24),

                            _buildFieldLabel('PHONE NUMBER (OPTIONAL)'),
                            _buildInput(controller: phoneCtrl, hint: 'ENTER PHONE NUMBER', icon: Icons.phone_outlined),
                            const SizedBox(height: 24),

                            _buildFieldLabel('PASSWORD'),
                            _buildInput(
                              controller: passwordCtrl, 
                              hint: 'MIN. 6 CHARACTERS', 
                              icon: Icons.lock_outline, 
                              isPassword: true, 
                              obscure: obscurePass,
                              onToggle: () => setState(() => obscurePass = !obscurePass)
                            ),
                            const SizedBox(height: 24),

                            _buildFieldLabel('CONFIRM PASSWORD'),
                            _buildInput(
                              controller: confirmCtrl, 
                              hint: 'CONFIRM PASSWORD', 
                              icon: Icons.lock_outline, 
                              isPassword: true, 
                              obscure: obscureConfirm,
                              onToggle: () => setState(() => obscureConfirm = !obscureConfirm)
                            ),
                            const SizedBox(height: 40),

                            // Submit Button
                            _buildRegisterBtn(),
                            const SizedBox(height: 32),

                            // Footer Link
                            const Text(
                              'ALREADY HAVE AN ACCOUNT?',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: DS.onSurfaceDim, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3),
                            ),
                            const SizedBox(height: 12),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                                child: Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
                                    ),
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: const Text('SIGN IN', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
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
        ],
      ),
    );
  }

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

  Widget _buildRegisterBtn() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading ? null : register,
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
                : const Text('CREATE ACCOUNT', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 4)),
          ),
        ),
      ),
    );
  }
}
