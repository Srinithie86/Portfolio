// lib/main.dart
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const AnimatedPortfolioApp());

class AnimatedPortfolioApp extends StatelessWidget {
  const AnimatedPortfolioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Srinithi E - Mobile App Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D9FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const AnimatedPortfolioPage(),
    );
  }
}

class ServiceItem {
  final IconData icon;
  final String number, title, desc;
  final Color color;
  final List<String> bullets;
  const ServiceItem({
    required this.icon, required this.number,
    required this.title, required this.desc,
    required this.color, required this.bullets,
  });
}

class Testimonial {
  final String quote, name, role, initials;
  final Color color;
  const Testimonial({
    required this.quote, required this.name,
    required this.role, required this.initials, required this.color,
  });
}

class AnimatedPortfolioPage extends StatefulWidget {
  const AnimatedPortfolioPage({super.key});
  @override
  State<AnimatedPortfolioPage> createState() => _AnimatedPortfolioPageState();
}

class _AnimatedPortfolioPageState extends State<AnimatedPortfolioPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  
  double scrollPos = 0;
  late AnimationController _floatingController;
  late AnimationController _iconController;
  late Timer _heroTimer;
  final PageController _heroController = PageController();
  final List<PageController> _projectControllers = [];
  int _selectedCategory = 0;

  final List<String> categories = ['All', 'Mobile Apps', 'UI/UX', 'Freelance'];

  final List<ServiceItem> _services = [
    ServiceItem(
      icon: Icons.phone_android_rounded,
      number: '01', title: 'Mobile App Development',
      desc: 'End-to-end Flutter apps for iOS & Android. From wireframe to App Store submission.',
      color: const Color(0xFFD4FF3C),
      bullets: ['Cross-platform Flutter', 'iOS & Android native feel', 'App Store submission', 'Play Store publishing'],
    ),
    ServiceItem(
      icon: Icons.design_services_rounded,
      number: '02', title: 'UI/UX Design',
      desc: 'Figma-first design with clean wireframes, interactive prototypes, and polished design systems.',
      color: const Color(0xFF8B6FFF),
      bullets: ['Wireframing & prototyping', 'Design systems', 'Pixel-perfect UI', 'User flow optimization'],
    ),
    ServiceItem(
      icon: Icons.api_rounded,
      number: '03', title: 'Backend Integration',
      desc: 'Seamless connection to Firebase, REST APIs, payment gateways, and third-party services.',
      color: const Color(0xFF5CCCFF),
      bullets: ['Firebase & Firestore', 'REST API integration', 'Payment gateways', 'Google Maps SDK'],
    ),
    ServiceItem(
      icon: Icons.build_rounded,
      number: '04', title: 'App Maintenance',
      desc: 'Bug fixes, performance improvements, feature additions, and version updates for existing apps.',
      color: const Color(0xFFFF6B6B),
      bullets: ['Bug fixing & debugging', 'Performance optimization', 'Feature enhancements', 'Code review & refactor'],
    ),
  ];

  final List<Testimonial> _testimonials = [
    Testimonial(
      quote: '"Srinithi delivered our chit fund app exactly as we imagined — fast, reliable, and beautifully designed. Launched on App Store in 3 months."',
      name: 'Ramesh Kumar', role: 'Founder, ChitSoft',
      initials: 'RK', color: const Color(0xFFD4FF3C),
    ),
    Testimonial(
      quote: '"The Namma Ooru Cab app exceeded our expectations. Real-time tracking works flawlessly and our drivers love the interface."',
      name: 'Senthil Kumar', role: 'CEO, Namma Ooru',
      initials: 'SK', color: const Color(0xFF8B6FFF),
    ),
    Testimonial(
      quote: '"Building a healthcare app requires sensitivity and precision. Srinithi nailed both — our Yuvathi users trust and love the app."',
      name: 'Priya Meenakshi', role: 'Director, Yuvathi Health',
      initials: 'PM', color: const Color(0xFF5CCCFF),
    ),
  ];

  final List<ProjectModel> projects = [
    ProjectModel(
      title: 'ChitSoft Management',
      desc: 'Real-time chit fund management system with Firebase backend, automated calculations, and beautiful dashboard analytics.',
      screenshots: [
        'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/85/6a/35/856a3545-3a01-e3cd-732e-de8228472876/Login__U00281_U0029.jpg.jpeg/314x680bb.webp',
        'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/e7/5e/9c/e75e9c05-63b7-15bd-17d1-45b0260dd2fa/Group_631879__U00281_U0029.jpg.jpeg/314x680bb.webp',
        'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/c1/69/47/c1694772-14e2-336b-b3ea-5ca1fa9ff1f3/receipt__U00281_U0029.jpg.jpeg/314x680bb.webp',
        'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/3d/27/4e/3d274eb3-9b6b-b1c4-40f3-18ba2fc77c73/View_Enrollment__U00281_U0029.jpg.jpeg/314x680bb.webp',
      ],
      github: '',
      category: 'Mobile Apps',
      tags: ['Flutter', 'Firebase', 'Real-time'],
      appStore: 'https://apps.apple.com/in/app/chitsoft-chitfund-mangagement/id6757467879',
    ),
    ProjectModel(
      title: 'Namma Ooru Cab',
      desc: 'All-in-One Driver Platform for Hiring & Driving Services. Connects customers with verified drivers for daily travel, office trips, and more.',
      screenshots: [
        'assets/namma_1.webp',
        'assets/namma_2.webp',
        'assets/namma_3.webp',
        'assets/namma_4.webp',
      ],
      github: '',
      category: 'Mobile Apps',
      tags: ['Flutter', 'Google Maps', 'Driver Booking'],
      playStore: 'https://play.google.com/store/apps/details?id=com.nammaoorucab',
    ),
    ProjectModel(
      title: 'Yuvathi – HPV Test & Screening',
      desc: 'Women’s health support app designed to help users understand HPV screening and manage ordering HPV self-collection test kits.',
      screenshots: [
        'assets/yuvathi_1.webp',
        'assets/yuvathi_2.webp',
        'assets/yuvathi_3.webp',
        'assets/yuvathi_4.webp',
      ],
      github: '',
      category: 'Mobile Apps',
      tags: ['Flutter', 'Health Care', 'Screening'],
      playStore: 'https://play.google.com/store/apps/details?id=appyuvathi.health.com',
    ),
    ProjectModel(
      title: 'E-Commerce App (Freelance)',
      desc: 'Full-featured shopping app with payment gateway, order tracking, wishlists, and admin dashboard.',
      screenshots: [
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1472851294608-062f824d296e?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
      ],
      github: 'https://github.com/yourusername/ecommerce',
      category: 'Freelance',
      tags: ['Flutter', 'REST API', 'Payment'],
    ),
  ];

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    for (var i = 0; i < projects.length; i++) {
      _projectControllers.add(PageController());
    }

    _heroTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_heroController.hasClients) {
        final next = ((_heroController.page?.round() ?? 0) + 1) % 3;
        _heroController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });

    for (int i = 0; i < _projectControllers.length; i++) {
      Timer.periodic(Duration(seconds: 4 + i), (_) {
        if (_projectControllers[i].hasClients) {
          final next = ((_projectControllers[i].page?.round() ?? 0) + 1) %
              projects[i].screenshots.length;
          _projectControllers[i].animateToPage(
            next,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }

    _scrollController.addListener(() {
      setState(() => scrollPos = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _iconController.dispose();
    _heroTimer.cancel();
    _heroController.dispose();
    for (final c in _projectControllers) {
      c.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    }
  }

  List<ProjectModel> get filteredProjects {
    if (_selectedCategory == 0) return projects;
    return projects
        .where((p) => p.category == categories[_selectedCategory])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      body: Stack(
        children: [
          // Enhanced animated background with tech icons
          Positioned.fill(
            child: CustomPaint(
              painter: TechIconBackgroundPainter(
                animation: _iconController,
                primaryColor: const Color(0xFF00D9FF),
                secondaryColor: const Color(0xFF7B2FF7),
                 
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                   Colors.black.withOpacity(0.3),
                       Colors.black.withOpacity(0.3),
                  ],
                  
                ),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isWide ? 90 : 80), // Spacer for sticky Navbar
                Container(key: _homeKey, child: _heroSection(isWide)),
                const SizedBox(height: 100),
                Container(key: _aboutKey, child: _aboutSection(isWide)),
                const SizedBox(height: 100),
                Container(key: _skillsKey, child: _skillsSection(isWide)),
                const SizedBox(height: 100),
                Container(key: _projectsKey, child: _projectsSection(isWide)),
                const SizedBox(height: 100),
                _servicesSection(isWide),
                const SizedBox(height: 100),
                _testimonialsSection(isWide),
                const SizedBox(height: 100),
                _freelanceSection(isWide),
                const SizedBox(height: 100),
                Container(key: _contactKey, child: _contactSection(isWide)),
                _footer(),
              ],
            ),
          ),
          
          // Sticky top navigation with glass effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _topNav(isWide),
          ),
        ],
      ),
    );
  }

  Widget _topNav(bool isWide) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF00D9FF).withOpacity(0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Srinithi E',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (isWide)
                Row(
                  children: [
                    _navItem('Home', _homeKey),
                    _navItem('About', _aboutKey),
                    _navItem('Skills', _skillsKey),
                    _navItem('Projects', _projectsKey),
                    _navItem('Contact', _contactKey),
                  ],
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => _showMobileMenu(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _mobileNavItem('Home', _homeKey, Icons.home),
            _mobileNavItem('About', _aboutKey, Icons.person),
            _mobileNavItem('Skills', _skillsKey, Icons.code),
            _mobileNavItem('Projects', _projectsKey, Icons.work),
            _mobileNavItem('Contact', _contactKey, Icons.email),
          ],
        ),
      ),
    );
  }

  Widget _mobileNavItem(String title, GlobalKey key, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00D9FF)),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _scrollToSection(key);
      },
    );
  }

  Widget _navItem(String title, GlobalKey key) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () => _scrollToSection(key),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _heroSection(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 32,
        vertical: 80,
      ),
      child: Flex(
        direction: isWide ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              final col = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CREATIVE UI',
                    style: GoogleFonts.poppins(
                      fontSize: isWide ? 56 : 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF00D9FF), Color(0xFF00D9FF)],
                    ).createShader(bounds),
                    child: Text(
                      'MOBILE APP',
                      style: GoogleFonts.poppins(
                        fontSize: isWide ? 56 : 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Text(
                    'DEVELOPER',
                    style: GoogleFonts.poppins(
                      fontSize: isWide ? 56 : 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _gradientButton(
                        'Hire Me',
                        onTap: () => _openUrl('https://wa.me/918610273937'),
                      ),
                      _outlineButton(
                        'Download CV',
                        icon: Icons.download_rounded,
                        onTap: () => _openUrl('assets/resume.pdf'),
                      ),
                    ],
                  ),
                  if (isWide) ...[
                    const SizedBox(height: 40),
                    _scrollIndicator(),
                  ],
                ],
              );
              return isWide ? Expanded(flex: 3, child: col) : col;
            },
          ),
          const SizedBox(width: 60, height: 40),
         Image.asset(
                'assets/background_vector.gif'
              ),
        ],
      ),
    );
  }

  Widget _scrollIndicator() {
    return Column(
      children: [
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white38,
          size: 32,
        ),
      ],
    );
  }

  static const kBg      = Color(0xFF0E1621); // Dark Teal-Blue Background
  static const kS1      = Color(0xFF14202E); // Slightly lighter teal surface
  static const kS2      = Color(0xFF1A2A3A); // Surface for cards
  static const kS3      = Color(0xFF22344A); // Inner borders/Dividers
  static const kDim     = Color(0xFF2A425A); // Border dividers
  static const kLime    = Color(0xFF14D4C4); // Main Cyan/Teal Accent
  static const kViolet  = Color(0xFF0FC1B4); // Lighter accent Cyan
  static const kCoral   = Color(0xFFFF6B6B); // Soft error accent
  static const kSky     = Color(0xFF14D4FF); // Bright cyan accents
  static const kTxt     = Color(0xFFE2E8F0); // Off-White Text
  static const kMuted   = Color(0xFF718096); // Soft Grey Description Text

  TextStyle _syne(double size, FontWeight w, Color c, {double? height, double? spacing}) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: w, color: c,
          height: height, letterSpacing: spacing);

  TextStyle _mono(double size, Color c) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: c);

  Widget _aboutSection(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 48 : 24),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kDim))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('About Me'),
        const SizedBox(height: 16),
        _sectionTitle('Who I ', 'am'),
        const SizedBox(height: 32),
        isWide
          ? IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(flex: 2, child: _aboutMainCard()),
              const SizedBox(width: 12),
              Expanded(child: _skillsCard()),
            ]))
          : Column(children: [_aboutMainCard(), const SizedBox(height: 12), _skillsCard()]),
        const SizedBox(height: 12),
        isWide
          ? Row(children: [
              Expanded(child: _bentoStatCard('3+', 'years_of_experience', kLime)),
              const SizedBox(width: 12),
              Expanded(child: _bentoStatCard('15+', 'apps_delivered', kViolet)),
              const SizedBox(width: 12),
              Expanded(child: _bentoStatCard('3', 'live_on_stores', kSky)),
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _bentoHighlight()),
            ])
          : Wrap(spacing: 12, runSpacing: 12, children: [
              _bentoStatCard('3+', 'years_of_experience', kLime),
              _bentoStatCard('15+', 'apps_delivered', kViolet),
              _bentoStatCard('3', 'live_on_stores', kSky),
              _bentoHighlight(),
            ]),
        const SizedBox(height: 12),
        isWide
          ? Row(children: [
              Expanded(child: _timelineCard()),
              const SizedBox(width: 12),
              Expanded(child: _quoteCard()),
            ])
          : Column(children: [_timelineCard(), const SizedBox(height: 12), _quoteCard()]),
      ]),
    );
  }

  Widget _aboutMainCard() => Container(
    padding: const EdgeInsets.all(28),
    decoration: _cardDeco(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('My Story', style: _mono(9, kMuted).copyWith(letterSpacing: 2)),
      const SizedBox(height: 12),
      Text("Passionate about building apps people actually love to use.",
        style: _syne(18, FontWeight.w600, kTxt, spacing: -0.5, height: 1.2)),
      const SizedBox(height: 12),
      Text("I'm a Flutter developer based in Tiruppur, Tamil Nadu. I specialize in building "
        "cross-platform mobile apps that feel native, look stunning, and scale reliably.",
        style: GoogleFonts.poppins(color: Colors.white70, height: 1.8, fontSize: 16)),
      const SizedBox(height: 8),
      Text("From chit fund systems to healthcare screening apps — I've shipped real "
        "products used by real people. I care deeply about performance.",
        style: GoogleFonts.poppins(color: Colors.white70, height: 1.8, fontSize: 16)),
      const SizedBox(height: 20),
      Wrap(spacing: 6, runSpacing: 6, children: [
        _pill('Flutter', highlight: true), _pill('Dart', highlight: true),
        _pill('Firebase', highlight: true), _pill('Figma'), _pill('REST APIs'),
        _pill('BLoC'), _pill('Riverpod'), _pill('Git'),
      ]),
    ]),
  );

  Widget _skillsCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: _cardDeco(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Proficiency', style: _mono(9, kMuted).copyWith(letterSpacing: 2)),
      const SizedBox(height: 16),
      _skillBar('Flutter',  0.92, kLime),
      _skillBar('Firebase', 0.85, kLime),
      _skillBar('UI Design',0.80, kLime),
      _skillBar('REST APIs',0.88, kLime),
      _skillBar('Figma',    0.75, kLime),
    ]),
  );

  Widget _skillBar(String label, double pct, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      SizedBox(width: 70, child: Text(label, style: _mono(10, kMuted))),
      Expanded(child: Container(
        height: 3,
        decoration: BoxDecoration(color: kDim, borderRadius: BorderRadius.circular(2)),
        child: FractionallySizedBox(
          widthFactor: pct, alignment: Alignment.centerLeft,
          child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        ),
      )),
      const SizedBox(width: 8),
      Text('${(pct * 100).round()}%', style: _mono(13, kMuted)),
    ]),
  );

  Widget _bentoStatCard(String n, String l, Color color) => Container(
    padding: const EdgeInsets.all(24),
    decoration: _cardDeco(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l, style: _mono(13, kMuted).copyWith(letterSpacing: 1)),
      const SizedBox(height: 6),
      Text(n, style: GoogleFonts.playfairDisplay(
        fontSize: 48, fontWeight: FontWeight.w700, color: color, height: 1)),
    ]),
  );

  Widget _bentoHighlight() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: kLime, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Status', style: _mono(13, kBg.withOpacity(0.5)).copyWith(letterSpacing: 2)),
      const SizedBox(height: 8),
      Text('Open to freelance & full-time',
        style: _syne(15, FontWeight.w600, kBg, height: 1.2)),
      const SizedBox(height: 6),
      Text('Response within 24h', style: _syne(15, FontWeight.w300, kBg.withOpacity(0.55))),
    ]),
  );

  Widget _timelineCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: _cardDeco(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Timeline', style: _mono(13, kMuted).copyWith(letterSpacing: 2)),
      const SizedBox(height: 16),
      _tlItem('2026 — Present', 'Freelance Flutter Developer', 'Building apps for startups across India', kLime),
      _tlItem('2026', 'Yuvathi HPV App', 'Healthcare Flutter app — Google Play', kViolet),
      _tlItem('2025', 'ChitSoft & Namma Ooru Cab', 'Two production apps shipped to stores', kSky, last: true),
    ]),
  );

  Widget _tlItem(String yr, String title, String sub, Color color, {bool last = false}) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 14),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(width: 8, height: 8,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        if (!last) Container(width: 1, height: 40, color: kDim),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(yr, style: _mono(13, color)),
        const SizedBox(height: 3),
        Text(title, style: _syne(16, FontWeight.w600, kTxt)),
        Text(sub, style: _syne(14, FontWeight.w300, kMuted)),
        if (!last) const SizedBox(height: 6),
      ])),
    ]),
  );

  Widget _quoteCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: _cardDeco(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Philosophy', style: _mono(13, kMuted).copyWith(letterSpacing: 2)),
      const SizedBox(height: 16),
      Text(
        '"Great apps aren\'t just built —\nthey\'re designed, iterated,\nand loved into existence."',
        style: GoogleFonts.playfairDisplay(
          fontSize: 20, fontStyle: FontStyle.italic, color: kTxt, height: 1.5),
      ),
      const SizedBox(height: 14),
      Text('— Srinithi E, Flutter Developer', style: _mono(10, kMuted)),
    ]),
  );

  BoxDecoration _cardDeco() => BoxDecoration(
    color: kS1, border: Border.all(color: kDim),
    borderRadius: BorderRadius.circular(14),
  );

  Widget _sectionLabel(String text) => Row(children: [
    Text(text.toUpperCase(),
      style: _mono(13, kLime).copyWith(letterSpacing: 3)),
    const SizedBox(width: 12),
    Expanded(child: Container(height: 1, color: kDim)),
  ]);

  Widget _sectionTitle(String normal, String accent) => RichText(
    text: TextSpan(children: [
      TextSpan(text: normal, style: GoogleFonts.poppins(
        fontSize: 48, fontWeight: FontWeight.w800, color: kTxt,
        letterSpacing: -1.5, height: 1.1)),
      const TextSpan(text: ' '), // Standard inline space layout!
      TextSpan(text: accent, style: GoogleFonts.poppins(
        fontSize: 48, fontWeight: FontWeight.w800, 
        color: kLime, letterSpacing: -1.5, height: 1.1)),
    ]),
  );

  Widget _pill(String label, {bool highlight = false}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: highlight ? kLime.withOpacity(0.06) : Colors.transparent,
      border: Border.all(color: highlight ? kLime.withOpacity(0.3) : kDim),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(label, style: _mono(9, highlight ? kLime : kMuted)),
  );
  Widget _skillsSection(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 32, vertical: 60),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: isWide ? 48 : 36,
                fontWeight: FontWeight.w800,
              ),
              children: const [
                TextSpan(
                  text: 'My ',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'Expertise',
                  style: TextStyle(color: Color(0xFF00D9FF)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const ModernSkillsExploratory(),
        ],
      ),
    );
  }

  Widget _skillCard(String title, String subtitle, IconData icon) {
    return HoverWidget(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 180,
            height: 200,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1C2833).withOpacity(0.85),
                  const Color(0xFF2C3E50).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00D9FF).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D9FF).withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white60,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _projectsSection(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 32, vertical: 60),
      child: Column(
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: isWide ? 48 : 36,
                    fontWeight: FontWeight.w800,
                  ),
                  children: const [
                    TextSpan(
                      text: 'My Recent ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Works',
                      style: TextStyle(color: Color(0xFF00D9FF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(
              categories.length,
              (i) => _categoryChip(categories[i], i == _selectedCategory, () {
                setState(() => _selectedCategory = i);
              }),
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: List.generate(
              filteredProjects.length,
              (i) => _projectCard(
                filteredProjects[i],
                _projectControllers[projects.indexOf(filteredProjects[i])],
              ),
            ),
          ),
            const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
                )
              : null,
          color: selected ? null : const Color(0xFF2C3E50),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : const Color(0xFF00D9FF).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _projectCard(ProjectModel p, PageController controller) {
    return HoverWidget(
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1C2833).withOpacity(0.9),
              const Color(0xFF2C3E50).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF00D9FF).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.desc,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.tags.map((tag) => _tagChip(tag)).toList(),
                  ),
                ],
              ),
            ),
            Center(
              child: PhoneMockup(
                controller: controller,
                screenshots: p.screenshots,
                width: 150,
                height: 300,
                borderRadius: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (p.github.isNotEmpty)
                    Expanded(
                      child: _iconButton(
                        'View Code',
                        Icons.code,
                        () => _openUrl(p.github),
                      ),
                    ),
                  if (p.github.isNotEmpty) const SizedBox(width: 12),
                  Expanded(
                    child: _iconButton(
                      p.appStore != null
                          ? 'App Store'
                          : (p.playStore != null ? 'Play Store' : 'Live Demo'),
                      p.appStore != null
                          ? Icons.storefront
                          : (p.playStore != null ? Icons.shop : Icons.open_in_new),
                      () {
                        if (p.appStore != null) {
                          _openUrl(p.appStore!);
                        } else if (p.playStore != null) {
                          _openUrl(p.playStore!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF00D9FF).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00D9FF).withOpacity(0.4),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: const Color(0xFF00D9FF),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _iconButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _freelanceSection(bool isWide) {
    return Column(
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: isWide ? 48 : 36,
                    fontWeight: FontWeight.w800,
                  ),
                  children: const [
                    TextSpan(
                      text: ' New  ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: ' Projects?',
                      style: TextStyle(color: Color(0xFF00D9FF)),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/freelance.gif'
              ),],),
            Container(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 32, vertical: 60),
              child: Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF00D9FF).withOpacity(0.1),
                      const Color(0xFF7B2FF7).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color(0xFF00D9FF).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 64,
                      color: Color(0xFF00D9FF),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Available for Freelance Projects',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isWide ? 36 : 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'I\'m currently accepting freelance work and new project opportunities. '
                      'Whether you need a complete mobile app from scratch or help with an existing project, '
                      'I\'m here to bring your ideas to life with clean code and beautiful design.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        height: 1.8,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 32,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _serviceItem(Icons.phone_android, 'Mobile Apps', 'iOS & Android'),
                        _serviceItem(Icons.design_services, 'UI/UX Design', 'Beautiful interfaces'),
                        _serviceItem(Icons.api, 'API Integration', 'Backend connectivity'),
                        _serviceItem(Icons.bug_report, 'Bug Fixes', 'Fast & reliable'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _gradientButton(
                      'Start a Project',
                      onTap: () => _openUrl('mailto:srinithie86@gmail.com'),
                      large: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
  }

  Widget _serviceItem(IconData icon, String title, String subtitle) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00D9FF).withOpacity(0.2),
                  const Color(0xFF7B2FF7).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF00D9FF), size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
}
  // --- INSERT REDESIGN START ---
Widget _servicesSection(bool wide) {
    return Container(
      padding: EdgeInsets.all(wide ? 48 : 24),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kDim))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('What I Do'),
        const SizedBox(height: 16),
        _sectionTitle('My ', 'services'),
        const SizedBox(height: 32),
        Wrap(spacing: 16, runSpacing: 16, children: _services.map((s) =>
          SizedBox(width: wide ? 260 : double.infinity, child: HoverWidget(child: _serviceCard(s)))
        ).toList()),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(border: Border.all(color: kDim), borderRadius: BorderRadius.circular(14)),
          child: wide
            ? IntrinsicHeight(child: Row(children: _processSteps(wide)))
            : Column(children: _processSteps(wide)),
        ),
      ]),
    );
  }

Widget _serviceCard(ServiceItem s) => Container(
    padding: const EdgeInsets.all(24),
    decoration: _cardDeco(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(s.number, style: _mono(13, kDim)),
      const SizedBox(height: 14),
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(color: s.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(s.icon, color: s.color, size: 22),
      ),
      const SizedBox(height: 14),
      Text(s.title, style: _syne(14, FontWeight.w600, kTxt, spacing: -0.2)),
      const SizedBox(height: 6),
      Text(s.desc, style: GoogleFonts.poppins(color: Colors.white70, height: 1.8, fontSize: 16)),
      const SizedBox(height: 12),
      ...s.bullets.map((b) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [Text('→ ', style: _mono(9, kLime)), Text(b, style: _mono(10, kMuted))]),
      )),
    ]),
  );

List<Widget> _processSteps(bool wide) {
    final steps = [
      ('01 — Discovery', 'Understanding', 'Deep-dive into your idea, goals, and target audience.'),
      ('02 — Design', 'Wireframing', 'Figma wireframes and prototypes, iterated until perfect.'),
      ('03 — Build', 'Development', 'Clean Flutter code with proper state management.'),
      ('04 — Test', 'QA & Polish', 'Thorough testing across devices, fixing edge cases.'),
      ('05 — Launch', 'Deployment', 'App Store & Play Store submission with live support.'),
    ];
    return steps.asMap().entries.map((e) {
      final i = e.key; final s = e.value;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: i == 0 ? kLime.withOpacity(0.05) : Colors.transparent,
            border: wide ? Border(right: i < steps.length - 1 ? BorderSide(color: kDim) : BorderSide.none)
                        : Border(bottom: i < steps.length - 1 ? BorderSide(color: kDim) : BorderSide.none),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.$1, style: _mono(9, kLime)),
            const SizedBox(height: 10),
            Text(s.$2, style: _syne(13, FontWeight.w600, kTxt, spacing: -0.2)),
            const SizedBox(height: 4),
            Text(s.$3, style: _syne(11, FontWeight.w300, kMuted, height: 1.6)),
          ]),
        ),
      );
    }).toList();
  }

Widget _testimonialsSection(bool wide) {
    return Container(
      padding: EdgeInsets.all(wide ? 48 : 24),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kDim))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('Social Proof'),
        const SizedBox(height: 16),
        _sectionTitle('What clients ', 'say'),
        const SizedBox(height: 32),
        Wrap(spacing: 12, runSpacing: 12, children: _testimonials.map((t) => SizedBox(width: wide ? 340 : double.infinity, child: _testiCard(t))).toList()),
      ]),
    );
  }

Widget _testiCard(Testimonial t) => Container(
    padding: const EdgeInsets.all(24),
    decoration: _cardDeco(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: List.generate(5, (_) => const Icon(Icons.star_rounded, color: kLime, size: 13))),
      const SizedBox(height: 14),
      Text(t.quote, style: _syne(13, FontWeight.w300, kTxt, height: 1.7).copyWith(fontStyle: FontStyle.italic)),
      const SizedBox(height: 16),
      Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: t.color.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(child: Text(t.initials, style: _mono(11, t.color))),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.name, style: _syne(12, FontWeight.w600, kTxt)), Text(t.role, style: _mono(9, kMuted))]),
      ]),
    ]),
  );

Widget _contactSection(bool wide) {
    return Container(
      padding: EdgeInsets.all(wide ? 48 : 24),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kDim))),
      child: wide
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _contactLeft()), const SizedBox(width: 40), Expanded(child: _contactForm())])
        : Column(children: [_contactLeft(), const SizedBox(height: 32), _contactForm()]),
    );
  }

Widget _contactLeft() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _sectionLabel('Get In Touch'),
    const SizedBox(height: 20),
    RichText(text: TextSpan(children: [
      TextSpan(text: "Let's build\nsomething ", style: GoogleFonts.playfairDisplay(fontSize: 52, fontWeight: FontWeight.w700, color: kTxt, height: 1, letterSpacing: -2.5)),
      TextSpan(text: 'great.', style: GoogleFonts.playfairDisplay(fontSize: 52, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: kLime, height: 1, letterSpacing: -2.5)),
    ])),
    const SizedBox(height: 20),
    Text("Whether you have a fully-formed idea or just a spark — let's talk.", style: _syne(14, FontWeight.w300, kMuted, height: 1.8)),
    const SizedBox(height: 32),
    _contactItem(Icons.email_rounded, 'Email', 'srinithie86@gmail.com', () => launchUrl(Uri.parse('mailto:srinithie86@gmail.com'))),
    const SizedBox(height: 14),
    _contactItem(Icons.location_on_rounded, 'Location', 'Tiruppur, Tamil Nadu, India', null),
    const SizedBox(height: 24),
    Wrap(spacing: 8, children: [
      _socialBtn(FontAwesomeIcons.linkedinIn, 'https://linkedin.com/'),
      _socialBtn(FontAwesomeIcons.github, 'https://github.com/'),
      _socialBtn(Icons.mail_rounded, 'mailto:srinithie86@gmail.com'),
    ]),
  ]);

Widget _contactItem(IconData icon, String label, String value, VoidCallback? onTap, {Color? valueColor}) => GestureDetector(
    onTap: onTap,
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: kS2, border: Border.all(color: kDim), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: kLime, size: 16)),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: _mono(9, kMuted)), Text(value, style: _syne(13, FontWeight.w500, valueColor ?? kTxt))]),
    ]),
  );

Widget _socialBtn(IconData icon, String url) => GestureDetector(
    onTap: () => launchUrl(Uri.parse(url)),
    child: Container(width: 40, height: 40, decoration: BoxDecoration(color: kS2, border: Border.all(color: kDim), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: kMuted, size: 16)),
  );

Widget _contactForm() => Container(
    padding: const EdgeInsets.all(28),
    decoration: _cardDeco(),
    child: Column(children: [
      Row(children: [Expanded(child: _field('Name', 'Your name')), const SizedBox(width: 12), Expanded(child: _field('Email', 'your@email.com'))]),
      const SizedBox(height: 12),
      _field('Project Details', 'Describe your app idea, goals...', maxLines: 4),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: () => _openUrl('https://wa.me/918610273937'), child: Text('Send Message', style: _syne(14, FontWeight.w600, kBg)), style: ElevatedButton.styleFrom(backgroundColor: kLime, minimumSize: Size(double.infinity, 44))),
    ]),
  );

Widget _field(String label, String hint, {int maxLines = 1}) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label.toUpperCase(), style: _mono(9, kMuted)),
    const SizedBox(height: 6),
    TextField(maxLines: maxLines, decoration: InputDecoration(hintText: hint, filled: true, fillColor: kS2)),
  ]);
  // --- INSERT REDESIGN END ---

Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00D9FF), size: 20),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

Widget _footer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF00D9FF).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _socialButton(Icons.code, 'https://github.com/yourusername'),
              _socialButton(Icons.business, 'https://linkedin.com/'),
              _socialButton(Icons.email, 'mailto:srinithie86@gmail.com'),
              _socialButton(Icons.phone_android, 'tel:+1234567890'),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} Srinithi E. Crafted with Flutter',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All rights reserved',
            style: GoogleFonts.poppins(
              color: Colors.white24,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

Widget _socialButton(IconData icon, String url) {
    return InkWell(
      onTap: () => _openUrl(url),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00D9FF).withOpacity(0.2),
              const Color(0xFF7B2FF7).withOpacity(0.2),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF00D9FF).withOpacity(0.3),
          ),
        ),
        child: Icon(icon, color: const Color(0xFF00D9FF), size: 22),
      ),
    );
  }

Widget _contactField(String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white38),
        prefixIcon: Icon(icon, color: const Color(0xFF00D9FF)),
        filled: true,
        fillColor: const Color(0xFF1C2833),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF00D9FF).withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF00D9FF).withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF00D9FF),
            width: 2,
          ),
        ),
      ),
    );
  }

Widget _gradientButton(
    String label, {
    VoidCallback? onTap,
    IconData? icon,
    bool large = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: large ? 40 : 24,
          vertical: large ? 18 : 14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00D9FF), Color(0xFF7B2FF7)],
          ),
          borderRadius: BorderRadius.circular(large ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D9FF).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: large ? 24 : 20),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: large ? 18 : 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _outlineButton(String label, {IconData? icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF00D9FF),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFF00D9FF), size: 20),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                color: const Color(0xFF00D9FF),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Hover Scale and Glow Wrapper for Cards
class HoverWidget extends StatefulWidget {
  final Widget child;
  final double scale;
  const HoverWidget({super.key, required this.child, this.scale = 1.04});

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -8.0 : 0.0, 0), // Adds movable slide depth!
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: _isHovered ? [
              BoxShadow(
                color: const Color(0xFF14D4C4).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 2,
              )
            ] : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// --- EXPLORATORY SKILLS WIDGET START ---
class SkillNode {
  final IconData? icon;
  final String? imageUrl;
  final Color color;
  SkillNode({this.icon, this.imageUrl, required this.color});
}

class ModernSkillsExploratory extends StatefulWidget {
  const ModernSkillsExploratory({super.key});

  @override
  State<ModernSkillsExploratory> createState() => _ModernSkillsExploratoryState();
}

class _ModernSkillsExploratoryState extends State<ModernSkillsExploratory>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 650.0;
        final center = Offset(width / 2, height - 150);

        final row1 = [
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/figma/figma-original.svg", color: Colors.purpleAccent), // Figma
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original.svg", color: Colors.cyanAccent), // React
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/cplusplus/cplusplus-original.svg", color: Colors.blue), // C++
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/nodejs/nodejs-original.svg", color: Colors.greenAccent), // Node.js
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/redux/redux-original.svg", color: Colors.deepPurpleAccent), // Redux
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/javascript/javascript-original.svg", color: Colors.yellow), // JavaScript
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/css3/css3-original.svg", color: Colors.blueAccent), // CSS3
        ];

        final row2 = [
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/xd/xd-plain.svg", color: Colors.pink), // Adobe XD
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/nextjs/nextjs-original.svg", color: Colors.white), // Next.js
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/gatsby/gatsby-original.svg", color: Colors.purpleAccent), // Gatsby
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/illustrator/illustrator-plain.svg", color: Colors.orangeAccent), // Illustrator
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/express/express-original.svg", color: Colors.white70), // Express
          SkillNode(imageUrl: "https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original.svg", color: Colors.green), // MongoDB
        ];

        final row3 = <SkillNode>[];

        final orbitItems = [
          SkillNode(icon: FontAwesomeIcons.linkedin, color: Colors.blue),
          SkillNode(icon: FontAwesomeIcons.github, color: Colors.white),
          SkillNode(icon: FontAwesomeIcons.gear, color: Colors.grey),
          SkillNode(icon: Icons.bolt, color: Colors.amberAccent),
        ];

        final topNodePositions = <Offset>[];

        for (int i = 0; i < row1.length; i++) {
          final x = 80 + (width - 160) * (i + 1) / (row1.length + 1);
          final y = 90.0 + (i % 2 == 0 ? 0 : 20);
          topNodePositions.add(Offset(x, y));
        }

        for (int i = 0; i < row2.length; i++) {
          final x = 120 + (width - 240) * (i + 1) / (row2.length + 1);
          final y = 180.0 + (i % 2 == 0 ? 0 : -15);
          topNodePositions.add(Offset(x, y));
        }

        for (int i = 0; i < row3.length; i++) {
          final x = 160 + (width - 320) * (i + 1) / (row3.length + 1);
          final y = 260.0 + (i % 2 == 0 ? 0 : 10);
          topNodePositions.add(Offset(x, y));
        }

        final allTopNodes = [...row1, ...row2, ...row3];

        final orbitRX = width * 0.35;
        final orbitRY = 45.0; // Flat flattened saturn shape

        return Container(
          height: height,
          width: width,
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SkillsConnectionPainter(
                        center: center,
                        targets: topNodePositions,
                        orbitRadiusX: orbitRX,
                        orbitRadiusY: orbitRY,
                      ),
                    ),
                  ),

                  Positioned(
                    left: center.dx - 55,
                    top: center.dy - 55,
                    child: HoverWidget(
                      scale: 1.1,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00D9FF),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D9FF).withOpacity(0.5),
                              blurRadius: 70,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'S',
                            style: TextStyle(
                                fontSize: 45, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ...List.generate(orbitItems.length, (i) {
                    final node = orbitItems[i];
                    final angleOffset = (math.pi * 2 / orbitItems.length) * i;
                    final angle = _rotationController.value * math.pi * 2 + angleOffset;
                    final dx = center.dx + orbitRX * math.cos(angle);
                    final dy = center.dy + orbitRY * math.sin(angle);

                    return Positioned(
                      left: dx - 18,
                      top: dy - 18,
                      child: HoverWidget(
                        scale: 1.2,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2833),
                            shape: BoxShape.circle,
                            border: Border.all(color: node.color.withOpacity(0.6), width: 1.5),
                          ),
                          child: Center(
                            child: node.imageUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: node.imageUrl!.contains('.svg')
                                        ? SvgPicture.network(
                                            node.imageUrl!,
                                            placeholderBuilder: (_) => const SizedBox(
                                                width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5)),
                                          )
                                        : Image.network(node.imageUrl!,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image, size: 16)),
                                  )
                                : Icon(node.icon, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    );
                  }),

                  ...List.generate(allTopNodes.length, (i) {
                    final pos = topNodePositions[i];
                    final node = allTopNodes[i];
                    return Positioned(
                      left: pos.dx - 24,
                      top: pos.dy - 24,
                      child: HoverWidget(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2833),
                            shape: BoxShape.circle,
                            border: Border.all(color: node.color.withOpacity(0.7), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: node.color.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: node.imageUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: node.imageUrl!.contains('.svg')
                                        ? SvgPicture.network(
                                            node.imageUrl!,
                                            placeholderBuilder: (_) => const SizedBox(
                                                width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                                          )
                                        : Image.network(node.imageUrl!,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image, size: 20)),
                                  )
                                : Icon(node.icon, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class SkillsConnectionPainter extends CustomPainter {
  final Offset center;
  final List<Offset> targets;
  final double orbitRadiusX;
  final double orbitRadiusY;

  SkillsConnectionPainter({
    required this.center,
    required this.targets,
    required this.orbitRadiusX,
    required this.orbitRadiusY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF00D9FF).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final target in targets) {
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.cubicTo(
        center.dx, center.dy - 80, 
        target.dx, center.dy,      
        target.dx, target.dy,      
      );
      canvas.drawPath(path, linePaint);
    }

    final orbitPaint = Paint()
      ..color = const Color(0xFF00D9FF).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int r = 1; r <= 3; r++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: orbitRadiusX * r * 0.7,
          height: orbitRadiusY * r * 0.7,
        ),
        orbitPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// --- EXPLORATORY SKILLS WIDGET END ---

// Vector Illustrations
class DeveloperIllustration extends StatelessWidget {
  final double size;
  const DeveloperIllustration({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DeveloperPainter(),
    );
  }
}

class DeveloperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Person sitting with laptop
    final bodyPaint = Paint()..color = Colors.white;
    final accentPaint = Paint()..color = const Color(0xFF00D9FF);
    final hairPaint = Paint()..color = const Color(0xFF00D9FF);
    
    // Head
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.25),
      size.width * 0.08,
      bodyPaint,
    );
    
    // Hair
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.48, size.height * 0.2)
        ..quadraticBezierTo(
          size.width * 0.55,
          size.height * 0.15,
          size.width * 0.62,
          size.height * 0.2,
        ),
      hairPaint,
    );
    
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.45,
          size.height * 0.32,
          size.width * 0.2,
          size.height * 0.25,
        ),
        const Radius.circular(15),
      ),
      bodyPaint,
    );
    
    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.55,
          size.width * 0.15,
          size.height * 0.3,
        ),
        const Radius.circular(10),
      ),
      accentPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.55,
          size.height * 0.55,
          size.width * 0.15,
          size.height * 0.3,
        ),
        const Radius.circular(10),
      ),
      accentPaint,
    );
    
    // Laptop
    final laptopPaint = Paint()
      ..color = const Color(0xFF34495E)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.35,
          size.height * 0.45,
          size.width * 0.3,
          size.height * 0.15,
        ),
        const Radius.circular(5),
      ),
      laptopPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CodingIllustration extends StatelessWidget {
  final double size;
  const CodingIllustration({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CodingPainter(),
    );
  }
}

class CodingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = Colors.white;
    final accentPaint = Paint()..color = const Color(0xFF00D9FF);
    
    // Person at desk
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      size.width * 0.07,
      bodyPaint,
    );
    
    // Hair
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.28),
      size.width * 0.08,
      accentPaint,
    );
    
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.22,
          size.height * 0.37,
          size.width * 0.16,
          size.height * 0.3,
        ),
        const Radius.circular(12),
      ),
      bodyPaint,
    );
    
    // Desk
    final deskPaint = Paint()..color = const Color(0xFF34495E);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.65,
        size.width * 0.5,
        size.height * 0.05,
      ),
      deskPaint,
    );
    
    // Monitor
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.45,
          size.height * 0.35,
          size.width * 0.35,
          size.height * 0.25,
        ),
        const Radius.circular(8),
      ),
      accentPaint..style = PaintingStyle.stroke..strokeWidth = 10,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ContactIllustration extends StatelessWidget {
  final double size;
  const ContactIllustration({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ContactPainter(),
    );
  }
}

class ContactPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = Colors.white;
    final accentPaint = Paint()..color = const Color(0xFF00D9FF);
    
    // Person with phone
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.3),
      size.width * 0.1,
      bodyPaint,
    );
    
    // Hair
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.27),
      size.width * 0.11,
      accentPaint,
    );
    
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.4,
          size.width * 0.2,
          size.height * 0.3,
        ),
        const Radius.circular(15),
      ),
      bodyPaint,
    );
    
    // Phone
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.35,
          size.height * 0.5,
          size.width * 0.08,
          size.height * 0.15,
        ),
        const Radius.circular(5),
      ),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Enhanced background painter with tech icons
class TechIconBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;

  TechIconBackgroundPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6; // ✅ bolder line weight

    final double iconSize = 50; // ✅ bigger base icon size

    final random = math.Random(42);

    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // Floating motion
      final offset = math.sin(animation.value * 1 * math.pi + i) * 15; // ✅ stronger movement
      final opacity = 0.059 + (math.sin(animation.value *0* math.pi + i) * 0.0); // ✅ more visible

      paint.color =
          (i % 2 == 0 ? primaryColor : secondaryColor).withOpacity(opacity);

      // ✅ Increased all icon sizes
      if (i % 5 == 0) {
        _drawCodeBrackets(canvas, Offset(x, y + offset), iconSize, paint);
      } else if (i % 5 == 1) {
        _drawMobileIcon(canvas, Offset(x, y + offset), iconSize * 1.0, paint);
      } else if (i % 5 == 2) {
        _drawLaptopIcon(canvas, Offset(x, y + offset), iconSize * 1.2, paint);
      } else if (i % 5 == 3) {
        _drawCodeTag(canvas, Offset(x, y + offset), iconSize, paint);
      } else {
        canvas.drawCircle(Offset(x, y + offset), iconSize * 0.5, paint);
      }
    }
  }

  void _drawCodeBrackets(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    // Left bracket {
    path.moveTo(center.dx - size * 0.5, center.dy - size);
    path.quadraticBezierTo(
      center.dx - size,
      center.dy - size * 0.5,
      center.dx - size,
      center.dy,
    );
    path.quadraticBezierTo(
      center.dx - size,
      center.dy + size * 0.5,
      center.dx - size * 0.5,
      center.dy + size,
    );
    canvas.drawPath(path, paint);

    // Right bracket }
    final path2 = Path();
    path2.moveTo(center.dx + size * 0.5, center.dy - size);
    path2.quadraticBezierTo(
      center.dx + size,
      center.dy - size * 0.5,
      center.dx + size,
      center.dy,
    );
    path2.quadraticBezierTo(
      center.dx + size,
      center.dy + size * 0.5,
      center.dx + size * 0.5,
      center.dy + size,
    );
    canvas.drawPath(path2, paint);
  }

  void _drawMobileIcon(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size * 0.6, height: size),
        Radius.circular(size * 0.1),
      ),
      paint,
    );
  }

  void _drawLaptopIcon(Canvas canvas, Offset center, double size, Paint paint) {
    // Screen
    canvas.drawRect(
      Rect.fromCenter(center: Offset(center.dx, center.dy - size * 0.2), width: size, height: size * 0.6),
      paint,
    );
    // Base
    canvas.drawLine(
      Offset(center.dx - size * 0.7, center.dy + size * 0.3),
      Offset(center.dx + size * 0.7, center.dy + size * 0.3),
      paint,
    );
  }

  void _drawCodeTag(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    // < symbol
    path.moveTo(center.dx - size * 0.3, center.dy - size * 0.5);
    path.lineTo(center.dx - size * 0.8, center.dy);
    path.lineTo(center.dx - size * 0.3, center.dy + size * 0.5);
    
    // > symbol
    path.moveTo(center.dx + size * 0.3, center.dy - size * 0.5);
    path.lineTo(center.dx + size * 0.8, center.dy);
    path.lineTo(center.dx + size * 0.3, center.dy + size * 0.5);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TechIconBackgroundPainter oldDelegate) =>
      oldDelegate.animation.value != animation.value;
}
// Phone mockup widget
class PhoneMockup extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final PageController controller;
  final List<String> screenshots;

  const PhoneMockup({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.controller,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1C2833),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0xFF00D9FF).withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9FF).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: controller,
              itemCount: screenshots.length,
              itemBuilder: (_, i) {
                final src = screenshots[i];
                if (src.startsWith('http')) {
                  return Image.network(
                    src,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
                  );
                }
                return Image.asset(
                  src,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
                );
              },
            ),
            Positioned(
              top: 8,
              left: width / 2 - 25,
              child: Container(
                width: 50,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model
class ProjectModel {
  final String title;
  final String desc;
  final List<String> screenshots;
  final String github;
  final String category;
  final List<String> tags;
  final String? appStore;
  final String? playStore;

  ProjectModel({
    required this.title,
    required this.desc,
    required this.screenshots,
    required this.github,
    required this.category,
    required this.tags,
    this.appStore,
    this.playStore,
  });

}
