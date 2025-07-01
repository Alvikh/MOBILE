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
    print(isLoggedIn);
    if (isLoggedIn) {
      final user = await UserPreferencesService().getUser();
      if (user != null) {
        User() = user;
        final authToken = await UserPreferencesService().getAuthToken();
        if (authToken != null) {
          await ApiService().setToken(authToken);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Handle the case where authToken is null, e.g., log out or show error
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomePage()),
          );
        }
      } else {
        // Handle the case where user is null, e.g., log out or show error
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
