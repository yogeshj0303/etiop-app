import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuidelineScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const GuidelineScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<GuidelineScreen> createState() => _GuidelineScreenState();
}

class _GuidelineScreenState extends State<GuidelineScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _iconAnimController;
  late Animation<double> _iconScaleAnim;

  final List<_GuidelinePageData> _pages = [
    _GuidelinePageData(
      icon: Icons.home,
      title: 'Home',
      description:
          'Discover shops, services, and sponsored businesses. Search for businesses and browse categories.',
    ),
    _GuidelinePageData(
      icon: Icons.category,
      title: 'Business & Categories',
      description:
          'Browse businesses by category. Explore subcategories and detailed shop information.',
    ),
    _GuidelinePageData(
      icon: Icons.local_offer,
      title: 'Offers & Discounts',
      description: 'View current offers, discounts, and sponsored promotions.',
    ),
    _GuidelinePageData(
      icon: Icons.person,
      title: 'Profile',
      description:
          'Manage your personal information and preferences. View your registered businesses and order history.',
    ),
    _GuidelinePageData(
      icon: Icons.add_business,
      title: 'Create Your Business',
      description:
          'Easily register your own shop or business in Etiop. Tap the "+" button on the main screen to get started and reach more customers!',
    ),
    _GuidelinePageData(
      icon: Icons.subscriptions,
      title: 'Subscription',
      description:
          'Register your business and manage subscriptions. Access premium features and analytics.',
    ),
    _GuidelinePageData(
      icon: Icons.notifications,
      title: 'Notifications',
      description: 'Stay updated with important alerts and updates.',
    ),
    _GuidelinePageData(
      icon: Icons.support_agent,
      title: 'Support',
      description:
          'Get help and contact customer support directly from the app.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _iconScaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _iconAnimController, curve: Curves.elasticOut),
    );
    _iconAnimController.forward();
    _pageController.addListener(() {
      _iconAnimController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _iconAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = const Color(0xFFFA2742); // Use your brand color
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Column(
            children: [
              // Top Row: Logo + Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/app_logo.jpg',
                    width: 48,
                    height: 48,
                  ),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.poppins(
                        color: brandColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: PageView.builder(
                  scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false, overscroll: false, physics: const NeverScrollableScrollPhysics()),
                  clipBehavior: Clip.none,
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    _iconAnimController.forward(from: 0.0);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _iconScaleAnim,
                          builder: (context, child) => Transform.scale(
                            scale: _iconScaleAnim.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: brandColor.withOpacity(0.08),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: brandColor.withOpacity(0.18),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(32),
                              child: Icon(
                                page.icon,
                                size: 64,
                                color: brandColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          page.title,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: brandColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          page.description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Modern progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final isActive = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? brandColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: brandColor.withOpacity(0.18),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _prevPage,
                      child: Text('Back',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: brandColor)),
                    )
                  else
                    const SizedBox(width: 64),
                  if (_currentPage < _pages.length - 1)
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: brandColor.withOpacity(0.18),
                      ),
                      child: Text('Next',
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.white)),
                    )
                  else
                    ElevatedButton(
                      onPressed: widget.onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: brandColor.withOpacity(0.18),
                      ),
                      child: Text('Get Started',
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.white)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidelinePageData {
  final IconData icon;
  final String title;
  final String description;
  _GuidelinePageData(
      {required this.icon, required this.title, required this.description});
} 