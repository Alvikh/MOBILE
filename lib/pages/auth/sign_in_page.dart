// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_mobile/pages/home/home_page.dart';
// import 'package:ta_mobile/services/auth_service.dart';
// import 'package:ta_mobile/widgets/custom_bottom_container.dart';
// import 'package:ta_mobile/widgets/custom_elevated_button.dart';
// import 'package:ta_mobile/widgets/custom_header.dart';
// import 'package:ta_mobile/widgets/custom_text_field.dart';

// import '../partial/welcome_page.dart';
// import 'forgot_password_page.dart';
// import 'sign_up_page.dart';

// class SignInPage extends StatelessWidget {
//   SignInPage({Key? key}) : super(key: key);

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Menggunakan CustomHeader dengan tombol back yang mengarah ke WelcomePage
//           CustomHeader(
//             title: "Sign In",
//             onBack: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => WelcomePage()),
//               );
//             },
//           ),

//           // Bottom Container
//           CustomBottomContainer(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomTextField(
//                   label: "Email *",
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 SizedBox(height: 15),
//                 CustomTextField(
//                   label: "Password *",
//                   isPassword: true, // This enables the eye icon toggle
//                   controller: passwordController,
//                 ),
//                 SizedBox(height: 10),

//                 // Forgot Password Button
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ForgotPasswordPage()),
//                       );
//                     },
//                     child: Text(
//                       "Forgot Password?",
//                       style: TextStyle(
//                         color: Colors.yellow,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 20),

//                 // Sign In Button
//                 CustomElevatedButton(
//                   text: "Sign in",
//                   onPressed: () async {
//                     final result = await AuthService.signIn(
//                       emailController.text.trim(),
//                       passwordController.text.trim(),
//                     );

//                     if (result['success']) {
//                       // ✅ Simpan status login
//                       final prefs = await SharedPreferences.getInstance();
//                       await prefs.setBool('isLoggedIn', true);

//                       // Login sukses → pindah ke HomePage
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                       );
//                     } else {
//                       // Login gagal → tampilkan pesan kesalahan
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(result['message'])),
//                       );
//                     }
//                   },
//                 ),

//                 SizedBox(height: 10),

//                 // Don't have an account yet? Sign Up
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Don't have an account yet? ",
//                         style: TextStyle(color: Colors.white)),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SignUpPage()),
//                         );
//                       },
//                       child: Text("Sign up",
//                           style: TextStyle(
//                               color: Colors.yellow,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/services/auth_service.dart';
import 'package:ta_mobile/widgets/custom_bottom_container.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
import 'package:ta_mobile/widgets/custom_header.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';

import '../partial/welcome_page.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: Stack(
          children: [
            // Header dengan tombol kembali ke halaman Welcome
            CustomHeader(
              title: "Sign In",
              onBack: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
            ),

            // Konten bawah
            CustomBottomContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    label: "Email *",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    label: "Password *",
                    isPassword: true,
                    controller: passwordController,
                  ),
                  SizedBox(height: 10),

                  // Tombol Lupa Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Tombol Sign In
                  CustomElevatedButton(
                    text: "Sign in",
                    onPressed: () async {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      // Validasi input kosong
                      if (email.isEmpty || password.isEmpty) {
                        scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Text("Email dan password tidak boleh kosong."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Validasi format email
                      if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                          .hasMatch(email)) {
                        scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Text("Format email tidak valid."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Validasi panjang password
                      if (password.length < 6) {
                        scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Text("Password minimal 6 karakter."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Proses login
                      final result = await AuthService.signIn(email, password);

                      if (result['success']) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Text(result['message']),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 10),

                  // Tautan ke halaman Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account yet? ",
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text("Sign up",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
