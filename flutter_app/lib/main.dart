import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/user_provider.dart';
import 'services/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const BMWApp(),
    ),
  );
}

class BMWApp extends StatelessWidget {
  const BMWApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMW Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF1C69D4),    // BMW Blue
          secondary: const Color(0xFFFFFFFF),
          surface: const Color(0xFF0D0D0D),    // merged surface + background
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0D0D),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C69D4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        fontFamily: 'Roboto',
      ),
      home: const _AppStartup(),
    );
  }
}

/// Checks for saved login session, then routes to Home or Login.
class _AppStartup extends StatefulWidget {
  const _AppStartup();

  @override
  State<_AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<_AppStartup> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.loadSession();

    if (!mounted) return;
    if (userProvider.isLoggedIn) {
      // Also reload cart
      final cartProvider = context.read<CartProvider>();
      await cartProvider.loadCart(userProvider.userId!);
    }
    // Rebuild happens via notifyListeners, handled in build()
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<UserProvider>().isLoggedIn;
    // Show a loading screen briefly while session loads
    return isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
