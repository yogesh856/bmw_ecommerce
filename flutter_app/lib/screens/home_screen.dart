import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../services/cart_provider.dart';
import '../services/design_system.dart';
import '../services/api_service.dart';
import '../services/app_utils.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'login_screen.dart';
import 'vehicle_inventory_screen.dart';
import 'car_detail_screen.dart';
import 'profile_screen.dart';

// ─────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: DS.bg,
      body: Column(
        children: [
          // ── COMMAND BAR ───────────────────────────────
          _CommandBar(cart: cart, user: user),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero
                  const _HeroSection(),
                  // 2. Bento Grid
                  const _BentoGrid(),
                  // 3. Heritage
                  const _HeritageSection(),
                  // 4. News
                  const _NewsSection(),
                  // 5. Footer
                  const _Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// COMMAND BAR (Glassmorphic)
// ─────────────────────────────────────────────────────────
class _CommandBar extends StatelessWidget {
  final CartProvider cart;
  final UserProvider user;
  const _CommandBar({required this.cart, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: DS.surface.withOpacity(0.97),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          // BMW Logo
          const Text('BMW',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4)),
          const SizedBox(width: 48),
          _NavLink(
              label: 'MODELS',
              active: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VehicleInventoryScreen()))),
          _NavLink(
              label: 'DISCOVER',
              active: false,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VehicleInventoryScreen()))),

          const Spacer(),

          // Icons
          _iconBtn(
              Icons.search,
              () => showDialog(
                  context: context, builder: (_) => const _SearchDialog())),
          const SizedBox(width: 4),
          Stack(
            children: [
              _iconBtn(
                  Icons.shopping_cart_outlined,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen()))),
              if (cart.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                        color: DS.primary, shape: BoxShape.circle),
                    child: Center(
                        child: Text('${cart.itemCount}',
                            style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          _iconBtn(
              Icons.receipt_long_outlined,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen()))),
          const SizedBox(width: 4),
          _iconBtn(Icons.person_outline, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }),
        ],
      ),
    );
  }

  static Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          child: Icon(icon, color: DS.onSurfaceMid, size: 20),
        ),
      );
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const _NavLink({required this.label, required this.active, this.onTap});
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 32),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: widget.active
                      ? DS.primary
                      : (_h
                          ? DS.primaryGlow.withOpacity(0.4)
                          : Colors.transparent),
                  width: 1.5,
                )),
              ),
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(widget.label,
                  style: TextStyle(
                    color: widget.active
                        ? DS.primary
                        : (_h ? DS.primaryGlow : DS.onSurface),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  )),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// HERO SECTION
// ─────────────────────────────────────────────────────────
class _HeroSection extends StatefulWidget {
  const _HeroSection();
  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  int _dot = 0;
  Timer? _timer;

  final List<Map<String, String>> _slides = [
    {
      'img':
          'https://images.unsplash.com/photo-1607853554439-0069ec0f29b6?w=1600&q=80',
      'badge': 'M PERFORMANCE HERITAGE',
      'title': 'THE ULTIMATE\nDRIVING\nMACHINE',
      'cta': 'Explore M8 Competition',
    },
    {
      'img':
          'https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=1600&q=80',
      'badge': 'ELECTRIFIED FUTURE',
      'title': 'PURE\nELECTRIC\nPOWER',
      'cta': 'Explore BMW i Series',
    },
    {
      'img':
          'https://images.unsplash.com/photo-1615908397724-6dc711db34a7?w=1600&q=80',
      'badge': 'CRAFTED PRECISION',
      'title': 'DOMINATE\nEVERY\nTERRAIN',
      'cta': 'Explore X Series',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() => _dot = (_dot + 1) % _slides.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_dot];
    final isWide = MediaQuery.of(context).size.width > 800;

    return SizedBox(
      height: isWide ? 680 : 480,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with crossfade
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 900),
            child: SizedBox.expand(
              key: ValueKey(_dot),
              child: Image.network(
                slide['img']!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: DS.surfaceLow),
              ),
            ),
          ),

          // Left gradient (strong)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black, Colors.transparent],
                stops: [0.0, 0.65],
              ),
            ),
          ),

          // Bottom gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF0E0E0E), Colors.transparent],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: isWide ? 48 : 28,
            bottom: 80,
            right: isWide ? null : 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slide['badge']!,
                  style: const TextStyle(
                    color: Color(0xFFD5E3FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    slide['title']!,
                    key: ValueKey(slide['title']),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWide ? 88 : 52,
                      fontWeight: FontWeight.w900,
                      height: 0.93,
                      letterSpacing: -3,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  children: [
                    _HeroCta(
                      label: slide['cta']!,
                      primary: true,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VehicleInventoryScreen())),
                    ),
                    const SizedBox(width: 16),
                    _HeroCta(
                      label: 'View Inventory',
                      primary: false,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VehicleInventoryScreen())),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Carousel dots (bottom right)
          Positioned(
            bottom: 28,
            right: 48,
            child: Row(
              children: List.generate(
                  _slides.length,
                  (i) => GestureDetector(
                        onTap: () => setState(() => _dot = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _dot == i ? 48 : 28,
                          height: 2,
                          margin: const EdgeInsets.only(left: 6),
                          color: _dot == i
                              ? DS.primary
                              : Colors.white.withOpacity(0.25),
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCta extends StatefulWidget {
  final String label;
  final bool primary;
  final VoidCallback? onTap;
  const _HeroCta({required this.label, required this.primary, this.onTap});
  @override
  State<_HeroCta> createState() => _HeroCtaState();
}

class _HeroCtaState extends State<_HeroCta> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: widget.primary
                  ? (_h ? DS.primaryGlow : DS.primary)
                  : Colors.white.withOpacity(_h ? 0.12 : 0.0),
              border: widget.primary
                  ? null
                  : Border.all(color: DS.outlineVariant.withOpacity(0.45)),
            ),
            child: Text(widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                )),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// BENTO GRID (Category Cards)
// ─────────────────────────────────────────────────────────
class _BentoGrid extends StatelessWidget {
  const _BentoGrid();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      color: DS.surface,
      padding: const EdgeInsets.fromLTRB(12, 48, 12, 48),
      child: isWide ? _wideGrid(context) : _narrowGrid(context),
    );
  }

  Widget _wideGrid(BuildContext context) {
    return SizedBox(
      height: 720,
      child: Row(
        children: [
          // Left: Electric (large)
          Expanded(
            flex: 8,
            child: _BentoCard(
              img:
                  'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=1200&q=80',
              title: 'Electric Excellence',
              sub: 'THE FUTURE OF ELECTRIFIED MOBILITY',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VehicleInventoryScreen(
                          initialCategory: 'Electric SUV'))),
            ),
          ),
          const SizedBox(width: 6),
          // Right column
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: _BentoCard(
                    img:
                        'https://images.unsplash.com/photo-1667551181687-e3eb9babf037?w=800&q=80',
                    title: 'M Powerhouse',
                    sub: 'ENGINEERED FOR THE TRACK',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const VehicleInventoryScreen(
                                initialCategory: 'Sports'))),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: _BentoCard(
                    img:
                        'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&q=80',
                    title: 'SAV Range',
                    sub: 'SPORTS ACTIVITY VEHICLES',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const VehicleInventoryScreen(
                                initialCategory: 'SUV'))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _narrowGrid(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: _BentoCard(
            img:
                'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=1200&q=80',
            title: 'Electric Excellence',
            sub: 'THE FUTURE OF ELECTRIFIED MOBILITY',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const VehicleInventoryScreen(
                        initialCategory: 'Electric SUV'))),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 200,
          child: _BentoCard(
            img:
                'https://images.unsplash.com/photo-1667551181687-e3eb9babf037?w=800&q=80',
            title: 'M Powerhouse',
            sub: 'ENGINEERED FOR THE TRACK',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const VehicleInventoryScreen(
                        initialCategory: 'Sports'))),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 200,
          child: _BentoCard(
            img:
                'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&q=80',
            title: 'SAV Range',
            sub: 'SPORTS ACTIVITY VEHICLES',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const VehicleInventoryScreen(initialCategory: 'SUV'))),
          ),
        ),
      ],
    );
  }
}

class _BentoCard extends StatefulWidget {
  final String img, title, sub;
  final VoidCallback? onTap;
  const _BentoCard(
      {required this.img, required this.title, required this.sub, this.onTap});
  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image + zoom
                AnimatedScale(
                  scale: _h ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: Image.network(widget.img,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: DS.surfaceLow)),
                ),
                // Greyscale overlay that lifts on hover
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: Colors.black.withOpacity(_h ? 0.2 : 0.5),
                ),
                // Bottom text
                Positioned(
                  left: 28,
                  bottom: 28,
                  right: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1)),
                      const SizedBox(height: 4),
                      Text(widget.sub,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// HERITAGE SECTION
// ─────────────────────────────────────────────────────────
class _HeritageSection extends StatelessWidget {
  const _HeritageSection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      color: DS.bg,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 28, vertical: 80),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _heritageText()),
                const SizedBox(width: 80),
                Expanded(child: _heritageImg()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heritageText(),
                const SizedBox(height: 48),
                _heritageImg(),
              ],
            ),
    );
  }

  Widget _heritageText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('LEGACY OF PERFORMANCE',
              style: TextStyle(
                  color: DS.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4)),
          const SizedBox(height: 24),
          const Text('CRAFTING\nICONS SINCE\n1916.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  height: 0.92,
                  letterSpacing: -2)),
          const SizedBox(height: 28),
          Container(width: 80, height: 3, color: DS.primary),
          const SizedBox(height: 32),
          const Text(
            'Every curve, every piston stroke, and every stitch in a BMW is a testament to over a century of engineering perfection. We don\'t just build cars; we create a symphony of motion.',
            style: TextStyle(color: DS.onSurfaceMid, fontSize: 15, height: 1.7),
          ),
          const SizedBox(height: 36),
          _HeritageLink(),
        ],
      );

  Widget _heritageImg() => Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16, left: 16),
            decoration: BoxDecoration(
              border: Border.all(color: DS.outlineVariant.withOpacity(0.2)),
            ),
            height: 380,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16, right: 16),
            height: 380,
            child: Image.network(
              'https://images.unsplash.com/photo-1615908397724-6dc711db34a7?w=1200&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: DS.surfaceLow),
            ),
          ),
        ],
      );
}

class _HeritageLink extends StatefulWidget {
  @override
  State<_HeritageLink> createState() => _HeritageLinkState();
}

class _HeritageLinkState extends State<_HeritageLink> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('OUR HERITAGE',
                style: TextStyle(
                  color: _h ? DS.primaryGlow : Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                )),
            const SizedBox(width: 12),
            AnimatedSlide(
              offset: Offset(_h ? 0.3 : 0, 0),
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 18),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────
// LATEST NEWS SECTION
// ─────────────────────────────────────────────────────────
class _NewsSection extends StatelessWidget {
  const _NewsSection();

  static const _articles = [
    {
      'cat': 'INNOVATION',
      'title': 'THE NEUE KLASSE: A NEW ERA OF DRIVING',
      'img':
          'https://images.unsplash.com/photo-1607853554439-0069ec0f29b6?w=800&q=80',
    },
    {
      'cat': 'MOTORSPORT',
      'title': 'DOMINATING THE NÜRBURGRING 24H',
      'img':
          'https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=800&q=80',
    },
    {
      'cat': 'SUSTAINABILITY',
      'title': 'CIRCULAR ECONOMY IN LUXURY MANUFACTURING',
      'img':
          'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      color: DS.surface,
      padding: EdgeInsets.fromLTRB(isWide ? 48 : 24, 72, isWide ? 48 : 24, 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('LATEST NEWS',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1)),
                  const SizedBox(height: 6),
                  const Text('INTELLIGENCE. INNOVATION. SPEED.',
                      style: TextStyle(
                          color: DS.onSurfaceDim,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3)),
                ],
              ),
              const Spacer(),
              _ViewAllBtn(),
            ],
          ),
          const SizedBox(height: 52),

          // Grid
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _articles
                      .map((a) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: a == _articles.last ? 0 : 24),
                              child: _NewsCard(article: a),
                            ),
                          ))
                      .toList(),
                )
              : Column(
                  children: _articles
                      .map((a) => Padding(
                            padding: const EdgeInsets.only(bottom: 36),
                            child: _NewsCard(article: a),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _ViewAllBtn extends StatefulWidget {
  @override
  State<_ViewAllBtn> createState() => _ViewAllBtnState();
}

class _ViewAllBtnState extends State<_ViewAllBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: _h ? DS.primaryGlow : DS.primary, width: 1.5)),
          ),
          padding: const EdgeInsets.only(bottom: 4),
          child: Text('VIEW ALL ARTICLES',
              style: TextStyle(
                color: _h ? DS.primaryGlow : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
        ),
      );
}

class _NewsCard extends StatefulWidget {
  final Map<String, String> article;
  const _NewsCard({required this.article});
  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRect(
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale: _h ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        child: Image.network(widget.article['img']!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: DS.surfaceMid)),
                      ),
                      // Greyscale-to-color effect (simulated with overlay)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        color: Colors.black.withOpacity(_h ? 0.0 : 0.3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.article['cat']!,
                  style: const TextStyle(
                      color: DS.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2)),
              const SizedBox(height: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: _h ? DS.primaryGlow : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
                child: Text(widget.article['title']!),
              ),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      color: DS.bg,
      child: Column(
        children: [
          Container(height: 1, color: DS.outlineVariant.withOpacity(0.12)),
          Padding(
            padding:
                EdgeInsets.fromLTRB(isWide ? 48 : 24, 64, isWide ? 48 : 24, 40),
            child: isWide ? _wideFooter() : _narrowFooter(),
          ),
          Container(height: 1, color: DS.outlineVariant.withOpacity(0.08)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            child: Row(
              children: [
                const Text('© 2024 BMW AG. All rights reserved.',
                    style: TextStyle(
                        color: DS.onSurfaceDim,
                        fontSize: 10,
                        letterSpacing: 2)),
                const Spacer(),
                ...['IMPRINT', 'PRIVACY', 'COOKIES'].map((l) => Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text(l,
                          style: const TextStyle(
                              color: DS.onSurfaceDim,
                              fontSize: 10,
                              letterSpacing: 2)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideFooter() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BMW',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4)),
                const SizedBox(height: 16),
                const Text(
                  'Redefining the standard of luxury\nand performance since 1916.\nJoin the journey into the future\nof mobility.',
                  style: TextStyle(
                      color: DS.onSurfaceDim, fontSize: 13, height: 1.8),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _socialIcon(Icons.public),
                    const SizedBox(width: 16),
                    _socialIcon(Icons.camera_alt_outlined),
                    const SizedBox(width: 16),
                    _socialIcon(Icons.play_circle_outline),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          // Links
          ...[
            {
              'EXPERIENCE': ['Models', 'Configurator', 'Test Drive', 'BMW M']
            },
            {
              'SUPPORT': [
                'Contact',
                'Find a Dealer',
                'Service & Parts',
                'Recall Info'
              ]
            },
            {
              'LEGAL': [
                'Legal Notice',
                'Cookie Policy',
                'Privacy Policy',
                'Contact'
              ]
            },
          ].map((section) {
            final title = section.keys.first;
            final links = section[title] as List<String>;
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2)),
                  const SizedBox(height: 20),
                  ...links.map((l) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(l,
                            style: const TextStyle(
                                color: DS.onSurfaceDim, fontSize: 13)),
                      )),
                ],
              ),
            );
          }),
        ],
      );

  Widget _narrowFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BMW',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4)),
          const SizedBox(height: 16),
          const Text('Redefining luxury & performance since 1916.',
              style:
                  TextStyle(color: DS.onSurfaceDim, fontSize: 13, height: 1.7)),
          const SizedBox(height: 40),
          ...[
            {
              'EXPERIENCE': ['Models', 'Configurator', 'Test Drive', 'BMW M']
            },
            {
              'SUPPORT': ['Contact', 'Find a Dealer', 'Service & Parts']
            },
            {
              'LEGAL': ['Legal Notice', 'Cookie Policy', 'Privacy Policy']
            },
          ].map((section) {
            final title = section.keys.first;
            final links = section[title] as List<String>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2)),
                  const SizedBox(height: 14),
                  ...links.map((l) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(l,
                            style: const TextStyle(
                                color: DS.onSurfaceDim, fontSize: 13)),
                      )),
                ],
              ),
            );
          }),
        ],
      );

  static Widget _socialIcon(IconData icon) =>
      Icon(icon, color: DS.onSurfaceDim, size: 22);
}

// ─────────────────────────────────────────────────────────
// SEARCH DIALOG OVERLAY
// ─────────────────────────────────────────────────────────
class _SearchDialog extends StatefulWidget {
  const _SearchDialog();
  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final _searchCtrl = TextEditingController();
  List<dynamic> _allCars = [];
  List<dynamic> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    try {
      final cars = await ApiService.getAllCars();
      if (!mounted) return;
      setState(() {
        _allCars = cars;
        _isLoading = false;
        // Do not populate _filtered initially so it's empty
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onSearch(String q) {
    if (q.isEmpty) {
      setState(() => _filtered = []);
      return;
    }
    setState(() {
      _filtered = _allCars.where((c) {
        final name = (c['name'] ?? '').toString().toLowerCase();
        final cat = (c['category'] ?? '').toString().toLowerCase();
        return name.contains(q.toLowerCase()) || cat.contains(q.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: DS.bg,
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.only(top: 72, right: 40, bottom: 24),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(color: DS.outlineVariant.withOpacity(0.3))),
      child: Container(
        width: 380,
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Search Input
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: DS.outlineVariant.withOpacity(0.5))),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      autofocus: true,
                      onChanged: _onSearch,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                      cursorColor: DS.primary,
                      decoration: const InputDecoration(
                        hintText: 'Search models...',
                        hintStyle: TextStyle(
                            color: DS.onSurfaceDim,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        prefixIcon:
                            Icon(Icons.search, color: DS.primary, size: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.close, color: DS.onSurface, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                )
              ],
            ),
            const SizedBox(height: 20),
            // Results List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: DS.primary))
                  : _searchCtrl.text.isEmpty
                      ? const Center(
                          child: Text('Type to find a vehicle',
                              style: TextStyle(
                                  color: DS.onSurfaceDim, fontSize: 13)))
                      : _filtered.isEmpty
                          ? const Center(
                              child: Text('No vehicles found.',
                                  style: TextStyle(
                                      color: DS.onSurfaceDim, fontSize: 13)))
                          : ListView.builder(
                              itemCount: _filtered.length,
                              itemBuilder: (ctx, i) {
                                final c = _filtered[i];
                                return _SearchItem(car: c);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchItem extends StatefulWidget {
  final Map<String, dynamic> car;
  const _SearchItem({required this.car});
  @override
  State<_SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<_SearchItem> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.car;
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close dialog
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CarDetailScreen(carId: c['_id'], carName: c['name'])));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          color: _h ? DS.surfaceHigh : DS.surfaceLow,
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 40,
                child: Image.network(c['image_url'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: DS.surfaceMid)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((c['name'] ?? '').toString().toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(c['fuel_type'] ?? '',
                        style: const TextStyle(
                            color: DS.onSurfaceDim, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(AppUtils.formatPrice(c['price']),
                  style: const TextStyle(
                      color: DS.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios,
                  color: _h ? Colors.white : DS.onSurfaceDim, size: 10),
            ],
          ),
        ),
      ),
    );
  }
}
