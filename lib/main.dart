// lib/main.dart
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
          seedColor: const Color(0xFF00BFFF), // Sky Blue
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF020408),
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
    required this.icon,
    required this.number,
    required this.title,
    required this.desc,
    required this.color,
    required this.bullets,
  });
}
class ProjectModel {
  final String title, desc, category, github;
  final List<String> screenshots;
  final List<String> tags;
  final String? appStore, playStore;
  final String? impact;
  final Map<String, String>? metrics;
  final List<(IconData, String)>? featureHighlights;
  final String? videoPath;

  const ProjectModel({
    required this.title,
    required this.desc,
    required this.category,
    required this.github,
    required this.screenshots,
    required this.tags,
    this.appStore,
    this.playStore,
    this.impact,
    this.metrics,
    this.featureHighlights,
    this.videoPath,
  });
}

class Testimonial {
  final String quote, name, role, initials;
  final Color color;
  const Testimonial({
    required this.quote,
    required this.name,
    required this.role,
    required this.initials,
    required this.color,
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

  final ValueNotifier<double> _scrollNotifier = ValueNotifier(0.0);
  late AnimationController _floatingController;
  late AnimationController _iconController;
  late AnimationController _bgRotationController; // New for 3D BG
  late Timer _heroTimer;
  final PageController _heroController = PageController();
  late VideoPlayerController _profileVideoController;
  final List<PageController> _projectControllers = [];
  int _selectedCategory = 0;

  final List<String> categories = ['All', 'Mobile Apps', 'UI/UX', 'Freelance'];

  final List<ServiceItem> _services = [
    ServiceItem(
      icon: Icons.phone_android_rounded,
      number: '01',
      title: 'Mobile App Development',
      desc:
          'End-to-end Flutter apps for iOS & Android. From wireframe to App Store submission.',
      color: const Color(0xFF00BFFF),
      bullets: [
        'Cross-platform Flutter',
        'iOS & Android native feel',
        'App Store submission',
        'Play Store publishing'
      ],
    ),
    ServiceItem(
      icon: Icons.design_services_rounded,
      number: '02',
      title: 'UI/UX Design',
      desc:
          'Figma-first design with clean wireframes, interactive prototypes, and polished design systems.',
      color: const Color(0xFF007FFF),
      bullets: [
        'Wireframing & prototyping',
        'Design systems',
        'Pixel-perfect UI',
        'User flow optimization'
      ],
    ),
    ServiceItem(
      icon: Icons.api_rounded,
      number: '03',
      title: 'Backend Integration',
      desc:
          'Seamless connection to Firebase, REST APIs, payment gateways, and third-party services.',
      color: const Color(0xFF00B0FF),
      bullets: [
        'Firebase & Firestore',
        'REST API integration',
        'Payment gateways',
        'Google Maps SDK'
      ],
    ),
    ServiceItem(
      icon: Icons.build_rounded,
      number: '04',
      title: 'App Maintenance',
      desc:
          'Bug fixes, performance improvements, feature additions, and version updates for existing apps.',
      color: const Color(0xFF007BFF),
      bullets: [
        'Bug fixing & debugging',
        'Performance optimization',
        'Feature enhancements',
        'Code review & refactor'
      ],
    ),
  ];

  final List<Testimonial> _testimonials = [
    Testimonial(
      quote:
          '"Srinithi delivered our chit fund app exactly as we imagined — fast, reliable, and beautifully designed. Launched on App Store in 3 months."',
      name: 'Ramesh Kumar',
      role: 'Founder, ChitSoft',
      initials: 'RK',
      color: const Color(0xFF00BFFF),
    ),
    Testimonial(
      quote:
          '"The Namma Ooru Cab app exceeded our expectations. Real-time tracking works flawlessly and our drivers love the interface."',
      name: 'Senthil Kumar',
      role: 'CEO, Namma Ooru',
      initials: 'SK',
      color: const Color(0xFF00B0FF),
    ),
    Testimonial(
      quote:
          '"Building a healthcare app requires sensitivity and precision. Srinithi nailed both — our Yuvathi users trust and love the app."',
      name: 'Priya Meenakshi',
      role: 'Director, Yuvathi Health',
      initials: 'PM',
      color: const Color(0xFF007BFF),
    ),
  ];

  final List<ProjectModel> projects = [
    ProjectModel(
      title: 'Chit Fund Expert',
      desc:
          'Secure chit fund management with automated payment reconciliation and dashboards.\n\n• Automated SMS reminders & alerts\n• Scalable operator analytics dashboard\n• Digital receipt management system',
      category: 'Mobile Apps',
      github: 'https://github.com/Srinithie86/CHITSOFT.git',
      screenshots: [
        'assets/chitsoft_1.png',
        'assets/chitsoft_2.png',
        'assets/chitsoft_3.png',
        'assets/chitsoft_4.png',
        'assets/chitsoft_5.png',
      ],
      tags: ['Flutter', 'Firebase', 'Node.JS'],
      impact: "500+ Users | 20% Growth",
      metrics: {"Performance": "99.9% Uptime", "Business": "Productivity +15%"},
      featureHighlights: [
        (Icons.bolt, "Real-time updates"),
        (Icons.credit_card, "Payment integration"),
        (Icons.analytics, "Admin Dashboard"),
      ],
      playStore: 'https://play.google.com/store/apps/details?id=chitsoft.com.chitsoft_flutter&pcampaignid=web_share',
      appStore: 'https://apps.apple.com/in/app/chitsoft-chitfund-mangagement/id6757467879',
      videoPath: 'assets/chitsoft_1.png', 
    ),
    ProjectModel(
      title: 'Namma Ooru Cab',
      desc:
          'A ride-hailing and driver booking platform with precise real-time route navigation.\n\n• Real-time GPS tracking and navigation\n• Automated fare calculation system\n• Emergency SOS & safety alerts',
      screenshots: [
        'assets/namma_1.webp',
        'assets/namma_2.webp',
        'assets/namma_3.webp',
        'assets/namma_4.webp',
      ],
      github: 'https://github.com/Srinithie86/NOC.git',
      category: 'Mobile Apps',
      tags: ['Flutter', 'Google Maps', 'Booking System'],
      impact: "Live sync route tracking",
      playStore:
          'https://play.google.com/store/apps/details?id=com.nammaoorucab',
    ),
    ProjectModel(
      title: 'Swift Logistics',
      desc:
          'I build scalable Flutter apps with real-time features like logistics tracking.\n\n• Real-time driver and route tracking\n• Optimized route management dashboard\n• Instant shipment status and tracking',
      category: 'Freelance',
      github: '',
      screenshots: ['assets/freelance.gif'], 
      tags: ['Flutter', 'Maps SDK', 'REST API'],
      impact: "Reduced tracking delay by 40%",
      metrics: {"Accuracy": "98% tracking", "Speed": "Near instant sync"},
      featureHighlights: [
        (Icons.map, "Google Maps tracking"),
        (Icons.local_shipping, "Shipment tracking"),
        (Icons.notifications_active, "Near-live alerts"),
      ],
    ),
    ProjectModel(
      title: 'Yuvathi – HPV Screening',
      desc:
          'A women’s wellness platform focused on HPV screening with secure self-ordering kits.\n\n• Simplified checkout for ordering screening kits\n• Informative diagnostic portal for users\n• Secure user privacy & data compliance',
      screenshots: [
        'assets/yuvathi_1.webp',
        'assets/yuvathi_2.webp',
        'assets/yuvathi_3.webp',
        'assets/yuvathi_4.webp',
      ],
      github: 'https://github.com/Srinithie86/YUVATHI.git',
      category: 'Mobile Apps',
      tags: ['Flutter', 'Health Care', 'Self-Screening'],
      impact: "Trusted secure diagnostic portal",
      playStore:
          'https://play.google.com/store/apps/details?id=appyuvathi.health.com',
      appStore: 'https://apps.apple.com/in/app/yuvathi/id6759036981',
    ),
  ];

  bool _isChatBotOpen = false;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    _bgRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    )..repeat();

    _heroTimer = Timer.periodic(const Duration(seconds: 6), (_) { // Slower transition for hero
      if (_heroController.hasClients) {
        final next = ((_heroController.page?.round() ?? 0) + 1) % 3;
        _heroController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });

    // Initialize required PageControllers for projects
    for (int i = 0; i < projects.length; i++) {
      _projectControllers.add(PageController());
    }

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

    _profileVideoController =
        VideoPlayerController.asset('assets/critical_thinking.mp4')
          ..initialize().then((_) {
            _profileVideoController.setVolume(0);
            _profileVideoController.setLooping(true);
            _profileVideoController.play();
            setState(() {}); // World-class refresh
          }).catchError((e) {
            debugPrint("World-class Video Error: $e");
          });

    _scrollController.addListener(() {
      _scrollNotifier.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _iconController.dispose();
    _bgRotationController.dispose();
    _scrollNotifier.dispose();
    _heroTimer.cancel();
    _heroController.dispose();
    _profileVideoController.dispose();
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
          // World-class 3D background layer
          Positioned.fill(
            child: _threeDBackground(),
          ),
          
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 80), // Navbar spacer
                RevealOnScroll(key: _homeKey, child: _heroSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(child: _mobileShowcaseSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(key: _aboutKey, child: _aboutSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(key: _skillsKey, child: _skillsSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(key: _projectsKey, child: _projectsSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(child: _whyHireMeSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(child: _servicesSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(child: _freelanceSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(child: _testimonialsSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(child: _processSection(isWide)),
                const SizedBox(height: 100),
                RevealOnScroll(key: _contactKey, child: _contactSection(isWide)),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isChatBotOpen) ...[
            _chatOption(
              icon: FontAwesomeIcons.whatsapp,
              color: const Color(0xFF25D366),
              label: 'WhatsApp',
              onTap: () => _openUrl('https://wa.me/918610273937'),
            ),
            const SizedBox(height: 12),
            _chatOption(
              icon: FontAwesomeIcons.linkedinIn,
              color: const Color(0xFF0077B5),
              label: 'LinkedIn',
              onTap: () => _openUrl('https://linkedin.com/'),
            ),
            const SizedBox(height: 12),
            _chatOption(
              icon: Icons.email_rounded,
              color: const Color(0xFFEA4335),
              label: 'Email',
              onTap: () => _openUrl('mailto:srinithie86@gmail.com'),
            ),
            const SizedBox(height: 12),
          ],
          FloatingActionButton.extended(
            onPressed: () => setState(() => _isChatBotOpen = !_isChatBotOpen),
            backgroundColor: kLime,
            icon: Icon(
              _isChatBotOpen ? Icons.close : Icons.chat_bubble_rounded,
              color: Colors.white,
            ),
            label: Text(
              _isChatBotOpen ? 'Close' : 'Chat with Me',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
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
            color: Colors.white.withOpacity(0.01),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.05),
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
                        colors: [Color(0xFF00BFFF), Color(0xFF007FFF)],
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
      backgroundColor: const Color(0xFF020408), // Professional Black
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: const Color(0xFF00BFFF).withOpacity(0.2))),
        ),
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
      leading: Icon(icon, color: const Color(0xFF00BFFF)),
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      child: isWide
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _heroPortrait(true),
                const SizedBox(width: 80),
                Expanded(child: _heroText(isWide)),
              ],
            )
          : Column(
              children: [
                _heroPortrait(false),
                const SizedBox(height: 60),
                _heroText(isWide),
              ],
            ),
    );
  }

  Widget _heroPortrait(bool isWide) {
    double size = isWide ? 420 : 280;
    double radius = isWide ? 48 : 32;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFFF).withOpacity(0.3),
            blurRadius: isWide ? 100 : 60,
            spreadRadius: isWide ? 20 : 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox.expand(
          child: _profileVideoController.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _profileVideoController.value.size.width,
                    height: _profileVideoController.value.size.height,
                    child: VideoPlayer(_profileVideoController),
                  ),
                )
              : Image.asset(
                  'assets/profile.jpg',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _heroText(bool wide) {
    return Column(
      crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // 💫 High-End Intro Text
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "INTRODUCTION",
              style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 60, height: 1, color: kLime),
          ],
        ),
        const SizedBox(height: 20),
        // 🟢 Hire Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: kLime.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kLime.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: kLime, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                "AVAILABLE FOR HIRE",
                style: GoogleFonts.jetBrainsMono(
                  color: kLime,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text(
              'Hi, I’m Srinithi —',
              style: GoogleFonts.poppins(
                fontSize: wide ? 56 : 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            Text(
              'Flutter Developer in India',
              style: GoogleFonts.poppins(
                fontSize: wide ? 56 : 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            Text(
              'building scalable apps',
              style: GoogleFonts.poppins(
                fontSize: wide ? 56 : 38,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF00BFFF),
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          '2+ Years • 15+ Apps • 500+ Users',
          style: GoogleFonts.jetBrainsMono(
            color: kSky,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Helping businesses turn ideas into production-ready apps in weeks.',
          textAlign: wide ? TextAlign.start : TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _gradientButton(
              'View My Work',
              onTap: () => _scrollToSection(_projectsKey),
              large: true,
            ),
            _outlineButton(
              'Let\'s Talk',
              onTap: () => _scrollToSection(_contactKey),
            ),
            _outlineButton(
              'Download Resume (PDF)',
              onTap: () => _openUrl('assets/DOC-20250921-WA0000..pdf'),
            ),
          ],
        ),
        const SizedBox(height: 48),
        // 🎯 WOW Stats Row
        Row(
          mainAxisAlignment: wide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            _heroStat("15+", "Apps Built"),
            _vDivider(),
            _heroStat("500+", "Users Active"),
            _vDivider(),
            _heroStat("3+", "Years Exp"),
          ],
        ),
      ],
    );
  }

  Widget _mobileShowcaseSection(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      child: isWide
          ? Row(
              children: [
                Expanded(flex: 1, child: _showcaseText(true)),
                Expanded(flex: 1, child: _showcaseVisual(true)),
              ],
            )
          : Column(
              children: [
                _showcaseText(false),
                const SizedBox(height: 60),
                _showcaseVisual(false),
              ],
            ),
    );
  }

  Widget _showcaseText(bool wide) {
    return Column(
      crossAxisAlignment:
          wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          "I Don't Just Design,",
          style: _syne(wide ? 48 : 36, FontWeight.w800, Colors.white,
              spacing: -1.5, height: 1.1),
        ),
        Text(
          "I Create Experiences",
          style: _syne(wide ? 48 : 36, FontWeight.w800, kLime,
              spacing: -1.5, height: 1.1),
        ),
        const SizedBox(height: 24),
        Text(
          "Crafting high-performance mobile apps with intuitive designs that solve complex problems and deliver seamless user experiences.",
          textAlign: wide ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white60,
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: wide ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _storeButton(
              icon: FontAwesomeIcons.googlePlay,
              topText: "GET IT ON",
              mainText: "Google Play",
              onTap: () {},

              
            ),
            _storeButton(
              icon: FontAwesomeIcons.apple,
              topText: "Download on the",
              mainText: "App Store",
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _storeButton({
    required IconData icon,
    required String topText,
    required String mainText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF00BFFF), Color(0xFF007FFF)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BFFF).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  topText,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 10,
                  ),
                ),
                Text(
                  mainText,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showcaseVisual(bool wide) {
    return Center(
      child: SizedBox(
        width: wide ? 500 : 400,
        height: wide ? 500 : 400,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Glow
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B59B6).withOpacity(0.3),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),

            // Back Tilted Phone
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-0.1)
                ..rotateY(0.4)
                ..rotateZ(-0.2)
                ..translate(60.0, -40.0, 0.0),
              child: PhoneMockup(
                width: 180,
                height: 380,
                borderRadius: 24,
                controller: PageController(),
                screenshots: [projects[0].screenshots[1]], // ChitSoft list/dashboard view!
              ),
            ),

            // Front Tilted Phone
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-0.1)
                ..rotateY(0.4)
                ..rotateZ(-0.2)
                ..translate(-40.0, 40.0, 0.0),
              child: PhoneMockup(
                width: 180,
                height: 380,
                borderRadius: 24,
                controller: PageController(),
                screenshots: [projects[0].screenshots[2]], // Chitsoft detailed dashboard grid!
              ),
            ),

            // Floating Elements
            Positioned(
              left: 20,
              top: 100,
              child: _floatingIcon(Icons.person_rounded, Colors.white),
            ),
            Positioned(
              right: 40,
              bottom: 80,
              child: _floatingIcon(Icons.music_note_rounded, kLime),
            ),
            Positioned(
              left: 60,
              bottom: 40,
              child: _floatingIcon(Icons.notifications_rounded, Colors.amber),
            ),
            

          ],
        ),
      ),
    );
  }

  Widget _floatingIcon(IconData icon, Color color) {
    return ClipOval(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  static const Color kBg = Color(0xFF020408);
  static const Color kDim = Color(0x3300BFFF);
  static const Color kLime = Color(0xFF00BFFF); // Modified to Sky Blue to remove green
  static const Color kViolet = Color(0xFF007FFF);
  static const Color kSky = Color(0xFF00BFFF);
  static const Color kTxt = Color(0xFFE2E8F0);
  static const Color kMuted = Color(0xFFA0AEC0);

  TextStyle _syne(double size, FontWeight w, Color c,
          {double? height, double? spacing}) =>
      GoogleFonts.poppins(
          fontSize: size,
          fontWeight: w,
          color: c,
          height: height,
          letterSpacing: spacing);

  TextStyle _mono(double size, Color c) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: c);

  Widget _aboutSection(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 48 : 24),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: kDim))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('About Me'),
        const SizedBox(height: 16),
        _sectionTitle('Who I ', 'am'),
        const SizedBox(height: 32),
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset('assets/aboutme.gif',
                            fit: BoxFit.cover))),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _aboutMainCard()),
                const SizedBox(width: 12),
                Expanded(child: _skillsCard()),
              ])
            : Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child:
                        Image.asset('assets/aboutme.gif', fit: BoxFit.cover)),
                const SizedBox(height: 12),
                _aboutMainCard(),
                const SizedBox(height: 12),
                _skillsCard()
              ]),
        const SizedBox(height: 12),
        isWide
            ? Row(children: [
                Expanded(
                    child: _bentoStatCard('3+', 'years_of_experience', kLime)),
                const SizedBox(width: 12),
                Expanded(
                    child: _bentoStatCard('15+', 'apps_delivered', kViolet)),
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
            : Column(children: [
                _timelineCard(),
                const SizedBox(height: 12),
                _quoteCard()
              ]),
      ]),
    );
  }

  Widget _aboutMainCard() => Container(
        padding: const EdgeInsets.all(28),
        decoration: _cardDeco(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Freelance Flutter Developer in India.|",
              style: _syne(32, FontWeight.w800, Colors.white,
                  spacing: -0.5, height: 1.2)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
              children: [
                const TextSpan(text: "Currently, I'm a "),
                TextSpan(
                    text: "Professional Freelancer in Tamil Nadu,",
                    style:
                        TextStyle(color: kSky, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
              "A self-taught Mobile App developer, functioning in the industry for 2+ years now. "
              "I make meaningful and delightful digital products that create an equilibrium "
              "between user needs and business goals.",
              style: GoogleFonts.poppins(
                  color: Colors.white70, height: 1.8, fontSize: 16)),
          const SizedBox(height: 20),
          Wrap(spacing: 6, runSpacing: 6, children: [
            _pill('Flutter', highlight: true),
            _pill('Dart', highlight: true),
            _pill('Firebase', highlight: true),
            _pill('Figma'),
            _pill('REST APIs'),
            _pill('BLoC'),
            _pill('Riverpod'),
            _pill('PHP', highlight: true),
            _pill('Git'),
          ]),
        ]),
      );

  Widget _skillsCard() => Container(
        padding: const EdgeInsets.all(24),
        decoration: _cardDeco(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Proficiency',
              style: _mono(9, kMuted).copyWith(letterSpacing: 2)),
          const SizedBox(height: 16),
          _skillBar('Flutter', 0.92, kLime),
          _skillBar('Firebase', 0.85, kLime),
          _skillBar('PHP', 0.82, kLime),
          _skillBar('UI Design', 0.80, kLime),
          _skillBar('REST APIs', 0.88, kLime),
          _skillBar('Figma', 0.75, kLime),
        ]),
      );

  Widget _skillBar(String label, double pct, Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          SizedBox(width: 70, child: Text(label, style: _mono(10, kMuted))),
          Expanded(
              child: Container(
            height: 3,
            decoration: BoxDecoration(
                color: kDim, borderRadius: BorderRadius.circular(2)),
            child: FractionallySizedBox(
              widthFactor: pct,
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(2))),
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
          Text(n,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: color,
                  height: 1)),
        ]),
      );

  Widget _bentoHighlight() => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: kLime, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Status',
              style:
                  _mono(13, kBg.withOpacity(0.5)).copyWith(letterSpacing: 2)),
          const SizedBox(height: 8),
          Text('Open to freelance & full-time',
              style: _syne(15, FontWeight.w600, kBg, height: 1.2)),
          const SizedBox(height: 6),
          Text('Response within 24h',
              style: _syne(15, FontWeight.w300, kBg.withOpacity(0.55))),
        ]),
      );

  Widget _timelineCard() => Container(
        padding: const EdgeInsets.all(24),
        decoration: _cardDeco(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Timeline', style: _mono(13, kMuted).copyWith(letterSpacing: 2)),
          const SizedBox(height: 16),
          _tlItem('2026 — Present', 'Freelance Flutter Developer',
              'Building apps for startups across India', kLime),
          _tlItem('2026', 'Yuvathi HPV App',
              'Healthcare Flutter app — Google Play', kViolet),
          _tlItem('2025', 'ChitSoft & Namma Ooru Cab',
              'Two production apps shipped to stores', kSky,
              last: true),
        ]),
      );

  Widget _tlItem(String yr, String title, String sub, Color color,
          {bool last = false}) =>
      Padding(
        padding: EdgeInsets.only(bottom: last ? 0 : 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 5),
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            if (!last) Container(width: 1, height: 40, color: kDim),
          ]),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          Text('Philosophy',
              style: _mono(13, kMuted).copyWith(letterSpacing: 2)),
          const SizedBox(height: 16),
          Text(
            '"Great apps aren\'t just built —\nthey\'re designed, iterated,\nand loved into existence."',
            style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: kTxt,
                height: 1.5),
          ),
          const SizedBox(height: 14),
          Text('— Srinithi E, Flutter Developer', style: _mono(10, kMuted)),
        ]),
      );

  BoxDecoration _cardDeco() => BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(14),
      );

  Widget _sectionLabel(String text) => Row(children: [
        Text(text.toUpperCase(),
            style: _mono(13, kLime).copyWith(letterSpacing: 3)),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: kDim)),
      ]);

  Widget _sectionTitle(String normal, String accent) => Semantics(header: true, child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: normal,
              style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: kTxt,
                  letterSpacing: -1.5,
                  height: 1.1)),
          const TextSpan(text: ' '), // Standard inline space layout!
          TextSpan(
              text: accent,
              style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: kLime,
                  letterSpacing: -1.5,
                  height: 1.1)),
        ]),
      ));

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
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      child: Column(
        children: [
          _sectionLabel('Technological Stack'),
          const SizedBox(height: 16),
          _sectionTitle('Core Technical ', 'Proficiency'),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 800,
                    height: 800,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // The Background Orbits & Connecting Lines
                        Positioned.fill(
                          child: CustomPaint(
                            painter: SkillOrbitPainter(),
                          ),
                        ),
                        
                        // Top Skills Nodes (Row 1)
                        Positioned(top: 50, left: 100, child: _skillNodeIcon(FontAwesomeIcons.figma, Colors.pinkAccent)),
                        Positioned(top: 50, left: 220, child: _skillNodeIcon(FontAwesomeIcons.flutter, Colors.cyanAccent)),
                        Positioned(top: 50, left: 340, child: _skillNodeIcon(Icons.code, Colors.blue)),
                        Positioned(top: 50, left: 460, child: _skillNodeIcon(FontAwesomeIcons.database, Colors.cyanAccent)), // Firebase
                        Positioned(top: 50, left: 580, child: _skillNodeIcon(FontAwesomeIcons.php, Colors.amberAccent)),
                        Positioned(top: 50, left: 700, child: _skillNodeIcon(Icons.api_rounded, Colors.blueAccent)),
                        
                        // Top Skills Nodes (Row 2)
                        Positioned(top: 150, left: 180, child: _skillNodeIcon(FontAwesomeIcons.gitAlt, Colors.orangeAccent)),
                        Positioned(top: 150, left: 300, child: _skillNodeIcon(FontAwesomeIcons.github, Colors.white)),
                        Positioned(top: 150, left: 420, child: _skillNodeIcon(Icons.api_rounded, Colors.purpleAccent)),
                        Positioned(top: 150, left: 540, child: _skillNodeIcon(Icons.storage_rounded, Colors.orange)),
                        Positioned(top: 150, left: 660, child: _skillNodeIcon(Icons.php_rounded, Colors.indigoAccent)),

                        // Central Hub Logo (Large glowing circle)
                        Positioned(
                          top: 450,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9B59B6).withOpacity(0.5),
                                  blurRadius: 100,
                                  spreadRadius: 20,
                                ),
                              ],
                              gradient: const RadialGradient(
                                colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                              ),
                            ),
                              child: const Center(
                                child: Text(
                                  'FLUTTER',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ),
                        ),

                        // Orbital Nodes (around the hub)
                        ..._buildOrbitalSkillIcons(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _skillNodeIcon(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Center(child: Icon(icon, color: color, size: 28)),
    );
  }

  List<Widget> _buildOrbitalSkillIcons() {
    final List<(IconData, Color)> orbits = [
      (Icons.phone_android_rounded, Colors.white60),
      (Icons.computer_rounded, Colors.white60),
      (Icons.tablet_android_rounded, Colors.white60),
      (Icons.watch_rounded, Colors.white60),
    ];
    
    return List.generate(orbits.length, (i) {
      double angle = (i * 2 * math.pi / orbits.length) + (math.pi / 4);
      return Transform.translate(
        offset: Offset(math.cos(angle) * 200, 520 + math.sin(angle) * 100),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
          child: Icon(orbits[i].$1, color: orbits[i].$2, size: 14),
        ),
      );
    });
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
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00BFFF).withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BFFF).withOpacity(0.15),
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
                      colors: [Color(0xFF00BFFF), Color(0xFF7B2FF7)],
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
    // Elegant Light PhonePe Theme styled pastel tints with Dark Text Details
    final styles = [
      (
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFDF7F0)], // Pure Brightened Cream
        ),
        const Color(0xFF1E272E),
      ),
      (
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFEAF5FF)], // Pure Brightened Crystal Blue
        ),
        const Color(0xFF1E272E),
      ),
      (
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF3EAFF)], // Pure Brightened Lavender
        ),
        const Color(0xFF1E272E),
      ),
      (
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFFEAEA)], // Pure Brightened Rose
        ),
        const Color(0xFF1E272E),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isWide ? 60 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _sectionLabel('Solutions'),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _sectionTitle('Built for ', 'Scale'),
          ),
          const SizedBox(height: 60),
          // Massive Card Stacking sticky scroll deck
          StickyStackedCardList(
            projects: projects,
            styles: styles,
            controllers: _projectControllers,
            scrollNotifier: _scrollNotifier,
          ),
        ],
      ),
    );
  }








  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF00BFFF).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00BFFF).withOpacity(0.4),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: const Color(0xFF00BFFF),
          fontSize: 11,
          fontWeight: FontWeight.w500,
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
                    style: TextStyle(color: Color(0xFF00BFFF)),
                  ),
                ],
              ),
            ),
            Image.asset('assets/freelance.gif'),
          ],
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: isWide ? 80 : 32, vertical: 60),
          child: Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: const Color(0xFF00BFFF).withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.work_outline,
                  size: 64,
                  color: Color(0xFF00BFFF),
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
                    _serviceItem(
                        Icons.phone_android, 'Mobile Apps', 'iOS & Android'),
                    _serviceItem(Icons.design_services, 'UI/UX Design',
                        'Beautiful interfaces'),
                    _serviceItem(
                        Icons.api, 'API Integration', 'Backend connectivity'),
                    _serviceItem(
                        Icons.bug_report, 'Bug Fixes', 'Fast & reliable'),
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
      width: 160,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF00BFFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF00BFFF).withOpacity(0.2)),
            ),
            child: Icon(icon, color: const Color(0xFF00BFFF), size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white54,
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
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: kDim))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('What I Do'),
        const SizedBox(height: 16),
        _sectionTitle('My ', 'services'),
        const SizedBox(height: 32),
        Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _services
                .map((s) => SizedBox(
                    width: wide ? 260 : double.infinity,
                    child: HoverWidget(child: _serviceCard(s))))
                .toList()),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: kDim),
              borderRadius: BorderRadius.circular(14)),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: s.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(s.icon, color: s.color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(s.title, style: _syne(14, FontWeight.w600, kTxt, spacing: -0.2)),
          const SizedBox(height: 6),
          Text(s.desc,
              style: GoogleFonts.poppins(
                  color: Colors.white70, height: 1.8, fontSize: 16)),
          const SizedBox(height: 12),
          ...s.bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Text('→ ', style: _mono(9, kLime)),
                  Text(b, style: _mono(10, kMuted))
                ]),
              )),
        ]),
      );

  List<Widget> _processSteps(bool wide) {
    final steps = [
      (
        '01 — Discovery',
        'Understanding',
        'Deep-dive into your idea, goals, and target audience.'
      ),
      (
        '02 — Design',
        'Wireframing',
        'Figma wireframes and prototypes, iterated until perfect.'
      ),
      (
        '03 — Build',
        'Development',
        'Clean Flutter code with proper state management.'
      ),
      (
        '04 — Test',
        'QA & Polish',
        'Thorough testing across devices, fixing edge cases.'
      ),
      (
        '05 — Launch',
        'Deployment',
        'App Store & Play Store submission with live support.'
      ),
    ];
    return steps.asMap().entries.map((e) {
      final i = e.key;
      final s = e.value;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: i == 0 ? kLime.withOpacity(0.05) : Colors.transparent,
            border: wide
                ? Border(
                    right: i < steps.length - 1
                        ? BorderSide(color: kDim)
                        : BorderSide.none)
                : Border(
                    bottom: i < steps.length - 1
                        ? BorderSide(color: kDim)
                        : BorderSide.none),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: kDim))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionLabel('Social Proof'),
        const SizedBox(height: 16),
        _sectionTitle('What clients ', 'say'),
        const SizedBox(height: 32),
        Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _testimonials
                .map((t) => SizedBox(
                    width: wide ? 340 : double.infinity, child: _testiCard(t)))
                .toList()),
      ]),
    );
  }

  Widget _testiCard(Testimonial t) => Container(
        padding: const EdgeInsets.all(24),
        decoration: _cardDeco(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              children: List.generate(
                  5,
                  (_) =>
                      const Icon(Icons.star_rounded, color: kLime, size: 13))),
          const SizedBox(height: 14),
          Text(t.quote,
              style: _syne(13, FontWeight.w300, kTxt, height: 1.7)
                  .copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          Row(children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: t.color.withOpacity(0.15), shape: BoxShape.circle),
              child: Center(child: Text(t.initials, style: _mono(11, t.color))),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name, style: _syne(12, FontWeight.w600, kTxt)),
              Text(t.role, style: _mono(9, kMuted))
            ]),
          ]),
        ]),
      );

  Widget _contactSection(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      child: Column(
        children: [
          _sectionLabel('Contact'),
          const SizedBox(height: 16),
          _sectionTitle('Turn your idea into a ', 'Real Product'),
          const SizedBox(height: 24),
          Text(
            'Flutter Developer with 2+ years experience building scalable mobile apps. 15+ apps delivered. Available for immediate joining.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 48),
          _gradientButton('Say Hello on WhatsApp',
              icon: FontAwesomeIcons.whatsapp,
              onTap: () => _openUrl('https://wa.me/918610273937')),
        ],
      ),
    );
  }

  Widget _whyHireMeSection(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      child: Column(
        children: [
          _sectionLabel('Value Proposition'),
          const SizedBox(height: 16),
          _sectionTitle('Why ', 'Hire Me?'),
          const SizedBox(height: 48),
          isWide
              ? Row(
                  children: [
                    Expanded(child: _hireMeCard("Flutter App Development", "Scalable, maintainable Flutter code for long-term success.", Icons.architecture_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: _hireMeCard("Android & iOS Build", "Native-quality experience with cross-platform efficiency.", Icons.phone_android_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: _hireMeCard("Freelance Flutter Expert", "Direct experience with 500+ users and production environments.", Icons.rocket_launch_rounded)),
                  ],
                )
              : Column(
                  children: [
                    _hireMeCard("Flutter Development", "Scalable codebase patterns.", Icons.architecture_rounded),
                    const SizedBox(height: 12),
                    _hireMeCard("Android & iOS Build", "Native-quality cross-platform.", Icons.phone_android_rounded),
                    const SizedBox(height: 12),
                    _hireMeCard("Freelance Expert", "Results & metrics focused.", Icons.rocket_launch_rounded),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _hireMeCard(String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kLime, size: 32),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Text(desc, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }



  Widget _processSection(bool isWide) {
    final steps = [
      ("01", "UI/UX DESIGN", Icons.draw_rounded, "Designing intuitive user interfaces and wireframes with a focus on user experience."),
      ("02", "STRATEGY", Icons.lightbulb_outline_rounded, "Defining project requirements and technical architecture for robust applications."),
      ("03", "ANALYSIS", Icons.analytics_rounded, "Analyzing business needs and requirements to ensure all project goals are met."),
      ("04", "DEVELOPMENT", Icons.code_rounded, "Writing clean, scalable Flutter code using modern architectural patterns."),
      ("05", "TESTING", Icons.checklist_rtl_rounded, "Rigorous testing and bug fixes to ensure a smooth, crash-free user experience."),
      ("06", "DEPLOYMENT & SUPPORT", Icons.rocket_launch_rounded, "Deploying to App Store & Play Store with ongoing maintenance and support."),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      child: Column(
        children: [
          Text(
            "My Development Process",
            style: GoogleFonts.syne(
              fontSize: isWide ? 42 : 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "A structured lifecycle that translates wild ideas into highly usable apps.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 16),
          ),
          const SizedBox(height: 50),
          
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: steps.map((s) {
              return Container(
                width: isWide ? 330 : double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFFF).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(s.$3, color: const Color(0xFF00BFFF), size: 24),
                        ),
                        Text(
                          s.$1,
                          style: GoogleFonts.poppins(
                            color: Colors.white12,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      s.$2,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.$4,
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF00BFFF).withOpacity(0.1),
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
              _socialButton(Icons.code, 'https://github.com/Srinithie86'),
              _socialButton(Icons.business, 'https://linkedin.com/in/yourprofile'), // Replace with actual LinkedIn if known
              _socialButton(Icons.email, 'mailto:srinithie86@gmail.com'),
              _socialButton(Icons.phone_android, 'tel:+918610273937'),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 12,
            children: [
              _footerLink('Hire Flutter Developer', 'https://srinithiflutterapp.pages.dev/hire-flutter-developer.html'),
              _footerLink('Flutter Developer India', 'https://srinithiflutterapp.pages.dev/flutter-developer-india.html'),
              _footerLink('Mobile App Developer Tamil Nadu', 'https://srinithiflutterapp.pages.dev/mobile-app-developer-tamil-nadu.html'),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} Srinithi E. Crafted with Flutter Web',
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
              const Color(0xFF00BFFF).withOpacity(0.2),
              const Color(0xFF007FFF).withOpacity(0.2),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF00BFFF).withOpacity(0.3),
          ),
        ),
        child: Icon(icon, color: const Color(0xFF00BFFF), size: 22),
      ),
    );
  }

  Widget _footerLink(String title, String url) {
    return InkWell(
      onTap: () => _openUrl(url),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white54,
          fontSize: 13,
          fontWeight: FontWeight.w500,
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
            colors: [Color(0xFF00BFFF), Color(0xFF007FFF)],
          ),
          borderRadius: BorderRadius.circular(large ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BFFF).withOpacity(0.4),
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

  Widget _threeDBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_bgRotationController, _scrollNotifier]),
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    const Color(0xFF0A0F1E),
                    kBg,
                  ],
                ),
              ),
            ),
            CustomPaint(
              painter: ThreeDBackgroundPainter(
                rotation: _bgRotationController.value,
                scrollOffset: _scrollNotifier.value,
              ),
              size: Size.infinite,
            ),
          ],
        );
      },
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
            color: const Color(0xFF00BFFF),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFF00BFFF), size: 20),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                color: const Color(0xFF00BFFF),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
      ],
    );
  }

  Widget _vDivider() {
    return Container(
      height: 30,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white10,
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
          transform: Matrix4.translationValues(
              0, _isHovered ? -8.0 : 0.0, 0), // Adds movable slide depth!
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF14D4C4).withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 2,
                    )
                  ]
                : [],
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
  State<ModernSkillsExploratory> createState() =>
      _ModernSkillsExploratoryState();
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
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/figma/figma-original.svg",
              color: Colors.purpleAccent), // Figma
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original.svg",
              color: Colors.cyanAccent), // React
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/cplusplus/cplusplus-original.svg",
              color: Colors.blue), // C++
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/nodejs/nodejs-original.svg",
              color: Colors.cyanAccent), // Node.js
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/redux/redux-original.svg",
              color: Colors.deepPurpleAccent), // Redux
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/javascript/javascript-original.svg",
              color: Colors.yellow), // JavaScript
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/css3/css3-original.svg",
              color: Colors.blueAccent), // CSS3
        ];

        final row2 = [
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/xd/xd-plain.svg",
              color: Colors.pink), // Adobe XD
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/nextjs/nextjs-original.svg",
              color: Colors.white), // Next.js
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/gatsby/gatsby-original.svg",
              color: Colors.purpleAccent), // Gatsby
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/illustrator/illustrator-plain.svg",
              color: Colors.orangeAccent), // Illustrator
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/express/express-original.svg",
              color: Colors.white70), // Express
          SkillNode(
              imageUrl:
                  "https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original.svg",
              color: Colors.cyan), // MongoDB
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
                          color: const Color(0xFF00BFFF),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00BFFF).withOpacity(0.5),
                              blurRadius: 70,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'S',
                            style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(orbitItems.length, (i) {
                    final node = orbitItems[i];
                    final angleOffset = (math.pi * 2 / orbitItems.length) * i;
                    final angle =
                        _rotationController.value * math.pi * 2 + angleOffset;
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
                            border: Border.all(
                                color: node.color.withOpacity(0.6), width: 1.5),
                          ),
                          child: Center(
                            child: node.imageUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: node.imageUrl!.contains('.svg')
                                        ? SvgPicture.network(
                                            node.imageUrl!,
                                            placeholderBuilder: (_) =>
                                                const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 1.5)),
                                          )
                                        : Image.network(node.imageUrl!,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image,
                                                    size: 16)),
                                  )
                                : Icon(node.icon,
                                    color: Colors.white, size: 16),
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
                            border: Border.all(
                                color: node.color.withOpacity(0.7), width: 2),
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
                                            placeholderBuilder: (_) =>
                                                const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 2)),
                                          )
                                        : Image.network(node.imageUrl!,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image,
                                                    size: 20)),
                                  )
                                : Icon(node.icon,
                                    color: Colors.white, size: 24),
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
      ..color = const Color(0xFF00BFFF).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final target in targets) {
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.cubicTo(
        center.dx,
        center.dy - 80,
        target.dx,
        center.dy,
        target.dx,
        target.dy,
      );
      canvas.drawPath(path, linePaint);
    }

    final orbitPaint = Paint()
      ..color = const Color(0xFF00BFFF).withOpacity(0.15)
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
    final accentPaint = Paint()..color = const Color(0xFF00BFFF);
    final hairPaint = Paint()..color = const Color(0xFF00BFFF);

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
    final accentPaint = Paint()..color = const Color(0xFF00BFFF);

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
      accentPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
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
    final accentPaint = Paint()..color = const Color(0xFF00BFFF);

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
class SkillOrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.65);
    final paint = Paint()
      ..color = const Color(0xFF8E44AD).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Draw Orbits (Ellipses)
    for (int i = 1; i <= 3; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: 300.0 * i,
          height: 120.0 * i,
        ),
        paint,
      );
    }

    // 2. Draw Connecting Lines (Curves to nodes)
    final topNodesRow1 = [130.0, 250.0, 370.0, 490.0, 610.0, 730.0];
    final linePaint = Paint()
      ..shader = ui.Gradient.linear(
        center,
        const Offset(400, 50),
        [const Color(0xFF9B59B6).withOpacity(0.1), const Color(0xFF9B59B6).withOpacity(0.5)],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var x in topNodesRow1) {
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.quadraticBezierTo(
        center.dx,
        center.dy - 150,
        x,
        80,
      );
      canvas.drawPath(path, linePaint);
    }
    
    final topNodesRow2 = [210.0, 330.0, 450.0, 570.0, 690.0];
    for (var x in topNodesRow2) {
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.quadraticBezierTo(
        center.dx,
        center.dy - 100,
        x,
        180,
      );
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
      final offset = math.sin(animation.value * 1 * math.pi + i) *
          15; // ✅ stronger movement
      final opacity = 0.059 +
          (math.sin(animation.value * 0 * math.pi + i) * 0.0); // ✅ more visible

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

  void _drawCodeBrackets(
      Canvas canvas, Offset center, double size, Paint paint) {
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
      Rect.fromCenter(
          center: Offset(center.dx, center.dy - size * 0.2),
          width: size,
          height: size * 0.6),
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
class PhoneMockup extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final PageController? controller;
  final List<String> screenshots;
  final String? videoPath;

  const PhoneMockup({
    super.key,
    required this.width,
    required this.height,
    this.controller,
    required this.screenshots,
    this.borderRadius = 30,
    this.videoPath,
  });

  @override
  State<PhoneMockup> createState() => _PhoneMockupState();
}

class _PhoneMockupState extends State<PhoneMockup> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath != null && widget.videoPath!.toLowerCase().endsWith('.mp4')) {
      _videoController = VideoPlayerController.asset(widget.videoPath!)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.setLooping(true);
          _videoController!.setVolume(0);
          _videoController!.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Inner Screen Clip
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius - 4),
            child: widget.videoPath != null &&
                    _videoController != null &&
                    _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : PageView.builder(
                    controller: widget.controller,
                    itemCount: widget.screenshots.length,
                    itemBuilder: (context, index) {
                      final path = widget.screenshots[index];
                      final isNetwork = path.startsWith('http');
                      return isNetwork 
                          ? Image.network(
                              path.contains('play-lh')
                                  ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(path)}'
                                  : path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // 🌟 100% BULLETPROOF FALLBACK IF PROXY/CORS FAILS
                                return Image.asset('assets/chitsoft_1.png', fit: BoxFit.cover);
                              },
                            )
                          : Image.asset(
                              path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/chitsoft_1.png', fit: BoxFit.cover);
                              },
                            );
                    },
                  ),
          ),

          // 🌟 GLOSS GLASS REFLECTION DIAGONAL OVERLAY
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius - 4),
                  gradient: LinearGradient(
                    begin: const Alignment(-1, -1),
                    end: const Alignment(1, 1),
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.transparent,
                      Colors.white.withOpacity(0.02),
                    ],
                    stops: const [0.0, 0.4, 0.5],
                  ),
                ),
              ),
            ),
          ),

          // 🌟 SPEED STATUS BAR row (Wifi, Battery, Clock)
          Positioned(
            top: 6,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "9:41",
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi, color: Colors.white.withOpacity(0.8), size: 10),
                    const SizedBox(width: 4),
                    Icon(Icons.battery_full_rounded, color: Colors.white.withOpacity(0.8), size: 10),
                  ],
                ),
              ],
            ),
          ),

          // Top Dynamic Capsule notch detail
          Positioned(
            top: 4,
            left: widget.width / 2 - 25,
            child: Container(
              width: 50,
              height: 12, 
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5),
              ),
            ),
          ),

          // Outer Premium Metal Rim Outline
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// PREMIUM WRAPPERS
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final double offset;
  const RevealOnScroll({super.key, required this.child, this.offset = 50});

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final curve = Curves.easeOutCubic.transform(_controller.value);
          return Opacity(
            opacity: curve,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..translate(0.0, 50 * (1 - curve), 0.0)
                ..rotateX(-0.15 * (1 - curve)),
              alignment: Alignment.center,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MouseTilt extends StatefulWidget {
  final Widget child;
  const MouseTilt({super.key, required this.child});

  @override
  State<MouseTilt> createState() => _MouseTiltState();
}

class _MouseTiltState extends State<MouseTilt> {
  double x = 0, y = 0;
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          x = (event.localPosition.dy / 300) - 0.5;
          y = (event.localPosition.dx / 300) - 0.5;
          _mousePos = event.localPosition;
        });
      },
      onExit: (_) => setState(() => {x = 0, y = 0}),
      child: AnimatedRotation(
        turns: 0,
        duration: const Duration(milliseconds: 200),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(x * 0.3)
            ..rotateY(-y * 0.3),
          alignment: Alignment.center,
          child: Stack(
            children: [
              widget.child,
              // Dynamic Glare Effect
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: RadialGradient(
                      center: Alignment(
                        (_mousePos.dx / 150) - 1,
                        (_mousePos.dy / 300) - 1,
                      ),
                      radius: 0.8,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.transparent,
                      ],
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

class ThreeDBackgroundPainter extends CustomPainter {
  final double rotation;
  final double scrollOffset;

  ThreeDBackgroundPainter({required this.rotation, required this.scrollOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00BFFF).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 15; i++) { // Optimization: Reduced particle count from 30 to 15
      final depth = random.nextDouble();
      final xBase = random.nextDouble() * size.width;
      final yBase = (random.nextDouble() * size.height * 3) - scrollOffset * (0.1 + depth * 0.4);
      
      final orbitX = math.sin(rotation * 2 * math.pi + i) * 50 * depth;
      final orbitY = math.cos(rotation * 2 * math.pi + i) * 50 * depth;

      final radius = 2.0 + depth * 4.0;
      final opacity = 0.1 + depth * 0.3;
      
      canvas.drawCircle(
        Offset(xBase + orbitX, yBase + orbitY),
        radius,
        paint..color = const Color(0xFF00BFFF).withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(ThreeDBackgroundPainter oldDelegate) => true;
}

// -----------------------------------------------------------------------------
// --- Interactive Sticky Card Stacking list supporting classes Layout ----
// -----------------------------------------------------------------------------
class StickyStackedCardList extends StatelessWidget {
  final List<ProjectModel> projects;
  final List<(LinearGradient, Color)> styles;
  final List<PageController> controllers;
  final ValueNotifier<double> scrollNotifier;

  const StickyStackedCardList({
    super.key,
    required this.projects,
    required this.styles,
    required this.controllers,
    required this.scrollNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final double cardHeight = isWide ? 620.0 : 540.0;
    final double offsetBetween = isWide ? 540.0 : 480.0; 
    final double totalHeight = projects.length * offsetBetween + cardHeight;

    if (!isWide) {
      return Column(
        children: List.generate(projects.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: StackCardItem(
              totalItems: projects.length,
              index: index,
              p: projects[index],
              ctrl: controllers[index],
              gradient: styles[index % styles.length].$1,
              textColor: styles[index % styles.length].$2,
              isActive: true,
            ),
          );
        }),
      );
    }

    return ValueListenableBuilder<double>(
      valueListenable: scrollNotifier,
      builder: (context, scrollVal, child) {
        final renderedBox = context.findRenderObject() as RenderBox?;
        final distanceToTop = renderedBox?.localToGlobal(Offset.zero).dy ?? 0.0;

        return Container(
          height: totalHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.01),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom Ambience
               Positioned(
                 bottom: 0, left: 0, right: 0, height: 120,
                 child: _OrbitAnimationView(),
               ),

              ...List.generate(projects.length, (index) {
                final double itemStartOffset = index * offsetBetween;
                final double currentYInScroll = distanceToTop + itemStartOffset;

                double translate = 0.0;
                double scale = 1.0;
                double opacity = 1.0;

                const double thresholdPaddingTop = 100.0; 

                if (currentYInScroll < thresholdPaddingTop) {
                  final double activeScrollPast = thresholdPaddingTop - currentYInScroll;

                  translate = activeScrollPast; 
                  scale = 1.0; 
                  opacity = 1.0; 
                  
                  // Clamp translate relative boundary constraints safely
                  final double maxTranslate = totalHeight - cardHeight - itemStartOffset;
                  if (translate > maxTranslate) {
                    translate = maxTranslate;
                  }
                }

                return Positioned(
                  left: 0,
                  right: 0,
                  top: itemStartOffset + translate,
                  height: cardHeight,
                  child: Transform.scale(
                     scale: scale,
                     alignment: Alignment.topCenter,
                     child: StackCardItem(
                        totalItems: projects.length,
                        index: index,
                        p: projects[index],
                        ctrl: controllers[index],
                        gradient: styles[index % styles.length].$1,
                        textColor: styles[index % styles.length].$2,
                        isActive: true,
                     ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class StackCardItem extends StatelessWidget {
  final int index;
  final int totalItems;
  final ProjectModel p;
  final PageController ctrl;
  final Gradient gradient;
  final Color textColor;
  final bool isActive;

  const StackCardItem({
    super.key,
    required this.index,
    required this.totalItems,
    required this.p,
    required this.ctrl,
    required this.gradient,
    required this.textColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60), // Giant curved corners based on screenshots
        gradient: gradient,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: isWide ? 60 : 24, vertical: 40),
      child: isWide
          ? Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _cardTextContent(isWide),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 3,
                  child: _cardVisualMockup(isWide),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: _cardVisualMockup(isWide)),
                const SizedBox(height: 24),
                _cardTextContent(isWide),
              ],
            ),
    );
  }

  Widget _projectActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00BFFF).withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF00BFFF).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF00BFFF), size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: const Color(0xFF1B1B1B),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardTextContent(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF00BFFF).withOpacity(0.12),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                (index + 1).toString().padLeft(2, '0'),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00BFFF),
                ),
              ),
            ),
            if (p.impact != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFF9500).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, color: Color(0xFFFF9500), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      p.impact!,
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF1B1B1B),
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          p.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.syne(
              fontSize: isWide ? 42 : 28,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1B1B1B),
              height: 1.12),
        ),
        const SizedBox(height: 16),
        Text(
          p.desc,
          maxLines: isWide ? 4 : null,
          overflow: isWide ? TextOverflow.ellipsis : TextOverflow.visible,
          style: GoogleFonts.poppins(
              color: Colors.black54, fontSize: 14, height: 1.55),
        ),
        const SizedBox(height: 24),
        // 🛠️ Tech Stack Badges
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: p.tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFFF).withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF00BFFF).withOpacity(0.2)),
            ),
            child: Text(
              tag,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B1B1B),
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (p.github.isNotEmpty)
              _projectActionButton(
                FontAwesomeIcons.github,
                "Code",
                () => launchUrl(Uri.parse(p.github), mode: LaunchMode.externalApplication),
              ),
            if (p.playStore != null && p.playStore!.isNotEmpty)
              _projectActionButton(
                FontAwesomeIcons.googlePlay,
                "Play Store",
                () => launchUrl(Uri.parse(p.playStore!), mode: LaunchMode.externalApplication),
              ),
            if (p.appStore != null && p.appStore!.isNotEmpty)
              _projectActionButton(
                Icons.apple,
                "App Store",
                () => launchUrl(Uri.parse(p.appStore!), mode: LaunchMode.externalApplication),
              ),
          ],
        ),
      ],
    );
  }

  Widget _cardVisualMockup(bool isWide) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // illustrative soft backgrounds glowing behind Mockup
        Container(
          width: isWide ? 220 : 160,
          height: isWide ? 220 : 160,
          decoration: BoxDecoration(
            color: const Color(0xFF00BFFF).withOpacity(0.06),
            shape: BoxShape.circle,
          ),
        ),
        PhoneMockup(
          width: isWide ? 200 : 180,
          height: isWide ? 400 : 360,
          controller: ctrl,
          screenshots: p.screenshots,
          videoPath: p.videoPath,
          borderRadius: 20,
        ),
      ],
    );
  }
}


class _OrbitAnimationView extends StatefulWidget {
  @override
  State<_OrbitAnimationView> createState() => _OrbitAnimationViewState();
}

class _OrbitAnimationViewState extends State<_OrbitAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 30)) // Much slower orbit
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: OrbitPainter(_controller.value),
      ),
    );
  }
}

class OrbitPainter extends CustomPainter {
  final double progress;
  OrbitPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00BFFF).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final dotPaint = Paint()..color = Colors.redAccent..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height * 1.5; 
    final radiusX = size.width * 0.7;
    final radiusY = size.height * 0.8;

    final rect = Rect.fromCenter(
        center: Offset(centerX, centerY), width: radiusX * 2, height: radiusY * 2);
    canvas.drawArc(rect, -math.pi, math.pi, false, paint);

    final angle = -math.pi + progress * math.pi;
    final x = centerX + radiusX * math.cos(angle);
    final y = centerY + radiusY * math.sin(angle);

    canvas.drawCircle(Offset(x, y), 6, dotPaint);
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) => true;
}



