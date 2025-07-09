import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/main_wrapper.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/widgets/custom_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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

          // Centered Text with top padding
          Positioned(
            top: 200,
            left: 50,
            right: 40,
            child: Center(
              child: Text(
                s.homeIntroText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 0,)),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.tune,
                  label: s.homeMenuControlling,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 1,)),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.person,
                  label: s.homeMenuAccount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 2,)),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.menu_book,
                  label: s.homeMenuUserGuide,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainWrapper(initialIndex: 3,)),
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