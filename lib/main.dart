// lib/main.dart
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SrinithiPortfolioApp());
}

class SrinithiPortfolioApp extends StatefulWidget {
  const SrinithiPortfolioApp({super.key});

  @override
  State<SrinithiPortfolioApp> createState() => _SrinithiPortfolioAppState();
}

class _SrinithiPortfolioAppState extends State<SrinithiPortfolioApp> {
  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFFD6F00);

    return MaterialApp(
      title: 'Srinithi E | Mobile Application Engineer',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primaryColor: primaryOrange,
        textTheme:
            GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme),
        colorScheme: const ColorScheme.light(
          primary: primaryOrange,
          surface: Colors.white,
          onSurface: Color(0xFF111827),
        ),
      ),
      home: PortfolioHomePage(
        isDarkMode: false,
        onToggleTheme: () {},
      ),
    );
  }
}

// ==========================================
// REUSABLE ANIMATION HELPERS
// ==========================================

/// Fades + slides its child up into view the first time it scrolls
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration delay;
  final double triggerFraction;
  final Offset beginOffset;

  const RevealOnScroll({
    super.key,
    required this.child,
    required this.scrollController,
    this.delay = Duration.zero,
    this.triggerFraction = 0.88,
    this.beginOffset = const Offset(0, 0.06),
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    widget.scrollController.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      if (position.dy < screenHeight * widget.triggerFraction) {
        _hasAnimated = true;
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Subtle scale-up on hover (desktop/web) for buttons & cards.
class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const HoverScale({super.key, required this.child, this.scale = 1.04});

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _hovering ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const PortfolioHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Keys for Section Scrolling & Scroll-Spy
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _whyMeKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _blogsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Scroll-Spy Active Index
  int _activeNavIndex = 0;

  // Active Portfolio Filter
  int _selectedFilterIndex = 0;
  final List<String> _portfolioFilters = [
    'All',
    'Mobile Apps',
    'Financial Services',
    'Enterprise ERP',
    'Firebase & Cloud',
    'UI/UX Systems',
  ];

  // Projects Data with Real Links & Action URLs
  final List<Map<String, dynamic>> _portfolioProjects = [
    {
      'title': 'TrueBroker - Real Estate Hub & Video Shorts Social Feed',
      'subtitle':
          'Buy, Sell, Rent, Lease, Real-time Chat & TBShorts Reels Platform',
      'category': 'Mobile Apps',
      'description':
          'Full-scale Real Estate listing mobile application & web platform built with Flutter. Empowers buyers, sellers, landlords, and tenants with Buy, Sell, Rent, and Lease property workflows, real-time 1-on-1 chat messaging module, Instagram-style property video shorts feed ("TBShorts") with Like, Comment, and Share features, Google Maps location discovery, Meta WhatsApp owner connect, and live Firebase backend.',
      'image': 'assets/truebroker_3.png',
      'screens': [
        'assets/truebroker_3.png',
        'assets/truebroker_1.png',
        'assets/truebroker_2.png'
      ],
      'fallbackColor': const Color(0xFF5E2D89),
      'tags': [
        'Flutter',
        'Real-Time Chat Module',
        'TBShorts Video Reels',
        'Instagram Feed (Like/Comment/Share)',
        'Buy / Sell / Rent / Lease',
        'Google Maps API',
        'Meta WhatsApp API',
        'Firebase',
        'Play Store'
      ],
      'github': 'https://github.com/Srinithie86/TRUEBROKER',
      'playstore':
          'https://play.google.com/store/apps/details?id=com.truebroker.app&pcampaignid=web_share',
      'appstore':
          'https://play.google.com/store/apps/details?id=com.truebroker.app&pcampaignid=web_share',
      'link':
          'https://play.google.com/store/apps/details?id=com.truebroker.app&pcampaignid=web_share',
      'architecture': [
        'Built real-time 1-on-1 buyer-seller chat messaging module using Cloud Firestore stream listeners & instant push alerts.',
        'Engineered "TBShorts" Instagram-style property video reels feed with vertical video playback, Likes, Comments, and Sharing.',
        'Implemented complete Buy, Sell, Rent, and Lease property listing workflows with multi-parameter filter search.',
        'Interactive Google Maps SDK integration for precise property geolocation pinning and neighborhood search.',
        'Meta WhatsApp API integration for instant direct inquiries between buyers, sellers, tenants, and landlords.',
        'Live production deployment on Google Play Store with active user base.'
      ],
    },
    {
      'title': 'Smart FinServ - 4-in-1 Financial & Loan Platform',
      'subtitle':
          'Loan, Verification Agent, Collection Agent & Investor 4 Modules in One App',
      'category': 'Financial Services',
      'description':
          'Production-grade 4-in-1 financial services mobile application constructed with Flutter & Dart. Consolidates 4 specialized domain modules into a single unified platform: Loan Applicant, Verification Agent, Collection Agent, and Investor. Features complete Loan Application flow, digital KYC document verification, integrated Payment & Wallet gateway flow, and a multi-tier Refer & Earn reward engine.',
      'image': 'assets/smart_finserv_1.jpg',
      'screens': ['assets/smart_finserv_1.jpg', 'assets/smart_finserv_2.jpg'],
      'fallbackColor': const Color(0xFF025389),
      'tags': [
        'Flutter',
        'Financial Services',
        '4-in-1 App Modules',
        'Loan Application Flow',
        'KYC Verification',
        'Payment & Wallet Engine',
        'Refer & Earn Payouts',
        'Play Store'
      ],
      'github': 'https://github.com/Srinithie86/Smartfinserv.git',
      'playstore':
          'https://play.google.com/store/apps/details?id=com.sgs.smart_finserve&pcampaignid=web_share',
      'appstore':
          'https://play.google.com/store/apps/details?id=com.sgs.smart_finserve&pcampaignid=web_share',
      'link':
          'https://play.google.com/store/apps/details?id=com.sgs.smart_finserve&pcampaignid=web_share',
      'architecture': [
        'Engineered 4 distinct role-based modules in a single Flutter codebase: Loan Applicant, Verification Agent, Collection Agent, and Investor.',
        'Implemented full Loan Application wizard with multi-step credit risk evaluation and instant EMI calculation.',
        'Built automated KYC Document Verification flow with Aadhaar / PAN OCR upload and location geotagging.',
        'Integrated Payment Gateway & Wallet Settlement engine for real-time EMI collections and digital receipt generation.',
        'Designed multi-tier Refer & Earn flow with automated reward tracking and wallet cashbacks.',
        'Live production deployment on Google Play Store with active financial operations.'
      ],
    },
    {
      'title': 'Total ERP - All-in-One Enterprise Platform',
      'subtitle':
          'HRM, CRM, Sales, Purchase, Accounting, Manufacturing & Services Suite',
      'category': 'Enterprise ERP',
      'description':
          'Comprehensive enterprise resource planning (ERP) platform constructed with Flutter & Dart. Unifies Human Resource Management (HRM), Customer Relationship Management (CRM), Sales & Invoicing, Purchase Orders, Financial Accounting, Manufacturing Operations, and Service Management into a single real-time multi-tenant dashboard.',
      'image': 'assets/total_erp_1.png',
      'screens': [
        'assets/total_erp_1.png',
        'assets/total_erp_2.png',
        'assets/total_erp_3.png',
        'assets/total_erp_4.jpg',
      ],
      'fallbackColor': const Color(0xFFFFF3E0),
      'tags': [
        'Flutter',
        'Enterprise ERP',
        'HRM & CRM',
        'Sales & Purchase',
        'Accounting',
        'Manufacturing',
        'Service Management'
      ],
      'github': 'https://github.com/Srinithie86/total-erp.git',
      'playstore': 'https://github.com/Srinithie86/total-erp.git',
      'appstore': 'https://github.com/Srinithie86/total-erp.git',
      'link': 'https://github.com/Srinithie86/total-erp.git',
      'architecture': [
        'Unified enterprise dashboard consolidating HRM (payroll, attendance) and CRM (lead pipelines, deal tracking).',
        'Sales and Purchase order execution engine linked directly to double-entry financial accounting ledgers.',
        'Manufacturing workflow tracking, Bill of Materials (BOM) management, and inventory stock level sync.',
        'Field Service ticketing system with client portal integration and real-time status updates.'
      ],
    },
    {
      'title': 'ChitSoft - Financial & Chit Fund App',
      'subtitle':
          'Financial Services Domain, Chit Fund Ledger & Payout Platform',
      'category': 'Financial Services',
      'description':
          'Production-grade Financial Services mobile app featuring CIBIL credit score check API integration, automated Chit Fund auction & payout ledgers, Stripe & Razorpay payment gateway sync, Meta WhatsApp Business API for instant transaction alerts, IVR voice verification, Firebase (Auth, Firestore, Cloud Functions), and BLoC architecture.',
      'image': 'assets/project1.jpg',
      'screens': [
        'assets/project1.jpg',
        'assets/project2.jpg',
        'assets/smart_finserv_1.jpg'
      ],
      'fallbackColor': const Color(0xFF047857),
      'tags': [
        'Flutter',
        'ChitSoft App',
        'Financial Services',
        'CIBIL API',
        'Payment Gateways',
        'Meta WhatsApp API',
        'IVR Integration',
        'Firebase',
        'BLoC Pattern'
      ],
      'github': 'https://github.com/srinithie86/chitsoft_app',
      'playstore':
          'https://play.google.com/store/apps/details?id=com.chitsoft.app',
      'appstore':
          'https://apps.apple.com/in/app/chitsoft-chitfund-mangagement/id6757467879',
      'link':
          'https://apps.apple.com/in/app/chitsoft-chitfund-mangagement/id6757467879',
      'architecture': [
        'Integrated CIBIL score calculation API for instant creditworthiness evaluation.',
        'Stripe & Razorpay payment gateway sync with real-time webhook updates.',
        'Automated payout ledger calculation engine with multi-party encryption.',
        'Meta WhatsApp API triggered on every deposit, bid, and loan clearance.',
        'Architecture built using Flutter BLoC state management and Clean Code.'
      ],
    },
    {
      'title': 'NOC (Namma Ooru Driver & Cab Logistics)',
      'subtitle': 'Google Maps SDK, Logistics & Ride Booking Mobile App',
      'category': 'Mobile Apps',
      'description':
          'Cross-platform mobile application featuring live Google Maps SDK navigation, route optimization, IVR voice call integration (Twilio/Exotel) for instant driver-rider connects, Shipment & parcel tracking APIs, payment gateway processing, and Google Play & App Store publishing.',
      'image': 'assets/namma_2.webp',
      'screens': [
        'assets/namma_2.webp',
        'assets/namma_1.webp',
        'assets/namma_3.webp',
        'assets/namma_4.webp'
      ],
      'fallbackColor': const Color(0xFF0F4C81),
      'tags': [
        'Flutter',
        'NOC App',
        'Google Maps SDK',
        'Logistics APIs',
        'IVR Call API',
        'Payment Gateways',
        'Play Store',
        'App Store'
      ],
      'github': 'https://github.com/srinithie86/namma_ooru_driver',
      'playstore':
          'https://play.google.com/store/apps/details?id=com.nammaooru.driver',
      'appstore': 'https://apps.apple.com/app/namma-ooru-cab/id543216789',
      'link': 'https://github.com/srinithie86',
      'architecture': [
        'Live Google Maps SDK location tracking & dynamic polyline route rendering.',
        'Integrated IVR telephony call system to connect riders without revealing numbers.',
        'Real-time FCM push notification alerts for ride requests & fare updates.',
        'Published on both Google Play Store and Apple App Store.'
      ],
    },
    {
      'title': 'Lirante - Food & Delivery Solution',
      'subtitle': 'Real-Time Maps, WhatsApp API & Delivery Sync',
      'category': 'Mobile Apps',
      'description':
          'High-performance cross-platform Flutter application with live Google Maps location tracking, Shipment & parcel delivery APIs (Shiprocket/Delhivery), Meta WhatsApp API order notifications, Firebase Cloud Messaging (FCM), and Provider state management.',
      'image': 'assets/namma_1.webp',
      'screens': [
        'assets/namma_1.webp',
        'assets/namma_3.webp',
        'assets/namma_4.webp'
      ],
      'fallbackColor': const Color(0xFFFFF0E6),
      'tags': [
        'Flutter',
        'Google Maps API',
        'Meta WhatsApp API',
        'Shipment Tracking',
        'Firebase FCM',
        'RESTful APIs'
      ],
      'github': 'https://github.com/srinithie86/lirante_food_delivery',
      'playstore':
          'https://play.google.com/store/apps/details?id=com.lirante.food',
      'appstore': 'https://apps.apple.com/app/id123456789',
      'link': 'https://github.com/srinithie86',
      'architecture': [
        'Shipment API sync with Shiprocket & Delhivery for live courier updates.',
        'Instant Meta WhatsApp order receipt generation upon successful checkout.',
        'Custom 60FPS UI cart animation with Provider state management.'
      ],
    },
    {
      'title': 'Yuvathi Health & Telephony Platform',
      'subtitle': 'Healthcare, IVR Voice & Cloud Vault Mobile App',
      'category': 'Firebase & Cloud',
      'description':
          'Empowering healthcare app with IVR call appointment voice reminders, Meta WhatsApp prescription notifications, Firebase Auth, Cloud Firestore document vault, Cloud Functions backend logic, and RESTful API integrations.',
      'image': 'assets/yuvathi_1.webp',
      'screens': [
        'assets/yuvathi_1.webp',
        'assets/yuvathi_2.webp',
        'assets/yuvathi_3.webp',
        'assets/yuvathi_4.webp'
      ],
      'fallbackColor': const Color(0xFF6B21A8),
      'tags': [
        'Flutter',
        'Yuvathi Health',
        'IVR Call API',
        'Meta WhatsApp API',
        'Firebase Auth',
        'Firestore',
        'RESTful APIs'
      ],
      'github': 'https://github.com/srinithie86/yuvathi_health',
      'playstore':
          'https://play.google.com/store/apps/details?id=com.yuvathi.healthcare',
      'appstore': 'https://apps.apple.com/app/yuvathi-health/id987654321',
      'link': 'https://github.com/srinithie86',
      'architecture': [
        'Encrypted patient health records stored in Cloud Firestore & Storage.',
        'Automated IVR phone call reminders scheduled via Cloud Functions.',
        'WhatsApp PDF prescription dispatcher.'
      ],
    },
  ];

  // Marquee Ticker Controller
  late AnimationController _marqueeController;

  // Hero entrance animation
  late final AnimationController _heroController;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _heroScale;

  @override
  void initState() {
    super.initState();
    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _heroController, curve: Curves.easeOutCubic));
    _heroScale = Tween<double>(begin: 0.94, end: 1.0).animate(
        CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic));

    _scrollController.addListener(_onScrollUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _heroController.forward();
    });
  }

  void _onScrollUpdate() {
    if (!mounted) return;
    final keys = [
      _homeKey,
      _servicesKey,
      _experienceKey,
      _whyMeKey,
      _portfolioKey,
      _testimonialsKey,
      _blogsKey,
      _contactKey,
    ];

    double screenHeight = MediaQuery.of(context).size.height;
    int currentActive = 0;

    for (int i = 0; i < keys.length; i++) {
      final keyContext = keys[i].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= screenHeight * 0.45) {
            currentActive = i;
          }
        }
      }
    }

    if (currentActive != _activeNavIndex) {
      setState(() {
        _activeNavIndex = currentActive;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollUpdate);
    _marqueeController.dispose();
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // ==========================================
  // MODALS & DIALOGS
  // ==========================================

  void _showProjectDetailsModal(
      BuildContext context, Map<String, dynamic> proj) {
    final isDark = widget.isDarkMode;
    final archList =
        (proj['architecture'] as List<dynamic>?)?.cast<String>() ?? [];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF151C2C) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 820, maxHeight: 720),
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD6F00).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        proj['category'] as String,
                        style: const TextStyle(
                          color: Color(0xFFFD6F00),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF6B7280),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  proj['title'] as String,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  proj['subtitle'] as String,
                  style: const TextStyle(
                    color: Color(0xFFFD6F00),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proj['description'] as String,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF374151),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (archList.isNotEmpty) ...[
                          Text(
                            'Key Technical Architecture & Integration Highlights:',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...archList.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFFFD6F00),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF4B5563),
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          'Tech Stack & Integrations:',
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : const Color(0xFF111827),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (proj['tags'] as List<String>).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFFE2E8F0)
                                      : const Color(0xFF334155),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _buildProjectActionButtons(
                  github: proj['github'] as String?,
                  playstore: proj['playstore'] as String?,
                  appstore: proj['appstore'] as String?,
                  webLink: proj['link'] as String?,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactModal(BuildContext context) {
    final isDark = widget.isDarkMode;
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();
    String selectedDomain = 'Mobile App Development';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: isDark ? const Color(0xFF151C2C) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 580),
                padding: const EdgeInsets.all(28),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Let's Work Together! 🚀",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF6B7280),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Send a message directly to discuss project requirements, freelance gigs, or full-time opportunities.',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF6B7280),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Copy Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickCopyChip(
                              label: 'srinithie86@gmail.com',
                              icon: Icons.email_rounded,
                              isDark: isDark,
                              onTap: () {
                                Clipboard.setData(const ClipboardData(
                                    text: 'srinithie86@gmail.com'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Email copied to clipboard! 📋'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Color(0xFFFD6F00),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildQuickCopyChip(
                              label: '+91 86102 73937',
                              icon: Icons.phone_rounded,
                              isDark: isDark,
                              onTap: () {
                                Clipboard.setData(
                                    const ClipboardData(text: '+918610273937'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Phone number copied to clipboard! 📋'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Color(0xFFFD6F00),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 20),

                      // Name Field
                      Text(
                        'Your Name',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameController,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14),
                        decoration: _inputDecoration('e.g. Srinithi', isDark),
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      Text(
                        'Your Email',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: emailController,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14),
                        decoration:
                            _inputDecoration('e.g. sri@example.com', isDark),
                      ),
                      const SizedBox(height: 14),

                      // Project Type Dropdown
                      Text(
                        'Project / Inquiry Domain',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedDomain,
                        dropdownColor:
                            isDark ? const Color(0xFF1E293B) : Colors.white,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 13.5),
                        decoration: _inputDecoration('', isDark),
                        items: [
                          'Mobile App Development',
                          'Fintech & Payment Integration',
                          'Firebase & Cloud Architecture',
                          'UI/UX Design & Consulting',
                          'Full-Time Role Hiring',
                        ]
                            .map((d) =>
                                DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedDomain = val);
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // Message Field
                      Text(
                        'Project Overview / Message',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: messageController,
                        maxLines: 4,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14),
                        decoration: _inputDecoration(
                            'Tell me about your app goals, timeline, or requirements...',
                            isDark),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameController.text.trim();
                            final email = emailController.text.trim();
                            final message = messageController.text.trim();

                            final whatsappText = "Hello Srinithi! 👋\n\n"
                                "*New Project Inquiry*\n"
                                "👤 *Name:* ${name.isEmpty ? 'Not specified' : name}\n"
                                "📧 *Email:* ${email.isEmpty ? 'Not specified' : email}\n"
                                "📌 *Domain:* $selectedDomain\n\n"
                                "💬 *Message:*\n${message.isEmpty ? 'Hi, I would like to connect regarding a mobile project.' : message}";

                            final whatsappUrl =
                                "https://wa.me/918610273937?text=${Uri.encodeComponent(whatsappText)}";

                            Navigator.pop(context);
                            _launchUrl(whatsappUrl);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Redirecting to WhatsApp to send your inquiry to Srinithi... 📱✨'),
                                duration: Duration(seconds: 3),
                                backgroundColor: Color(0xFF25D366),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Send to WhatsApp 🚀",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
        fontSize: 13,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF0B0F17) : const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFFD6F00), width: 1.8),
      ),
    );
  }

  Widget _buildQuickCopyChip({
    required String label,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return HoverScale(
      scale: 1.03,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFFD6F00), size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF334155),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.copy_rounded,
                size: 12,
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileNavigationDrawer(BuildContext context) {
    final isDark = widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF151C2C) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _mobileDrawerItem('Home', () {
                Navigator.pop(context);
                _scrollToSection(_homeKey);
              }),
              _mobileDrawerItem('Services', () {
                Navigator.pop(context);
                _scrollToSection(_servicesKey);
              }),
              _mobileDrawerItem('Work Experience', () {
                Navigator.pop(context);
                _scrollToSection(_experienceKey);
              }),
              _mobileDrawerItem('Why Me', () {
                Navigator.pop(context);
                _scrollToSection(_whyMeKey);
              }),
              _mobileDrawerItem('Portfolio', () {
                Navigator.pop(context);
                _scrollToSection(_portfolioKey);
              }),
              _mobileDrawerItem('Testimonials', () {
                Navigator.pop(context);
                _scrollToSection(_testimonialsKey);
              }),
              _mobileDrawerItem('Blog', () {
                Navigator.pop(context);
                _scrollToSection(_blogsKey);
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showContactModal(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFD6F00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Hire Me Now',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mobileDrawerItem(String title, VoidCallback onTap) {
    final isDark = widget.isDarkMode;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF111827),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: Color(0xFFFD6F00)),
      onTap: onTap,
    );
  }

  // ==========================================
  // MAIN BUILD METHOD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final horizontalPadding = isDesktop ? screenWidth * 0.08 : 20.0;

    final isDark = widget.isDarkMode;
    final bgColor = isDark ? const Color(0xFF0B0F17) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 96), // Space for sticky floating navbar

                // 1. Hero Section
                Container(
                  key: _homeKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: FadeTransition(
                    opacity: _heroFade,
                    child: SlideTransition(
                      position: _heroSlide,
                      child: ScaleTransition(
                        scale: _heroScale,
                        child: _buildHeroSection(isDesktop),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // 2. My Services Section
                Container(
                  key: _servicesKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: RevealOnScroll(
                    scrollController: _scrollController,
                    child: _buildServicesSection(isDesktop),
                  ),
                ),

                const SizedBox(height: 100),

                // 3. My Work Experience Section
                Container(
                  key: _experienceKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: RevealOnScroll(
                    scrollController: _scrollController,
                    child: _buildExperienceSection(isDesktop),
                  ),
                ),

                const SizedBox(height: 100),

                // 4. Why Hire Me? Section
                Container(
                  key: _whyMeKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: RevealOnScroll(
                    scrollController: _scrollController,
                    beginOffset: const Offset(0, 0.1),
                    child: _buildWhyHireMeSection(isDesktop),
                  ),
                ),

                const SizedBox(height: 100),

                // 5. Portfolio Section
                Container(
                  key: _portfolioKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: RevealOnScroll(
                    scrollController: _scrollController,
                    child: _buildPortfolioSection(isDesktop),
                  ),
                ),

                const SizedBox(height: 100),

                // 6. Testimonials Section
                Container(
                  key: _testimonialsKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: RevealOnScroll(
                    scrollController: _scrollController,
                    child: _buildTestimonialsSection(isDesktop),
                  ),
                ),

                const SizedBox(height: 100),

                // 7. Project Idea Discussion CTA Card
                Container(
                  key: _contactKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: RevealOnScroll(
                    scrollController: _scrollController,
                    beginOffset: const Offset(0, 0.1),
                    child: _buildProjectIdeaBanner(isDesktop),
                  ),
                ),

                const SizedBox(height: 60),

                // 8. Infinite Skill Marquee Ticker
                _buildScrollingMarquee(),

                const SizedBox(height: 80),

                // 9. Blog Post Section
                Container(
                  key: _blogsKey,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: RevealOnScroll(
                    scrollController: _scrollController,
                    child: _buildBlogSection(isDesktop),
                  ),
                ),

                const SizedBox(height: 100),

                // 10. Footer Section
                _buildFooterSection(isDesktop, horizontalPadding),
              ],
            ),
          ),

          // Sticky Floating Top Navigation Bar
          Positioned(
            top: 16,
            left: horizontalPadding,
            right: horizontalPadding,
            child: _buildFloatingHeader(isDesktop),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. FLOATING NAVBAR HEADER
  // ==========================================
  Widget _buildFloatingHeader(bool isDesktop) {
    final isDark = widget.isDarkMode;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E2023).withValues(alpha: 0.95)
                : const Color(0xFF1E2023).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: const Color(0xFF2E343C),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : const Color(0xFF64748B).withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Section: Brand Logo & Title
              _buildBrandLogo(isDark),

              // Center Section (Desktop): Clean Navigation Bar Items
              if (isDesktop)
                Row(
                  children: [
                    _navItem('Home', () => _scrollToSection(_homeKey),
                        isActive: _activeNavIndex == 0, isDark: isDark),
                    _navItem('Services', () => _scrollToSection(_servicesKey),
                        isActive: _activeNavIndex == 1, isDark: isDark),
                    _navItem(
                        'Experience', () => _scrollToSection(_experienceKey),
                        isActive: _activeNavIndex == 2, isDark: isDark),
                    _navItem('Why Me', () => _scrollToSection(_whyMeKey),
                        isActive: _activeNavIndex == 3, isDark: isDark),
                    _navItem('Portfolio', () => _scrollToSection(_portfolioKey),
                        isActive: _activeNavIndex == 4, isDark: isDark),
                    _navItem('Contact', () => _scrollToSection(_contactKey),
                        isActive: _activeNavIndex == 7, isDark: isDark),
                  ],
                ),

              // Right Section: Primary Action Button & Navigation Controls
              Row(
                children: [
                  HoverScale(
                    child: ElevatedButton(
                      onPressed: () => _showContactModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFD6F00),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor:
                            const Color(0xFFFD6F00).withValues(alpha: 0.4),
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 22 : 16,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Hire Me',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.menu_rounded,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                      onPressed: () => _showMobileNavigationDrawer(context),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo(bool isDark) {
    return InkWell(
      onTap: () => _scrollToSection(_homeKey),
      borderRadius: BorderRadius.circular(30),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFD6F00), Color(0xFFFF9233)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x40FD6F00),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'SRINITHI E',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 16.5,
              color: Colors.white,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title, VoidCallback onTap,
      {bool isActive = false, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: HoverScale(
        scale: 1.04,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFD6F00) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFD6F00).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFE2E8F0),
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 2. HERO SECTION
  // ==========================================
  Widget _buildHeroSection(bool isDesktop) {
    final isDark = widget.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideDesktop = screenWidth >= 1080;

    return Column(
      children: [
        const SizedBox(height: 20),

        // Playful Top Greeting Badge with Sparkle Rays ("Hello!")
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -14,
              right: -8,
              child: CustomPaint(
                size: const Size(28, 16),
                painter: HeaderBurstRaysPainter(),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151C2C) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFF111827).withValues(alpha: 0.18),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Hello!',
                style: GoogleFonts.plusJakartaSans(
                  color: isDark
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Main Hero Title: "I'm Srinithi,\nMobile App Developer"
        FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: screenWidth < 400 ? 30 : (isDesktop ? 54 : 36),
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF111827),
                height: 1.15,
                letterSpacing: -0.5,
              ),
              children: const [
                TextSpan(text: "I'm "),
                TextSpan(
                  text: "Srinithi",
                  style: TextStyle(
                    color: Color(0xFFFD6F00),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ",\nMobile App Developer"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Hero Layout with Interactive Arch & Side Badges
        if (isWideDesktop)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 230,
                child: _buildHeroLeftBadge(isDark),
              ),
              const SizedBox(width: 32),
              _buildCentralArchGraphic(isDesktop),
              const SizedBox(width: 32),
              SizedBox(
                width: 230,
                child: _buildHeroRightBadge(isDark),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildCentralArchGraphic(isDesktop),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildHeroLeftBadge(isDark)),
                    const SizedBox(width: 14),
                    Expanded(child: _buildHeroRightBadge(isDark)),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildHeroLeftBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C2C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '“',
            style: TextStyle(
              color: Color(0xFFFD6F00),
              fontSize: 38,
              fontWeight: FontWeight.w900,
              height: 0.7,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Srinithi's Exceptional mobile app design & development ensure our product's success. Highly Recommended",
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF374151),
              fontSize: 12.5,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroRightBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C2C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFD6F00),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '2.5+ Years',
              style: GoogleFonts.plusJakartaSans(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Experience',
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralArchGraphic(bool isDesktop) {
    return InteractiveHeroPhotoFrame(
      isDesktop: isDesktop,
      onPortfolioTap: () => _scrollToSection(_portfolioKey),
      onHireTap: () => _showContactModal(context),
    );
  }

  // ==========================================
  // 3. MY SERVICES SECTION
  // ==========================================
  Widget _buildServicesSection(bool isDesktop) {
    final isDark = widget.isDarkMode;
    final services = [
      {
        'title': 'Mobile Architecture & Clean Code',
        'description':
            'Architecting scalable applications for iOS, Android, and Flutter Web using Clean Architecture, MVVM, MVC, and Repository Pattern with reusable components.',
        'icon': Icons.architecture_rounded,
        'badge': 'Clean Architecture',
        'targetFilterIndex': 1, // Mobile Apps
        'previewImages': ['assets/namma_1.webp', 'assets/namma_2.webp'],
      },
      {
        'title': 'State Management (Bloc, Provider & GetX)',
        'description':
            'Engineering predictable state management with Bloc, Provider, and GetX for reactive data flows, memory optimization, and 60FPS UI rendering.',
        'icon': Icons.account_tree_rounded,
        'badge': 'Bloc & Provider',
        'targetFilterIndex': 1, // Mobile Apps
        'previewImages': ['assets/total_erp_1.png', 'assets/total_erp_2.png'],
      },
      {
        'title': 'REST API & Local Storage Engine',
        'description':
            'Building robust API integration layers using REST API, Dio, HTTP, and JSON serialization with Local Storage (SQLite, SharedPreferences, Secure Storage).',
        'icon': Icons.api_rounded,
        'badge': 'REST API & Storage',
        'targetFilterIndex': 3, // Enterprise ERP
        'previewImages': ['assets/total_erp_3.png', 'assets/total_erp_4.jpg'],
      },
      {
        'title': 'Firebase Suite & Push Notifications',
        'description':
            'Deploying Firebase Authentication, Cloud Firestore real-time DB, Cloud Messaging (FCM) for push notifications, Crashlytics, and product Analytics.',
        'icon': Icons.cloud_done_rounded,
        'badge': 'Firebase Suite',
        'targetFilterIndex': 4, // Firebase & Cloud
        'previewImages': ['assets/yuvathi_1.webp', 'assets/yuvathi_2.webp'],
      },
      {
        'title': 'Fintech & Payment Gateway Systems',
        'description':
            'Integrating secure Payment Gateways (Stripe, Razorpay, PayPal, PayU) with CIBIL credit checks, automated payout ledgers, and app security standards.',
        'icon': Icons.savings_rounded,
        'badge': 'Fintech & Payments',
        'targetFilterIndex': 2, // Financial Services
        'previewImages': ['assets/namma_3.webp', 'assets/project1.jpg'],
      },
      {
        'title': 'DevOps, CI/CD & Store Deployment',
        'description':
            'Managing automated CI/CD release pipelines, Git/GitHub/Bitbucket version control, testing with Mockito, and Google Play Store & Apple App Store deployment.',
        'icon': Icons.rocket_launch_rounded,
        'badge': 'CI/CD & Deployment',
        'targetFilterIndex': 0, // All Projects
        'previewImages': ['assets/yuvathi_2.webp', 'assets/namma_1.webp'],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isDesktop ? 38 : 28,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                      children: const [
                        TextSpan(text: "My "),
                        TextSpan(
                          text: "Services & Capabilities",
                          style: TextStyle(color: Color(0xFFFD6F00)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 24),
              SizedBox(
                width: 380,
                child: Text(
                  'Delivering production-grade cross-platform mobile apps, financial domain solutions, secure APIs, and clean Flutter architecture. Click any card to explore projects.',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF4B5563),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 36),
        LayoutBuilder(
          builder: (context, constraints) {
            Widget buildCard(Map<String, dynamic> s) {
              final targetFilterIndex = (s['targetFilterIndex'] as int?) ?? 0;
              return InteractiveServiceCard(
                service: s,
                isDark: isDark,
                onTap: () {
                  setState(() {
                    _selectedFilterIndex = targetFilterIndex;
                  });
                  _scrollToSection(_portfolioKey);
                },
              );
            }

            if (constraints.maxWidth > 900) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: buildCard(services[0])),
                      const SizedBox(width: 20),
                      Expanded(child: buildCard(services[1])),
                      const SizedBox(width: 20),
                      Expanded(child: buildCard(services[2])),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: buildCard(services[3])),
                      const SizedBox(width: 20),
                      Expanded(child: buildCard(services[4])),
                      const SizedBox(width: 20),
                      Expanded(child: buildCard(services[5])),
                    ],
                  ),
                ],
              );
            } else if (constraints.maxWidth > 600) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: buildCard(services[0])),
                      const SizedBox(width: 16),
                      Expanded(child: buildCard(services[1])),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: buildCard(services[2])),
                      const SizedBox(width: 16),
                      Expanded(child: buildCard(services[3])),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: buildCard(services[4])),
                      const SizedBox(width: 16),
                      Expanded(child: buildCard(services[5])),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: services
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: buildCard(s),
                        ))
                    .toList(),
              );
            }
          },
        ),
      ],
    );
  }

  static Widget buildCustomUIMockupGraphic(bool isDark, String title) {
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFFAFBFD);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textMain = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    Widget childWidget;

    if (title.contains('Architecture')) {
      childWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.space_dashboard_rounded,
                      size: 13, color: textMain),
                  const SizedBox(width: 4),
                  Text(
                    'Control Panel',
                    style: TextStyle(
                        color: textMain,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFD6F00).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text('25°C',
                    style: TextStyle(
                        color: Color(0xFFFD6F00),
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFD6F00),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.lightbulb_rounded,
                          color: Colors.white, size: 12),
                      SizedBox(height: 2),
                      Text('Light 80%',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold)),
                      Text('Living Room',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 7.5)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.ac_unit_rounded, color: textSub, size: 12),
                      const SizedBox(height: 2),
                      Text('AC 22°C',
                          style: TextStyle(
                              color: textMain,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold)),
                      Text('Active',
                          style: TextStyle(color: textSub, fontSize: 7.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (title.contains('State Management')) {
      childWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('BLoC Stream',
                  style: TextStyle(
                      color: textSub,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600)),
              Text('+\$18.4%',
                  style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 2),
          Text('\$24,850.00',
              style: TextStyle(
                  color: textMain, fontSize: 14, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFD6F00),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                      child: Text('Deposit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0))),
                  child: Center(
                      child: Text('Withdraw',
                          style: TextStyle(
                              color: textMain,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (title.contains('REST API')) {
      childWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0))),
            child: Row(
              children: [
                const Icon(Icons.search_rounded,
                    size: 11, color: Color(0xFFFD6F00)),
                const SizedBox(width: 4),
                Text('Dio HTTP /api/v2/sync...',
                    style: TextStyle(color: textSub, fontSize: 9.5)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('200 OK',
                      style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold))),
              const SizedBox(width: 5),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFD6F00).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('SQLite DB',
                      style: TextStyle(
                          color: Color(0xFFFD6F00),
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      );
    } else if (title.contains('Firebase')) {
      childWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(
                  radius: 3.5, backgroundColor: Color(0xFF10B981)),
              const SizedBox(width: 5),
              Text('Firestore Real-Time Sync',
                  style: TextStyle(
                      color: textMain,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color(0xFFFD6F00).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: const [
                Icon(Icons.notifications_active_rounded,
                    size: 12, color: Color(0xFFFD6F00)),
                SizedBox(width: 5),
                Text('FCM Push Notification Sent!',
                    style: TextStyle(
                        color: Color(0xFFFD6F00),
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      );
    } else if (title.contains('Fintech')) {
      childWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color(0xFFFD6F00),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('RuPay / VISA',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold)),
                Text('•••• 8842',
                    style: TextStyle(color: Colors.white, fontSize: 9.5)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  size: 12, color: Color(0xFF10B981)),
              const SizedBox(width: 4),
              Text('Razorpay & Stripe Verified',
                  style: TextStyle(
                      color: textMain,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    } else {
      childWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Google Play & App Store',
                  style: TextStyle(
                      color: textMain,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold)),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('Live v2.4',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
                5,
                (i) => const Icon(Icons.star_rounded,
                    size: 12, color: Color(0xFFFD6F00))),
          ),
        ],
      );
    }

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: childWidget,
      ),
    );
  }

  // ==========================================
  // 4. MY WORK EXPERIENCE SECTION
  // ==========================================
  Widget _buildExperienceSection(bool isDesktop) {
    final isDark = widget.isDarkMode;
    final experiences = [
      {
        'company': 'SMART GLOBAL SOLUTIONS',
        'period': '2025 - Present',
        'role':
            'Senior Lead Flutter Developer | Mobile Architecture & Delivery',
        'desc':
            'Engineered and maintained scalable cross-platform applications for iOS, Android, and Flutter Web utilizing Clean Architecture, MVVM, and Repository Pattern. Led end-to-end deployment of 10+ live mobile applications on the Google Play Store and Apple App Store. Integrated REST API services (Dio, HTTP, JSON), Firebase (Authentication, Firestore, Cloud Messaging FCM for push notifications, Crashlytics, Analytics), and third-party SDKs.',
        'bullets': [
          'Engineered scalable cross-platform mobile applications for iOS, Android & Flutter Web, managing 10+ production apps on Google Play Store & Apple App Store.',
          'Implemented Clean Architecture, MVVM & Repository Pattern with Bloc, Provider, and GetX state management systems.',
          'Integrated REST API endpoints using Dio & HTTP with JSON serialization, paired with Local Storage (SQLite, SharedPreferences & Secure Storage).',
          'Executed performance optimization, memory optimization, app security, unit/widget testing with Mockito, Git/GitHub version control & CI/CD pipelines.',
          'Led cross-functional collaboration in Agile/JIRA sprints, code reviews, debugging, performance profiling, and production support.',
        ],
      },
      {
        'company': 'CLAIDAS TECHNOLOGIES',
        'period': '2024',
        'role': 'Flutter Application Developer',
        'desc':
            'Developed high-performing cross-platform mobile applications using Flutter & Dart. Implemented pixel-perfect responsive mobile UI and UX optimization while integrating REST APIs, Firebase services, and third-party SDKs for seamless app functionality.',
        'bullets': [
          'Developed cross-platform Android & iOS apps with Flutter & Dart, focusing on pixel-perfect responsive Mobile UI & UX optimization.',
          'Integrated REST APIs, JSON parsing, Firebase Authentication, Cloud Firestore, and Cloud Messaging FCM push notifications.',
          'Utilized Git version control, conducted app debugging, memory optimization, code review, and assisted in production deployment activities.',
        ],
      },
      {
        'company': 'I-BACUS TECH',
        'period': '2023',
        'role': 'Mobile App Engineer & Data Analytics Developer',
        'desc':
            'Engineered mobile application solutions with Flutter, Dart, Java, Git, and Firebase across Android & iOS. Built reusable components, responsive mobile UI layouts, and integrated Power BI and Tableau dashboards for interactive data analytics and reporting.',
        'bullets': [
          'Engineered cross-platform mobile applications for iOS & Android using Flutter, Dart, Java, Git version control, and Firebase services.',
          'Designed modular reusable components, intuitive mobile UI screens, and optimized frontend user flows.',
          'Built interactive data visualization dashboards and analytics reports using Power BI and Tableau.',
        ],
      },
    ];

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(
              fontSize: isDesktop ? 38 : 28,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
            children: const [
              TextSpan(text: "My "),
              TextSpan(
                text: "Work Experience",
                style: TextStyle(color: Color(0xFFFD6F00)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: experiences.length,
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
                color:
                    isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB)),
          ),
          itemBuilder: (context, index) {
            final exp = experiences[index];
            final bullets = exp['bullets'] as List<String>;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp['company'] as String,
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : const Color(0xFF111827),
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exp['period'] as String,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF6B7280),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? const Color(0xFFFD6F00)
                                : (isDark
                                    ? const Color(0xFF151C2C)
                                    : Colors.white),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFD6F00),
                              width: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp['role'] as String,
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : const Color(0xFF111827),
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          exp['desc'] as String,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF4B5563),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: bullets.map((b) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                          color: Color(0xFFFD6F00),
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      b,
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFCBD5E1)
                                            : const Color(0xFF374151),
                                        fontSize: 12.5,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // 5. WHY HIRE ME? & SKILLS QUALIFICATIONS
  // ==========================================
  Widget _buildWhyHireMeSection(bool isDesktop) {
    final isDark = widget.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C2C) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Row(
                children: [
                  if (isWide) ...[
                    Container(
                      width: 280,
                      height: 320,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD6F00),
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(
                          'assets/profile.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person,
                                  size: 100, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isDesktop ? 36 : 28,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                            ),
                            children: const [
                              TextSpan(text: "Why "),
                              TextSpan(
                                text: "Hire me",
                                style: TextStyle(color: Color(0xFFFD6F00)),
                              ),
                              TextSpan(text: "?"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Senior Lead Flutter & Mobile Architecture Specialist with extensive production experience engineering scalable cross-platform applications across iOS, Android, and Flutter Web. Proficient in Clean Architecture, MVVM, MVC, and Repository Pattern combined with modern State Management using Bloc, Provider, and GetX. Skilled in REST API integration using Dio and HTTP for fast JSON serialization, coupled with robust Local Storage solutions (SQLite, SharedPreferences, Secure Storage). Expert in Firebase ecosystems (Authentication, Firestore, Cloud Messaging FCM for push notifications, Crashlytics, Analytics), third-party SDK integrations (Google Maps, Meta WhatsApp API), and Payment Gateways (Stripe, Razorpay, PayPal, PayU). Driven by performance optimization, memory optimization, app security, unit/widget testing with Mockito, Git/GitHub/Bitbucket version control, automated CI/CD pipelines, and Google Play Store & Apple App Store deployment. Experienced in cross-functional collaboration within Agile/JIRA environments, delivering pixel-perfect responsive mobile UI and UX optimization.',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF4B5563),
                            fontSize: 13.5,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _buildStatItem('20+', 'Projects Completed'),
                            const SizedBox(width: 36),
                            _buildStatItem('15+', 'Satisfied Clients'),
                            const SizedBox(width: 36),
                            _buildStatItem('2.5+', 'Years Experience'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        HoverScale(
                          child: OutlinedButton(
                            onPressed: () => _showContactModal(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                              side: const BorderSide(
                                  color: Color(0xFFFD6F00), width: 1.8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Hire Me Now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 40),
          Divider(
              color:
                  isDark ? const Color(0xFF26334D) : const Color(0xFFE5E7EB)),
          const SizedBox(height: 30),

          // TECHNICAL SKILLS & QUALIFICATIONS GRID
          Text(
            'Core Skills & Professional Qualifications',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comprehensive technical breakdown of my expertise across mobile architecture, backend services, domain knowledge, and deployment.',
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildTechnicalSkillsGrid(isDesktop),
        ],
      ),
    );
  }

  Widget _buildTechnicalSkillsGrid(bool isDesktop) {
    final isDark = widget.isDarkMode;
    final skillCategories = [
      {
        'category': 'Mobile Architecture & Frameworks',
        'icon': Icons.architecture_rounded,
        'skills': [
          'Flutter, Dart, Android & iOS Native',
          'Flutter Web Cross Platform Development',
          'Clean Architecture, MVVM & MVC Patterns',
          'Repository Pattern & Modular Architecture',
          'Scalable Applications & Reusable Components',
        ],
      },
      {
        'category': 'State Management & Storage',
        'icon': Icons.account_tree_rounded,
        'skills': [
          'Bloc, Provider & GetX State Management',
          'Local Storage: SQLite & SharedPreferences',
          'Secure Storage & App Security Controls',
          'JSON Serialization & Data Hydration',
          'Performance Optimization & Memory Tuning',
        ],
      },
      {
        'category': 'APIs, SDKs & Payment Gateways',
        'icon': Icons.api_rounded,
        'skills': [
          'REST API Integration, Dio & HTTP Clients',
          'Third Party SDK Integration & Native Plugins',
          'Google Maps SDK & Geolocation Services',
          'Payment Gateways: Stripe, Razorpay, PayPal, PayU',
          'Meta WhatsApp API & IVR Voice Telephony',
        ],
      },
      {
        'category': 'Firebase & Cloud Backend',
        'icon': Icons.local_fire_department_rounded,
        'skills': [
          'Firebase Authentication & OAuth Security',
          'Cloud Firestore Real-Time Database',
          'Cloud Messaging (FCM) & Push Notification',
          'Crashlytics Error Diagnostics & Analytics',
          'Cloud Functions Microservices Backend',
        ],
      },
      {
        'category': 'DevOps, Testing & Quality',
        'icon': Icons.cloud_upload_rounded,
        'skills': [
          'Version Control: Git, GitHub & Bitbucket',
          'CI/CD Pipelines & Automated Deployment',
          'Google Play Store & Apple App Store Publishing',
          'Testing with Mockito, Unit & Widget Testing',
          'Code Review, Debugging & Production Support',
        ],
      },
      {
        'category': 'UI/UX, Agile & Collaboration',
        'icon': Icons.analytics_rounded,
        'skills': [
          'Responsive UI & Pixel Perfect UI Delivery',
          'UX Optimization & Micro-Animations',
          'Agile Methodologies & JIRA Project Management',
          'Cross Functional Collaboration & Mentorship',
          'Power BI & Tableau Data Analytics',
        ],
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 900
            ? 3
            : (constraints.maxWidth > 600 ? 2 : 1);
        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: skillCategories.map((cat) {
            final double cardWidth =
                (constraints.maxWidth - ((crossCount - 1) * 18)) / crossCount;
            final skills = cat['skills'] as List<String>;
            return HoverScale(
              scale: 1.02,
              child: Container(
                width: cardWidth,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE5E7EB),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFD6F00).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: const Color(0xFFFD6F00),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            cat['category'] as String,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: skills.map((s) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFFFD6F00),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s,
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF374151),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatItem(String number, String label) {
    final isDark = widget.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Color(0xFFFD6F00),
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 6. PORTFOLIO SECTION
  // ==========================================
  Widget _buildPortfolioSection(bool isDesktop) {
    final isDark = widget.isDarkMode;
    final filteredProjects = _selectedFilterIndex == 0
        ? _portfolioProjects
        : _portfolioProjects
            .where(
                (p) => p['category'] == _portfolioFilters[_selectedFilterIndex])
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isDesktop ? 38 : 26,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  children: const [
                    TextSpan(text: "Lets have a look at my "),
                    TextSpan(
                      text: "Portfolio",
                      style: TextStyle(color: Color(0xFFFD6F00)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            HoverScale(
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _selectedFilterIndex = 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFD6F00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('View All'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_portfolioFilters.length, (index) {
              final isSelected = _selectedFilterIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(_portfolioFilters[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                  },
                  selectedColor: const Color(0xFFFD6F00),
                  backgroundColor: isDark
                      ? const Color(0xFF151C2C)
                      : const Color(0xFFF3F4F6),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF374151)),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFFD6F00)
                          : (isDark
                              ? const Color(0xFF26334D)
                              : const Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 32),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: filteredProjects.isEmpty
              ? const Center(
                  key: ValueKey('empty'),
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'No projects found in this category.',
                      style: TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ),
                )
              : ListView.builder(
                  key: ValueKey(_selectedFilterIndex),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    final proj = filteredProjects[index];
                    return PortfolioProjectCard(
                      proj: proj,
                      isDesktop: isDesktop,
                      isDark: isDark,
                      actionButtonsBuilder: _buildProjectActionButtons,
                      onCardTap: () => _showProjectDetailsModal(context, proj),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProjectActionButtons({
    String? github,
    String? playstore,
    String? appstore,
    String? webLink,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (github != null && github.isNotEmpty)
          _buildActionButton(
            icon: FontAwesomeIcons.github,
            label: 'GitHub',
            url: github,
            bgColor: const Color(0xFF1F2937),
            textColor: Colors.white,
          ),
        if (playstore != null && playstore.isNotEmpty)
          _buildActionButton(
            icon: FontAwesomeIcons.googlePlay,
            label: 'Play Store',
            url: playstore,
            bgColor: const Color(0xFF01875F),
            textColor: Colors.white,
          ),
        if (appstore != null && appstore.isNotEmpty)
          _buildActionButton(
            icon: FontAwesomeIcons.apple,
            label: 'App Store',
            url: appstore,
            bgColor: const Color(0xFF000000),
            textColor: Colors.white,
          ),
        if (webLink != null && webLink.isNotEmpty)
          _buildActionButton(
            icon: Icons.ios_share_rounded,
            label: 'Share Project',
            url: webLink,
            bgColor: const Color(0xFFFD6F00),
            textColor: Colors.white,
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required dynamic icon,
    required String label,
    required String url,
    required Color bgColor,
    required Color textColor,
  }) {
    return HoverScale(
      scale: 1.06,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.22),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon is IconData)
                Icon(icon, size: 15, color: textColor)
              else
                FaIcon(icon, size: 14, color: textColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 7. TESTIMONIALS SECTION
  // ==========================================
  Widget _buildTestimonialsSection(bool isDesktop) {
    final isDark = widget.isDarkMode;
    final testimonials = [
      {
        'quote':
            'Srinithi delivered our chit fund app exactly as we imagined — fast, reliable, and beautifully designed. Launched on App Store cleanly.',
        'name': 'Ramesh Kumar',
        'role': 'Founder, ChitSoft',
      },
      {
        'quote':
            'The Namma Ooru Cab app exceeded our expectations. Real-time driver tracking works flawlessly and our drivers love the interface.',
        'name': 'Senthil Kumar',
        'role': 'CEO, Namma Ooru Cab',
      },
      {
        'quote':
            'Building a women health app requires precision and empathy. Srinithi nailed both — our Yuvathi app users trust and love the design.',
        'name': 'Priya Meenakshi',
        'role': 'Director, Yuvathi Health',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C2C) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: isDesktop ? 36 : 26,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
              children: const [
                TextSpan(text: "Testimonials That\n"),
                TextSpan(text: "Speak to "),
                TextSpan(
                  text: "My Results",
                  style: TextStyle(color: Color(0xFFFD6F00)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: testimonials.map((t) {
                    return Expanded(
                      child: HoverScale(
                        scale: 1.03,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF0F172A) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE5E7EB),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '“',
                                style: TextStyle(
                                  color: Color(0xFFFD6F00),
                                  fontSize: 40,
                                  height: 0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                t['quote']!,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF374151),
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFD6F00),
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                t['name']!,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                t['role']!,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF6B7280),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Column(
                  children: testimonials.map((t) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['quote']!,
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF374151),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '- ${t['name']} (${t['role']})',
                            style: const TextStyle(
                              color: Color(0xFFFD6F00),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 8. PROJECT IDEA DISCUSSION CTA BANNER
  // ==========================================
  Widget _buildProjectIdeaBanner(bool isDesktop) {
    final isDark = widget.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 36),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1B14) : const Color(0xFFFFF3EB),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFF5E2F13) : const Color(0xFFFFD8C2),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isDesktop ? 36 : 24,
                          fontWeight: FontWeight.w800,
                          color:
                              isDark ? Colors.white : const Color(0xFF111827),
                        ),
                        children: const [
                          TextSpan(text: "Have an Awesome Project\nIdea? "),
                          TextSpan(
                            text: "Let's Discuss",
                            style: TextStyle(color: Color(0xFFFD6F00)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        _buildContactChip(
                          icon: Icons.email_rounded,
                          label: 'srinithie86@gmail.com',
                          isDark: isDark,
                          onTap: () {
                            Clipboard.setData(const ClipboardData(
                                text: 'srinithie86@gmail.com'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email copied! 📋'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFFFD6F00),
                              ),
                            );
                          },
                        ),
                        _buildContactChip(
                          icon: Icons.phone_rounded,
                          label: '+91 86102 73937',
                          isDark: isDark,
                          onTap: () {
                            Clipboard.setData(
                                const ClipboardData(text: '+918610273937'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Phone number copied! 📋'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFFFD6F00),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isWide)
                HoverScale(
                  child: ElevatedButton(
                    onPressed: () => _showContactModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFD6F00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Hire me',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContactChip({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151C2C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFFD6F00), size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 9. SCROLLING MARQUEE TICKER BANNER
  // ==========================================
  Widget _buildScrollingMarquee() {
    final marqueeItems = [
      'Flutter & Dart',
      '✦',
      'Google Maps SDK',
      '✦',
      'CIBIL Credit API',
      '✦',
      'Meta WhatsApp Business API',
      '✦',
      'IVR Call Integration',
      '✦',
      'Shipment & Logistics APIs',
      '✦',
      'Payment Gateways (Stripe, Razorpay, UPI)',
      '✦',
      'Financial Services Domain',
      '✦',
      'Firebase (Auth, Firestore, FCM)',
      '✦',
      'BLoC & Provider State',
      '✦',
      'Play Store & App Store Publishing',
      '✦',
    ];

    return Container(
      height: 54,
      width: double.infinity,
      color: const Color(0xFFFD6F00),
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: _marqueeController,
            builder: (context, child) {
              return FractionalTranslation(
                translation: Offset(-_marqueeController.value, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(4, (i) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: marqueeItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: 1.1,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 10. BLOG POST SECTION
  // ==========================================
  Widget _buildBlogSection(bool isDesktop) {
    final isDark = widget.isDarkMode;
    final blogs = [
      {
        'tag': 'Financial Tech',
        'date': 'Oct 15, 2024',
        'title':
            'Building Secure Financial Services Mobile Apps with Flutter & Payment Gateways',
        'image': 'assets/project1.jpg',
        'github': 'https://github.com/srinithie86/chitsoft_app',
        'playstore':
            'https://play.google.com/store/apps/details?id=com.chitsoft.app',
        'appstore':
            'https://apps.apple.com/in/app/chitsoft-chitfund-mangagement/id6757467879',
        'link':
            'https://apps.apple.com/in/app/chitsoft-chitfund-mangagement/id6757467879',
      },
      {
        'tag': 'Flutter Architecture',
        'date': 'Nov 18, 2024',
        'title':
            'Mastering State Management in Flutter: BLoC & Provider in Complex Applications',
        'image': 'assets/namma_3.webp',
        'github': 'https://github.com/srinithie86',
        'playstore':
            'https://play.google.com/store/apps/details?id=com.lirante.food',
        'appstore': 'https://apps.apple.com',
        'link': 'https://github.com/srinithie86',
      },
      {
        'tag': 'Firebase Backend',
        'date': 'Dec 28, 2024',
        'title':
            'Deep-Dive: Cloud Firestore, Auth, Functions & FCM Push Notifications in Production',
        'image': 'assets/yuvathi_2.webp',
        'github': 'https://github.com/srinithie86/yuvathi_health',
        'playstore':
            'https://play.google.com/store/apps/details?id=com.yuvathi.healthcare',
        'appstore': 'https://apps.apple.com/app/yuvathi-health/id987654321',
        'link': 'https://github.com/srinithie86',
      },
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isDesktop ? 38 : 26,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  children: const [
                    TextSpan(text: "From my "),
                    TextSpan(
                      text: "blog post",
                      style: TextStyle(color: Color(0xFFFD6F00)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            HoverScale(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFD6F00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('View All'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                children: blogs.map((b) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: HoverScale(
                          scale: 1.03, child: _buildBlogCard(b, isDark)),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Column(
                children: blogs.map((b) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildBlogCard(b, isDark),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildBlogCard(Map<String, String> blog, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                blog['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE5E7EB),
                  child: const Center(
                    child: Icon(Icons.article_rounded,
                        color: Color(0xFF9CA3AF), size: 50),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFD6F00).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  blog['tag']!,
                  style: const TextStyle(
                    color: Color(0xFFFD6F00),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                blog['date']!,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF6B7280),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            blog['title']!,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          _buildProjectActionButtons(
            github: blog['github'],
            playstore: blog['playstore'],
            appstore: blog['appstore'],
            webLink: blog['link'],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 11. FOOTER SECTION
  // ==========================================
  Widget _buildFooterSection(bool isDesktop, double horizontalPadding) {
    const cardBgColor = Color(0xFF1E2023);
    const borderColor = Color(0xFF2E343C);
    const dividerColor = Color(0xFF333A42);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 40,
      ),
      padding: EdgeInsets.all(isDesktop ? 44 : 24),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header Row: "Lets Connect there" & "Hire me ↗" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Lets Connect there',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isDesktop ? 44 : 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              HoverScale(
                child: ElevatedButton(
                  onPressed: () => _showContactModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFD6F00),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: const Color(0xFFFD6F00).withValues(alpha: 0.4),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 28 : 20,
                      vertical: isDesktop ? 18 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Hire me ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(Icons.north_east_rounded,
                          size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Divider(color: dividerColor, thickness: 1.2),
          const SizedBox(height: 32),

          // 2. Middle Grid: Brand Info, Navigation, Contact, Newsletter
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 850;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Col 1: Brand & Social Icons
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFD6F00),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'S',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'SRINITHI E',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Senior Flutter Developer creating intuitive, high-performance cross-platform mobile applications for Android, iOS, and Web.',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 13.5,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              _socialIcon(FontAwesomeIcons.facebookF,
                                  'https://github.com/srinithie86', true),
                              const SizedBox(width: 10),
                              _socialIcon(FontAwesomeIcons.youtube,
                                  'https://youtube.com', true),
                              const SizedBox(width: 10),
                              _socialIcon(FontAwesomeIcons.whatsapp,
                                  'https://wa.me/918610273937', true),
                              const SizedBox(width: 10),
                              _socialIcon(FontAwesomeIcons.instagram,
                                  'https://instagram.com', true),
                              const SizedBox(width: 10),
                              _socialIcon(FontAwesomeIcons.xTwitter,
                                  'https://twitter.com', true),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Col 2: Navigation Links
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Navigation',
                            style: TextStyle(
                              color: Color(0xFFFD6F00),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _footerLink(
                              'Home', () => _scrollToSection(_homeKey), true),
                          _footerLink('About Us',
                              () => _scrollToSection(_whyMeKey), true),
                          _footerLink('Service',
                              () => _scrollToSection(_servicesKey), true),
                          _footerLink('Resume',
                              () => _scrollToSection(_experienceKey), true),
                          _footerLink('Project',
                              () => _scrollToSection(_portfolioKey), true),
                        ],
                      ),
                    ),

                    // Col 3: Contact Info
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact',
                            style: TextStyle(
                              color: Color(0xFFFD6F00),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const SelectableText(
                            '+91 86102 73937',
                            style: TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SelectableText(
                            'srinithie86@gmail.com',
                            style: TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SelectableText(
                            'github.com/srinithie86',
                            style: TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Col 4: Newsletter Subscription Box
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Get the latest information',
                            style: TextStyle(
                              color: Color(0xFFFD6F00),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 16, right: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontSize: 13.5),
                                    decoration: InputDecoration(
                                      hintText: 'Email Address',
                                      hintStyle: TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 13.5),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFD6F00),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile stacked layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFD6F00),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'SRINITHI E',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Senior Flutter Developer creating intuitive cross-platform mobile apps for Android, iOS, and Web.',
                      style: TextStyle(
                          color: Color(0xFF94A3B8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _socialIcon(FontAwesomeIcons.facebookF,
                            'https://github.com/srinithie86', true),
                        const SizedBox(width: 8),
                        _socialIcon(FontAwesomeIcons.youtube,
                            'https://youtube.com', true),
                        const SizedBox(width: 8),
                        _socialIcon(FontAwesomeIcons.whatsapp,
                            'https://wa.me/918610273937', true),
                        const SizedBox(width: 8),
                        _socialIcon(FontAwesomeIcons.instagram,
                            'https://instagram.com', true),
                        const SizedBox(width: 8),
                        _socialIcon(FontAwesomeIcons.xTwitter,
                            'https://twitter.com', true),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Navigation',
                                style: TextStyle(
                                    color: Color(0xFFFD6F00),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              const SizedBox(height: 12),
                              _footerLink('Home',
                                  () => _scrollToSection(_homeKey), true),
                              _footerLink('About Us',
                                  () => _scrollToSection(_whyMeKey), true),
                              _footerLink('Service',
                                  () => _scrollToSection(_servicesKey), true),
                              _footerLink('Resume',
                                  () => _scrollToSection(_experienceKey), true),
                              _footerLink('Project',
                                  () => _scrollToSection(_portfolioKey), true),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Contact',
                                style: TextStyle(
                                    color: Color(0xFFFD6F00),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              const SizedBox(height: 12),
                              const SelectableText('+91 86102 73937',
                                  style: TextStyle(
                                      color: Color(0xFFCBD5E1), fontSize: 13)),
                              const SizedBox(height: 6),
                              const SelectableText('srinithie86@gmail.com',
                                  style: TextStyle(
                                      color: Color(0xFFCBD5E1), fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Get the latest information',
                      style: TextStyle(
                          color: Color(0xFFFD6F00),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.only(left: 16, right: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              style: TextStyle(
                                  color: Color(0xFF1E293B), fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                    color: Color(0xFF94A3B8), fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFD6F00),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 32),
          const Divider(color: dividerColor, thickness: 1.2),
          const SizedBox(height: 20),

          // 3. Bottom Copyright & Terms
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Copyright © 2026 Srinithi. All Rights Reserved.',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12.5,
                ),
              ),
              Text(
                'User Terms & Conditions | Privacy Policy',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(dynamic icon, String url, bool isDark) {
    return HoverScale(
      scale: 1.15,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF2D333B),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF3E454F),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
              ),
            ],
          ),
          child: FaIcon(
            icon,
            size: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String title, VoidCallback onTap, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// REUSABLE SMARTPHONE MOCKUP FRAME & PROJECT CARD
// ==========================================

/// Aesthetic, highly realistic smartphone hardware mockup frame with animated screen transitions
class PhoneMockupFrame extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final double height;

  const PhoneMockupFrame({
    super.key,
    required this.imagePath,
    this.backgroundColor = Colors.white,
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    final phoneWidth = height * 0.49;

    return Container(
      width: phoneWidth,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 3.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: const Color(0xFFFD6F00).withValues(alpha: 0.15),
            blurRadius: 36,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner Phone Screen Display
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(31),
                child: Container(
                  color: backgroundColor,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: SizedBox(
                      key: ValueKey<String>(imagePath),
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF1E293B),
                          child: const Center(
                            child: Icon(
                              Icons.phone_iphone_rounded,
                              size: 54,
                              color: Color(0xFFFD6F00),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Dynamic Island Notch Pill
          Positioned(
            top: 11,
            child: Container(
              width: 66,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E293B), width: 0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      width: 6.5,
                      height: 6.5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Home Bar Indicator
          Positioned(
            bottom: 8,
            child: Container(
              width: 82,
              height: 3.5,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioProjectCard extends StatefulWidget {
  final Map<String, dynamic> proj;
  final bool isDesktop;
  final bool isDark;
  final VoidCallback onCardTap;
  final Widget Function({
    String? github,
    String? playstore,
    String? appstore,
    String? webLink,
  }) actionButtonsBuilder;

  const PortfolioProjectCard({
    super.key,
    required this.proj,
    required this.isDesktop,
    required this.isDark,
    required this.onCardTap,
    required this.actionButtonsBuilder,
  });

  @override
  State<PortfolioProjectCard> createState() => _PortfolioProjectCardState();
}

class _PortfolioProjectCardState extends State<PortfolioProjectCard> {
  int _activeScreenIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScrollTimer();
  }

  void _startAutoScrollTimer() {
    final List<String> screens =
        (widget.proj['screens'] as List<dynamic>?)?.cast<String>() ??
            [widget.proj['image'] as String];
    if (screens.length > 1) {
      _autoScrollTimer?.cancel();
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (mounted) {
          setState(() {
            _activeScreenIndex = (_activeScreenIndex + 1) % screens.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proj = widget.proj;
    final isDark = widget.isDark;
    final List<String> screens =
        (proj['screens'] as List<dynamic>?)?.cast<String>() ??
            [proj['image'] as String];
    final Color fallbackColor =
        proj['fallbackColor'] as Color? ?? const Color(0xFFF1F5F9);

    return HoverScale(
      scale: 1.01,
      child: GestureDetector(
        onTap: widget.onCardTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 36),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151C2C) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 750;

              final mockupDisplay = Container(
                height: isWide ? 440 : 380,
                width: isWide ? 380 : double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: [
                      fallbackColor.withValues(alpha: isDark ? 0.3 : 0.8),
                      fallbackColor.withValues(alpha: isDark ? 0.1 : 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: PhoneMockupFrame(
                          imagePath: screens[
                              _activeScreenIndex.clamp(0, screens.length - 1)],
                          height: isWide ? 370 : 320,
                        ),
                      ),
                    ),
                    if (screens.length > 1) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(screens.length, (sIdx) {
                            final isSelected = _activeScreenIndex == sIdx;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _activeScreenIndex = sIdx;
                                });
                                _startAutoScrollTimer();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: isSelected ? 24 : 8,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFD6F00)
                                      : const Color(0xFF94A3B8)
                                          .withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ],
                ),
              );

              final projectDetails = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFD6F00).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          proj['category'] as String? ?? 'Mobile App',
                          style: const TextStyle(
                            color: Color(0xFFFD6F00),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Click card for details',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF6B7280),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    proj['title'] as String,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    proj['subtitle'] as String,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    proj['description'] as String,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF4B5563),
                      fontSize: 13,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (proj['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  widget.actionButtonsBuilder(
                    github: proj['github'] as String?,
                    playstore: proj['playstore'] as String?,
                    appstore: proj['appstore'] as String?,
                    webLink: proj['link'] as String?,
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    mockupDisplay,
                    const SizedBox(width: 32),
                    Expanded(child: projectDetails),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mockupDisplay,
                    const SizedBox(height: 24),
                    projectDetails,
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// ==========================================
// INTERACTIVE HERO PHOTO FRAME (DUAL PHOTO MOUSE NAVIGATION ANIMATION)
// ==========================================
class InteractiveHeroPhotoFrame extends StatefulWidget {
  final bool isDesktop;
  final VoidCallback onPortfolioTap;
  final VoidCallback onHireTap;

  const InteractiveHeroPhotoFrame({
    super.key,
    required this.isDesktop,
    required this.onPortfolioTap,
    required this.onHireTap,
  });

  @override
  State<InteractiveHeroPhotoFrame> createState() =>
      _InteractiveHeroPhotoFrameState();
}

class _InteractiveHeroPhotoFrameState extends State<InteractiveHeroPhotoFrame> {
  bool _isHovered = false;
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetWidth = widget.isDesktop ? 360.0 : 280.0;
    final archWidth =
        math.min(targetWidth, math.max(240.0, screenWidth - 48.0));
    final archHeight = archWidth * 1.16;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _tiltX = 0.0;
        _tiltY = 0.0;
      }),
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final local = box.globalToLocal(event.position);
          final dx = (local.dx / box.size.width - 0.5) * 2;
          final dy = (local.dy / box.size.height - 0.5) * 2;
          setState(() {
            _tiltX = -dy * 0.05;
            _tiltY = dx * 0.05;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_tiltX)
          ..rotateY(_tiltY),
        transformAlignment: Alignment.center,
        width: archWidth,
        height: archHeight,
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: archWidth,
            height: archHeight,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // Light Arch Background Dome Container
                Container(
                  width: archWidth,
                  height: archHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFF7ED),
                        Color(0xFFFFEDD5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(220),
                      bottom: Radius.circular(24),
                    ),
                    border: Border.all(
                      color: const Color(0xFFFD6F00).withValues(alpha: 0.35),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFD6F00).withValues(alpha: 0.18),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),

                // Srinithi Portrait Overlay (Clean transparent cutout)
                Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(220),
                      bottom: Radius.circular(24),
                    ),
                    child: SizedBox(
                      width: archWidth,
                      height: archHeight,
                      child: Image.asset(
                        'assets/profile_cutout.png',
                        width: archWidth,
                        height: archHeight,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/hero_clean_transparent.png',
                          width: archWidth,
                          height: archHeight,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/hero_clean.png',
                            width: archWidth,
                            height: archHeight,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Floating Action Pills (Portfolio ↗ & Hire me)
                Positioned(
                  bottom: 16,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181B).withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HoverScale(
                            child: ElevatedButton(
                              onPressed: widget.onPortfolioTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFD6F00),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Portfolio',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.north_east_rounded, size: 14),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          HoverScale(
                            child: TextButton(
                              onPressed: widget.onHireTap,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                              ),
                              child: const Text(
                                'Hire me',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// CUSTOM PAINTER: DOODLE VECTOR ANNOTATIONS
// ==========================================
class HeroDoodlesPainter extends CustomPainter {
  final Color color;
  HeroDoodlesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    _drawHeart(canvas, strokePaint, Offset(w * 0.18, h * 0.16), 16);
    _drawHeart(canvas, strokePaint, Offset(w * 0.22, h * 0.12), 12);
    _drawCloud(canvas, strokePaint, Offset(w * 0.78, h * 0.15), 32);
    _drawSparkleStar(canvas, strokePaint, Offset(w * 0.88, h * 0.24), 16);
    _drawSparkleStar(canvas, strokePaint, Offset(w * 0.82, h * 0.28), 10);
    _drawSpiralLoop(canvas, strokePaint, Offset(w * 0.12, h * 0.32), 22);
    _draw5PointStar(canvas, strokePaint, Offset(w * 0.14, h * 0.48), 12);
    _drawHeart(canvas, strokePaint, Offset(w * 0.10, h * 0.60), 18);
    _drawSquiggleCurve(canvas, strokePaint, Offset(w * 0.06, h * 0.78),
        Offset(w * 0.22, h * 0.86));
    _drawConstellationDots(
        canvas, strokePaint, fillPaint, Offset(w * 0.18, h * 0.74));
    _drawPlanetWithRing(canvas, strokePaint, Offset(w * 0.88, h * 0.44), 18);
    _draw5PointStar(canvas, strokePaint, Offset(w * 0.82, h * 0.58), 14);
    _drawPaperAirplane(canvas, strokePaint, Offset(w * 0.88, h * 0.74), 22);
    _drawLoopSquiggle(canvas, strokePaint, Offset(w * 0.76, h * 0.82));
  }

  void _drawHeart(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(
      center.dx - size * 0.8,
      center.dy - size * 0.4,
      center.dx - size * 0.4,
      center.dy - size * 0.9,
      center.dx,
      center.dy - size * 0.3,
    );
    path.cubicTo(
      center.dx + size * 0.4,
      center.dy - size * 0.9,
      center.dx + size * 0.8,
      center.dy - size * 0.4,
      center.dx,
      center.dy + size * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  void _drawCloud(Canvas canvas, Paint paint, Offset center, double width) {
    final path = Path();
    final h = width * 0.5;
    path.moveTo(center.dx - width * 0.4, center.dy + h * 0.3);
    path.arcToPoint(Offset(center.dx - width * 0.1, center.dy - h * 0.2),
        radius: Radius.circular(width * 0.3));
    path.arcToPoint(Offset(center.dx + width * 0.3, center.dy - h * 0.1),
        radius: Radius.circular(width * 0.3));
    path.arcToPoint(Offset(center.dx + width * 0.4, center.dy + h * 0.3),
        radius: Radius.circular(width * 0.2));
    path.arcToPoint(Offset(center.dx - width * 0.4, center.dy + h * 0.3),
        radius: Radius.circular(width * 0.4));
    canvas.drawPath(path, paint);
  }

  void _drawSparkleStar(
      Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.quadraticBezierTo(center.dx, center.dy, center.dx + radius, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + radius);
    path.quadraticBezierTo(center.dx, center.dy, center.dx - radius, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - radius);
    canvas.drawPath(path, paint);
  }

  void _draw5PointStar(
      Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    final double innerRadius = radius * 0.4;
    for (int i = 0; i < 5; i++) {
      final double outerAngle = (i * 72 - 90) * math.pi / 180;
      final double innerAngle = (i * 72 + 36 - 90) * math.pi / 180;
      final x1 = center.dx + radius * math.cos(outerAngle);
      final y1 = center.dy + radius * math.sin(outerAngle);
      final x2 = center.dx + innerRadius * math.cos(innerAngle);
      final y2 = center.dy + innerRadius * math.sin(innerAngle);
      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSpiralLoop(
      Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    for (double t = 0; t < 3 * math.pi; t += 0.1) {
      final r = radius * (t / (3 * math.pi));
      final x = center.dx + r * math.cos(t);
      final y = center.dy + r * math.sin(t);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawPlanetWithRing(
      Canvas canvas, Paint paint, Offset center, double radius) {
    canvas.drawCircle(center, radius, paint);
    final rect = Rect.fromCenter(
        center: center, width: radius * 2.6, height: radius * 0.9);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 8);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawOval(rect, paint);
    canvas.restore();
  }

  void _drawPaperAirplane(
      Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    path.moveTo(center.dx + size, center.dy - size * 0.6);
    path.lineTo(center.dx - size, center.dy + size * 0.6);
    path.lineTo(center.dx - size * 0.2, center.dy + size * 0.1);
    path.close();

    path.moveTo(center.dx + size, center.dy - size * 0.6);
    path.lineTo(center.dx - size * 0.2, center.dy + size * 0.1);
    path.lineTo(center.dx + size * 0.2, center.dy + size * 0.8);
    path.lineTo(center.dx + size * 0.4, center.dy + size * 0.2);

    canvas.drawPath(path, paint);
  }

  void _drawSquiggleCurve(
      Canvas canvas, Paint paint, Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.cubicTo(
      start.dx + 25,
      start.dy - 20,
      end.dx - 25,
      end.dy + 20,
      end.dx,
      end.dy,
    );
    canvas.drawPath(path, paint);
  }

  void _drawConstellationDots(
      Canvas canvas, Paint strokePaint, Paint fillPaint, Offset origin) {
    final points = [
      origin,
      Offset(origin.dx + 18, origin.dy - 10),
      Offset(origin.dx + 36, origin.dy + 15),
      Offset(origin.dx + 54, origin.dy - 5),
    ];
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      canvas.drawCircle(points[i], 3, fillPaint);
      canvas.drawCircle(points[i], 3, strokePaint);
    }
    canvas.drawPath(path, strokePaint);
  }

  void _drawLoopSquiggle(Canvas canvas, Paint paint, Offset origin) {
    final path = Path();
    path.moveTo(origin.dx, origin.dy);
    path.cubicTo(origin.dx + 20, origin.dy - 30, origin.dx + 40, origin.dy + 30,
        origin.dx + 60, origin.dy - 10);
    path.cubicTo(origin.dx + 70, origin.dy - 30, origin.dx + 50, origin.dy - 40,
        origin.dx + 40, origin.dy - 20);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// CUSTOM PAINTER: HEADER BURST RAYS ABOVE "HELLO!" BADGE
// ==========================================
class HeaderBurstRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFD6F00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height;

    canvas.drawLine(Offset(cx, cy), Offset(cx, cy - 10), paint);
    canvas.drawLine(Offset(cx - 10, cy + 2), Offset(cx - 18, cy - 6), paint);
    canvas.drawLine(Offset(cx + 10, cy + 2), Offset(cx + 18, cy - 6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// CUSTOM PAINTER: ACCENT DOODLE CURVES (LEFT ACCENT)
// ==========================================
class AccentDoodleCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFD6F00).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final offsetX = i * 8.0;
      final pathArc = Path();
      pathArc.moveTo(offsetX, 0);
      pathArc.cubicTo(
        offsetX + 15,
        size.height * 0.3,
        offsetX + 15,
        size.height * 0.7,
        offsetX,
        size.height,
      );
      canvas.drawPath(pathArc, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// INTERACTIVE SERVICE CARD (THEME IDLE vs HOVER/TAP ORANGE)
// ==========================================
class InteractiveServiceCard extends StatefulWidget {
  final Map<String, dynamic> service;
  final bool isDark;
  final VoidCallback onTap;

  const InteractiveServiceCard({
    super.key,
    required this.service,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<InteractiveServiceCard> createState() => _InteractiveServiceCardState();
}

class _InteractiveServiceCardState extends State<InteractiveServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final String title = widget.service['title'] as String;
    final String description = widget.service['description'] as String;
    final IconData icon = widget.service['icon'] as IconData;
    final String badge = widget.service['badge'] as String;

    final isActive = _isHovered;

    // Normal Theme Idle Color vs Hovered/Tapped Orange
    final cardBg = isActive
        ? const Color(0xFFFD6F00)
        : (widget.isDark ? const Color(0xFF151C2C) : const Color(0xFFF8FAFC));

    final cardBorder = isActive
        ? const Color(0xFFFD6F00)
        : (widget.isDark ? const Color(0xFF26334D) : const Color(0xFFE5E7EB));

    final textTitleColor = isActive
        ? Colors.white
        : (widget.isDark ? Colors.white : const Color(0xFF111827));

    final textDescColor = isActive
        ? Colors.white.withValues(alpha: 0.9)
        : (widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563));

    final badgeBg = isActive
        ? Colors.white.withValues(alpha: 0.22)
        : const Color(0xFFFD6F00).withValues(alpha: 0.12);

    final badgeTextColor = isActive ? Colors.white : const Color(0xFFFD6F00);
    final iconColor = isActive ? Colors.white : const Color(0xFFFD6F00);

    final buttonBg = isActive
        ? const Color(0xFFFD6F00)
        : (widget.isDark ? const Color(0xFF1E293B) : const Color(0xFF111827));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: HoverScale(
        scale: 1.03,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            height: 380,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: cardBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? const Color(0xFFFD6F00).withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: isActive ? 22 : 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Top Content Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: badgeTextColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(icon, color: iconColor, size: 26),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: GoogleFonts.plusJakartaSans(
                          color: textTitleColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        child: Text(title),
                      ),
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          color: textDescColor,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Layered Mobile UI Card Stack Container (Real App Screen Mockup)
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 0,
                  child: Container(
                    height: 175,
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Back Layer Card Deck
                        Positioned(
                          top: 8,
                          child: Container(
                            width: 210,
                            height: 140,
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        // Middle Layer Card Deck
                        Positioned(
                          top: 16,
                          child: Container(
                            width: 235,
                            height: 140,
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        // Main Front Fixed Real-App Screen Mockup
                        Positioned(
                          top: 24,
                          left: 12,
                          right: 12,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18)),
                              border: Border.all(
                                color: widget.isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18)),
                              child: _PortfolioHomePageState
                                  .buildCustomUIMockupGraphic(
                                      widget.isDark, title),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Circular Arrow Button ↗ (Dark Button in Normal Idle state, Orange in Active state)
                Positioned(
                  right: 18,
                  bottom: 18,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: buttonBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.north_east_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
