import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/pages/account/settings_page.dart';
import 'package:ta_mobile/widgets/custom_floating_navbar.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Profile
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0A5099),
                        const Color(0xFF2196F3),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A5099).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: User().profilePhotoPath != null
                                  ? ClipOval(
                                      child: Image.network(
                                        User().profilePhotoPath.toString(),
                                        width: 95,
                                        height: 95,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey[600],
                                    ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Color(0xFF0A5099),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          User().name ?? s.nameLabel,
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          User().email ?? s.email,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // User Details Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(s.accountInformation),
                      _buildDetailItem(s.userId, User().id?.toString() ?? '-'),
                      _buildDetailItem(s.role, User().role ?? '-'),
                      _buildDetailItem(s.status, User().status ?? '-'),
                      _buildDetailItem(s.phone, User().phone?.toString() ?? '-'),
                      _buildDetailItem(s.address, User().address?.toString() ?? '-'),
                      const SizedBox(height: 20),
                      _buildSectionTitle(s.systemInformation),
                      _buildDetailItem(
                        s.verifiedEmail,
                        User().emailVerifiedAt != null ? s.already : s.notYet,
                      ),
                      _buildDetailItem(s.lastLogin, User().lastLoginAt?.toString() ?? '-'),
                      _buildDetailItem(s.madeIn, User().createdAt?.toLocal().toString() ?? '-'),
                      _buildDetailItem(s.updatedOn, User().updatedAt?.toLocal().toString() ?? '-'),
                      const SizedBox(height: 30),
                      _buildSettingsButton(context, s),
                      const SizedBox(height: 15),
                      _buildLogoutButton(context, s),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const CustomFloatingNavbar(selectedIndex: 3),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A5099),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': ',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              )),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, AppLocalizations s) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.settings, size: 20),
        label: Text(
          s.accountSettings,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0A5099),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations s) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout, size: 20),
        label: Text(
          s.logout,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: () => _showLogoutDialog(context, s),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            s.logoutConfirmationTitle,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          content: Text(
            s.logoutConfirmationMessage,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              child: Text(
                s.cancel,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            TextButton(
              child: Text(
                s.confirmLogout,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () {
                // Handle logout logic
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}