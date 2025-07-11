import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/main_wrapper.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/widgets/custom_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _displayText = "";
  String _fullText = "";
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start typing animation after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _fullText = AppLocalizations.of(context)!.homeIntroText;
          _startTypingAnimation();
        });
      }
    });
  }

  void _startTypingAnimation() {
    const typingSpeed = Duration(milliseconds: 30);
    
    Timer.periodic(typingSpeed, (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _displayText = _fullText.substring(0, _textIndex + 1);
          _textIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFF0F8EEB),
                  Color(0xFF085085),
                ],
                stops: [0.37, 1.0],
              ),
            ),
          ),

          // Custom Header
          CustomHeader(
            title: s!.homeWelcomeTitle(User().name!),
            backgroundColor: Color(0xFFDAE1E7),
            textColor: Color(0xFF085085),
          ),

          // Animated Typing Text (no background container)
          Positioned(
            top: 200,
            left: 50,
            right: 50,
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 100),
                child: Text(
                  _displayText,
                  key: ValueKey<String>(_displayText),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),

          // Button Grid
          Positioned(
            top: 280,
            left: 40,
            right: 40,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 40,
              childAspectRatio: 1,
              children: [
                _buildMenuButton(
                  icon: Icons.monitor_heart,
                  label: s.homeMenuMonitoring,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 0)),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.tune,
                  label: s.homeMenuControlling,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 1)),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.person,
                  label: s.homeMenuAccount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 2)),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.menu_book,
                  label: s.homeMenuUserGuide,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 3)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF0F8EEB)),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F8EEB),
              ),
            ),
          ],
        ),
      ),
    );
  }
}