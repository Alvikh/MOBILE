import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ta_mobile/pages/account/account_page.dart';
import 'package:ta_mobile/pages/controlling/controlling_page.dart';
import 'package:ta_mobile/pages/guide/user_guide_page.dart';
import 'package:ta_mobile/pages/monitoring/monitoring_page.dart';
import 'package:ta_mobile/widgets/custom_floating_navbar.dart';

class MainWrapper extends StatefulWidget {
  final int initialIndex;
  
  const MainWrapper({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late final PageController _pageController;
  late int _currentIndex;
  bool _isPageViewScrolling = false;
  double _navbarOffset = 0;

  final List<Widget> _pages = const [
    MonitoringPage(),
    ControllingPage(),
    AccountPage(),
    UserGuidePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView Content
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is UserScrollNotification) {
                setState(() {
                  _isPageViewScrolling = notification.metrics.axis == Axis.horizontal;
                  // Calculate offset based on scroll direction
                  if (notification.direction == ScrollDirection.forward) {
                    _navbarOffset = 0; // Fully visible when scrolling down
                  } else if (notification.direction == ScrollDirection.reverse) {
                    _navbarOffset = 10; // Slightly raised when scrolling up
                  }
                });
              }
              return false;
            },
            child: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) {
                if (!_isPageViewScrolling) return;
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _pages,
            ),
          ),

          // Floating Navbar - Now always visible but with subtle animation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left: 20,
            right: 20,
            bottom: 20 + _navbarOffset, // Small offset effect during scroll
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 1, // Always fully visible
              child: Transform.translate(
                offset: Offset(0, _navbarOffset * -0.5), // Subtle parallax effect
                child: CustomFloatingNavbar(
                  selectedIndex: _currentIndex,
                  onItemSelected: (index) {
                    if (_currentIndex != index) {
                      setState(() {
                        _currentIndex = index;
                        _navbarOffset = 0; // Reset offset when item selected
                      });
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}