import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile/pages/partial/welcome_page.dart';
import 'package:ta_mobile/services/auth_service.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
import 'package:ta_mobile/widgets/custom_header.dart';

import 'account/account_page.dart';
import 'controlling/controlling_page.dart';
import 'guide/user_guide_page.dart';
import 'monitoring/monitoring_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title: "Welcome\nAlvi!",
            backgroundColor: Color(0xFFDAE1E7),
            textColor: Color(0xFF085085),
          ),

          // Centered Text with top padding
          Positioned(
            top: 200, // Jarak dari atas
            left: 50,
            right: 40,
            child: Center(
              child: Text(
                "Let's start stabilizing our power output!",
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
              crossAxisCount: 2, // Dua kolom
              mainAxisSpacing: 40,
              crossAxisSpacing: 40,
              childAspectRatio: 1, // Membuat kotak seimbang
              children: [
                _buildMenuButton(
                  icon: Icons.monitor_heart,
                  label: "Monitoring",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MonitoringPage()),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.tune,
                  label: "Controlling",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ControllingPage()),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.person,
                  label: "Account",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.menu_book,
                  label: "User Guide",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserGuidePage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Tombol Logout di bagian bawah
          Positioned(
            bottom: 40, // Atur jarak dari bawah
            left: 40,
            right: 40,
            child: CustomElevatedButton(
              text: "Log out",
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var response = await AuthService.logout();
                if (response['success'] == true) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                    (route) => false, // Hapus semua halaman sebelumnya
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response['message'] ?? "Logout failed"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk tombol menu
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
