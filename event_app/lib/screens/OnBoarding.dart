// lib/screens/OnBoarding.dart
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  int _page = 0;

  final List<_OnboardPageData> _pages = [
    _OnboardPageData(
      color1: Color(0xFF6C63FF),
      color2: Color(0xFF00C6FF),
      icon: Icons.explore,
      title: "Discover Places",
      subtitle:
          "Explore the best events and places around you. Personalized recommendations tailored for you.",
    ),
    _OnboardPageData(
      color1: Color(0xFFFF7A7A),
      color2: Color(0xFFFFD56B),
      icon: Icons.group,
      title: "Meet People",
      subtitle:
          "Connect with others who share your interests. Join groups and attend meetup events easily.",
    ),
    _OnboardPageData(
      color1: Color(0xFF4DE0B2),
      color2: Color(0xFF1FA2FF),
      icon: Icons.calendar_today,
      title: "Never Miss Out",
      subtitle:
          "Get reminders, manage your schedule and keep track of your favorite events with ease.",
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  void _skip() {
    _pageController.animateToPage(_pages.length - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  void _finish() {
    // Replace with your app's logic. For demo, navigate to a simple HomeScreen.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const _HomeScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_pages.length, (index) {
        final bool active = index == _page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background gradient depends on current page for a smoother feel
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _pages[_page].color1,
                  _pages[_page].color2,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top navigation: Skip
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _skip,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (_, index) {
                      final p = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Decorative card with icon
                            Container(
                              height: size.height * 0.38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.95),
                                        Colors.white70
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 12,
                                        offset: Offset(0, 8),
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Icon(
                                    p.icon,
                                    size: 92,
                                    color: p.color2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              p.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              p.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom controls: indicators and next button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIndicator(),
                      ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          foregroundColor: _pages[_page].color1,
                          elevation: 6,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _page == _pages.length - 1
                                  ? "Get Started"
                                  : "Next",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _pages[_page].color1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _page == _pages.length - 1
                                  ? Icons.check
                                  : Icons.arrow_forward,
                              color: _pages[_page].color1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPageData {
  final Color color1;
  final Color color2;
  final IconData icon;
  final String title;
  final String subtitle;

  _OnboardPageData({
    required this.color1,
    required this.color2,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event App'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Event App',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
