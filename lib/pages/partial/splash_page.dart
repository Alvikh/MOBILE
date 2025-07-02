import 'package:flutter/material.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

import 'welcome_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await UserPreferencesService().isLoggedIn();
    debugPrint('User login status: $isLoggedIn');

    if (!isLoggedIn) {
      _navigateToWelcomePage();
      return;
    }

    try {
      // Get the saved auth token
      final authToken = await UserPreferencesService().getAuthToken();
      if (authToken == null) {
        debugPrint('No auth token found');
        await _clearAndNavigateToWelcome();
        return;
      }

      // Set the token for API calls
      await ApiService().setToken(authToken);

      // Fetch the latest user data from API
      final response = await ApiService().get('/user', useToken: true);

      if (response['success'] == true && response['user'] != null) {
        // Update local user data with fresh data from server
        final updatedUser = User.fromMap(response['user']);
        await UserPreferencesService().saveUser(updatedUser);

        // Navigate to home page with fresh data
        _navigateToHomePage();
      } else {
        debugPrint('Failed to fetch user data: ${response['message']}');
        await _clearAndNavigateToWelcome();
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      await _clearAndNavigateToWelcome();
    }
  }

// Helper methods
  void _navigateToHomePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  void _navigateToWelcomePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });
  }

  Future<void> _clearAndNavigateToWelcome() async {
    await UserPreferencesService().clearUserData();
    _navigateToWelcomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
