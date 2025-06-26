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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Menggunakan CustomHeader dengan tombol back yang mengarah ke WelcomePage
          CustomHeader(
            title: "Sign In",
            onBack: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
              );
            },
          ),

          // Bottom Container
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
                  isPassword: true, // This enables the eye icon toggle
                  controller: passwordController,
                ),
                SizedBox(height: 10),

                // Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
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

                // Sign In Button
                CustomElevatedButton(
                  text: "Sign in",
                  onPressed: () async {
                    final result = await AuthService.signIn(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (result['success']) {
                      // ✅ Simpan status login
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);

                      // Login sukses → pindah ke HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      // Login gagal → tampilkan pesan kesalahan
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'])),
                      );
                    }
                  },
                ),

                SizedBox(height: 10),

                // Don't have an account yet? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account yet? ",
                        style: TextStyle(color: Colors.white)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
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
    );
  }
}
