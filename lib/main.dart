// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ta_mobile/pages/auth/sign_in_page.dart';
// import 'package:ta_mobile/pages/home/home_page.dart';
// import 'package:ta_mobile/routes.dart';

// import 'pages/partial/splash_page.dart';

// void main() {
//   runApp(
//     ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Smart Power Management',
//       routes: {
//         AppRoutes.login: (context) => SignInPage(),
//         AppRoutes.home: (context) => HomePage(),
//       },
//       home: SplashPage(), // ganti jadi SplashPage
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/main_wrapper.dart';
import 'package:ta_mobile/pages/auth/sign_in_page.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/pages/partial/splash_page.dart';
import 'package:ta_mobile/routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale(); // panggil saat app mulai
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  Future<void> setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      debugShowCheckedModeBanner: false,
      title: 'Smart Power Management',
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (_locale != null) return _locale;
        if (locale == null) return supportedLocales.first;
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      routes: {
        AppRoutes.login: (context) => SignInPage(),
        AppRoutes.home: (context) => const HomePage(),
    '/main': (context) {
      final index = ModalRoute.of(context)!.settings.arguments as int? ?? 0;
      return MainWrapper(initialIndex: index);
    }},

      home: const SplashPage(),
    );
  }
}
