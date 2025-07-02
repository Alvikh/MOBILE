import 'package:flutter/material.dart';
import 'package:ta_mobile/pages/auth/sign_in_page.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/routes.dart';

import 'pages/partial/splash_page.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WelcomePage(), // Tampilan awal ke WelcomePage
//     );
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Power Management',
      routes: {
        AppRoutes.login: (context) => SignInPage(),
        AppRoutes.home: (context) => HomePage(),
      },
      home: SplashPage(), // ganti jadi SplashPage
    );
  }
}
