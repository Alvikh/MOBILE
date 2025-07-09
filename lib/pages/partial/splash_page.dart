import 'package:flutter/material.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/mqtt_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';
import 'package:ta_mobile/widgets/costum_loading_screen.dart';

import 'welcome_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late MqttService _mqttService;

  @override
  void dispose() {
    // _mqttService.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService(onConnectionStatusChanged: (status) {
      debugPrint('MQTT Connection Status from SplashPage: $status');
    }, onMessageReceived: (message) {
      debugPrint('MQTT Message received from SplashPage: $message');
    });
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
      User? user = await UserPreferencesService().getUser();
      if (user == null) {
        debugPrint('No user data found');
        await _clearAndNavigateToWelcome();
        return;
      }
      final response = await ApiService().post(
        '/user',
        {'user_id': user.id},
        useToken: true,
      );
      print('Response from user endpoint: $response');
      if (response['success'] == true && response['data']['user'] != null) {
        // Update local user data with fresh data from server
        final updatedUser = User.fromMap(response['data']['user']);
        await UserPreferencesService().saveUser(updatedUser);
        debugPrint('User data validated. Attempting MQTT connection...');
        bool mqttConnected =
            await _mqttService.connect(); // Panggil koneksi MQTT

        if (mqttConnected) {
          debugPrint('MQTT connected successfully. Navigating to Home Page.');
          _navigateToHomePage(); // Navigasi hanya jika MQTT berhasil
        } else {
          debugPrint('Failed to connect to MQTT. Navigating to Welcome Page.');
          await _clearAndNavigateToWelcome(); // Arahkan ke welcome jika MQTT gagal
        }
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
      body: Center(child: CustomLoadingScreen()),
    );
  }
}
