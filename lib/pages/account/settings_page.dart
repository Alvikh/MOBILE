import 'package:flutter/material.dart';
import 'package:ta_mobile/pages/account/edit_profile_page.dart';
import 'package:ta_mobile/pages/auth/change_password_page.dart';
import 'package:ta_mobile/pages/auth/forgot_password_page.dart';
import 'package:ta_mobile/pages/device/add_device_page.dart';
import 'package:ta_mobile/pages/device/device_list_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Pengaturan Akun',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0A5099),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSettingsCard(
                  context,
                  title: 'Profil',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profil',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSettingsCard(
                  context,
                  title: 'Perangkat',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.add_circle_outline,
                      title: 'Tambah Perangkat',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddDevicePage(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.devices_other,
                      title: 'Daftar Perangkat',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeviceListPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSettingsCard(
                  context,
                  title: 'Keamanan',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.lock_outline,
                      title: 'Ubah Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.vpn_key_outlined,
                      title: 'Lupa Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const CustomFloatingNavbar(selectedIndex: 3),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0A5099),
                ),
              ),
            ),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(
        icon,
        color: const Color(0xFF0A5099),
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          fontSize: 15,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
