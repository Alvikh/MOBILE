import 'package:flutter/material.dart';
import 'package:ta_mobile/pages/account/account_page.dart';
import 'package:ta_mobile/pages/controlling/controlling_page.dart';
import 'package:ta_mobile/pages/guide/user_guide_page.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/pages/monitoring/monitoring_page.dart';

class CustomFloatingNavbar extends StatelessWidget {
  final int selectedIndex;

  const CustomFloatingNavbar({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0, context, HomePage()),
            _buildNavItem(Icons.monitor_heart, "Monitoring", 1, context,
                MonitoringPage()),
            _buildNavItem(
                Icons.tune, "Controlling", 2, context, ControllingPage()),
            _buildNavItem(Icons.person, "Account", 3, context, AccountPage()),
            _buildNavItem(
                Icons.menu_book, "Guide", 4, context, UserGuidePage()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      BuildContext context, Widget? page) {
    return GestureDetector(
        onTap: () {
          if (page != null && selectedIndex != index) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            icon,
            color: selectedIndex == index ? Color(0xFF085085) : Colors.white,
            size: 30,
          ),
        ]));
  }
}
