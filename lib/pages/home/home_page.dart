import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile/pages/account/account_page.dart';
import 'package:ta_mobile/pages/controlling/controlling_page.dart';
import 'package:ta_mobile/pages/guide/user_guide_page.dart';
import 'package:ta_mobile/pages/monitoring/monitoring_page.dart';
import 'package:ta_mobile/pages/partial/welcome_page.dart';
import 'package:ta_mobile/services/auth_service.dart';
import 'package:ta_mobile/services/mqtt_service.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
// import 'package:ta_mobile/widgets/custom_floating_navbar.dart';
import 'package:ta_mobile/widgets/custom_header.dart';

import '../../models/user.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Header with welcome message
//                 CustomHeader(
//                   title: "Welcome Home",
//                 ),

//                 // Main content
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Quick Access Section
//                       _buildSectionTitle("Quick Access"),
//                       const SizedBox(height: 15),
//                       _buildQuickAccessGrid(context),

//                       // Recent Activity Section
//                       const SizedBox(height: 30),
//                       _buildSectionTitle("Recent Activity"),
//                       const SizedBox(height: 15),
//                       _buildRecentActivityList(),

//                       // Energy Usage Section
//                       const SizedBox(height: 30),
//                       _buildSectionTitle("Energy Usage"),
//                       const SizedBox(height: 15),
//                       _buildEnergyUsageCard(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Floating Navbar
//           const CustomFloatingNavbar(selectedIndex: 0),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'Poppins',
//         color: Color(0xFF0A5099),
//       ),
//     );
//   }

//   Widget _buildQuickAccessGrid(BuildContext context) {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       crossAxisSpacing: 15,
//       mainAxisSpacing: 15,
//       childAspectRatio: 1.3,
//       children: [
//         _buildQuickAccessItem(
//           icon: Icons.devices,
//           title: "All Devices",
//           color: Colors.blue,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ControllingPage()),
//             );
//           },
//         ),
//         _buildQuickAccessItem(
//           icon: Icons.auto_awesome,
//           title: "Scenes",
//           color: Colors.purple,
//           onTap: () {
//             // Navigate to scenes page
//           },
//         ),
//         _buildQuickAccessItem(
//           icon: Icons.analytics,
//           title: "Statistics",
//           color: Colors.green,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MonitoringPage()),
//             );
//           },
//         ),
//         _buildQuickAccessItem(
//           icon: Icons.security,
//           title: "Security",
//           color: Colors.orange,
//           onTap: () {
//             // Navigate to security page
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickAccessItem({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(15),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   icon,
//                   size: 40,
//                   color: color,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentActivityList() {
//     final activities = [
//       {
//         "device": "Lampu Ruang Tamu",
//         "action": "Turned On",
//         "time": "2 mins ago"
//       },
//       {"device": "AC Kamar", "action": "Turned Off", "time": "15 mins ago"},
//       {"device": "Pompa Air", "action": "Turned On", "time": "1 hour ago"},
//       {"device": "TV", "action": "Turned Off", "time": "3 hours ago"},
//     ];

//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             for (var activity in activities)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         activity["action"]!.contains("On")
//                             ? Icons.power_settings_new
//                             : Icons.power_off,
//                         size: 20,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             activity["device"]!,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                           Text(
//                             activity["action"]!,
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       activity["time"]!,
//                       style: TextStyle(
//                         color: Colors.grey[500],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnergyUsageCard() {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Today's Energy Usage",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//             const SizedBox(height: 15),
//             LinearProgressIndicator(
//               value: 0.65,
//               backgroundColor: Colors.grey[200],
//               color: Colors.green,
//               minHeight: 10,
//               borderRadius: BorderRadius.circular(5),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "65% of daily limit",
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//                 Text(
//                   "3.2 kWh",
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildEnergyMetric("Devices On", "4", Colors.blue),
//                 _buildEnergyMetric("Cost", "\$0.42", Colors.green),
//                 _buildEnergyMetric("Savings", "12%", Colors.orange),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnergyMetric(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: color,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            title: "Welcome\n${User().name}!",
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
                MqttService().disconnect();
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
