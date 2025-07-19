import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/main.dart';
import 'package:ta_mobile/pages/account/edit_profile_page.dart';
import 'package:ta_mobile/pages/account/email_verification_modal.dart';
import 'package:ta_mobile/pages/auth/change_password_page.dart';
import 'package:ta_mobile/pages/auth/forgot_password_page.dart';
import 'package:ta_mobile/pages/device/add_device_page.dart';
import 'package:ta_mobile/pages/device/device_list_page.dart';
import 'package:ta_mobile/services/email_verification_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!; // Add null check
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.accountSettings,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0A5099),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingsCard(
              context,
              title: s.profile,
              items: [
                _buildSettingsItem(
                  context,
                  icon: Icons.person_outline,
                  title: s.editProfile,
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
              title: s.device,
              items: [
                _buildSettingsItem(
                  context,
                  icon: Icons.add_circle_outline,
                  title: s.addDevice,
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
                  context,
                  icon: Icons.devices_other,
                  title: s.deviceList,
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
              title: s.security,
              items: [
                _buildSettingsItem(
                  context,
                  icon: Icons.lock_outline,
                  title: s.changePassword,
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
                  context,
                  icon: Icons.vpn_key_outlined,
                  title: s.forgotPassword,
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
            const SizedBox(height: 20),
            _buildSettingsCard(
              context,
              title: s.verifyEmail, // Use localized string
              items: [
                FutureBuilder(
                  future: UserPreferencesService().getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const ListTile(
                        leading: CircularProgressIndicator(),
                      );
                    }
                    
                    final user = snapshot.data;
                    final isVerified = user?.isEmailVerified ?? false;
                    
                    return _buildSettingsItem(
                      context,
                      icon: isVerified ? Icons.verified : Icons.email_outlined,
                      title: isVerified ? s.emailVerified : s.verifyEmail,
                      onTap: () async {
                        if (isVerified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(s.emailAlreadyVerified),
                              backgroundColor: Colors.green,
                            ),
                          );
                          return;
                        }

                        final verified = await showDialog<bool>(
                          context: context,
                          builder: (context) => const EmailVerificationModal(),
                        );
                        
                        if (verified == true) {
                          // Update local user data
                          final currentUser = await UserPreferencesService().getUser();
                          if (currentUser != null) {
                            await UserPreferencesService().saveUser(
                              currentUser.copyWith(
                                emailVerifiedAt: DateTime.now(),
                              ),
                            );
                          }
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(s.emailSuccessfullyVerified),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Refresh the UI
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.refresh,
                  title: s.resendCode, // Use localized string
                  onTap: () async {
                    final result = await EmailVerificationService.resendVerificationCode();
                    if (result['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? s.verificationCodeResent),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? s.failedToResendCode),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSettingsCard(
              context,
              title: s.language,
              items: [
                _buildLanguageItem(
                  context,
                  title: s.english,
                  locale: const Locale('en'),
                  currentLocale: currentLocale,
                  onTap: () => MyApp.setLocale(context, const Locale('en')),
                ),
                _buildLanguageItem(
                  context,
                  title: s.indonesian,
                  locale: const Locale('id'),
                  currentLocale: currentLocale,
                  onTap: () => MyApp.setLocale(context, const Locale('id')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context, {
    required String title,
    required Locale locale,
    required Locale currentLocale,
    required VoidCallback onTap,
  }) {
    final isSelected = locale.languageCode == currentLocale.languageCode;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(
        Icons.language,
        color: isSelected 
            ? const Color(0xFF0A5099) 
            : Colors.grey[600],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontFamily: 'Poppins',
          fontSize: 15,
          color: isSelected 
              ? const Color(0xFF0A5099) 
              : Colors.black,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: Color(0xFF0A5099),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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

  Widget _buildSettingsItem(
    BuildContext context, {
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