import 'package:flutter/material.dart';
import 'package:ta_mobile/services/auth_service.dart';
import 'package:ta_mobile/widgets/custom_bottom_container.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';
import 'package:ta_mobile/widgets/custom_header.dart';
import 'account_information_page.dart';
import 'sign_in_page.dart';
import '../partial/welcome_page.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomHeader(
            title: "Sign Up",
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
                ),
                SizedBox(height: 15),
                CustomTextField(
                  label: "Password *",
                  isPassword: true,
                  controller: passwordController,
                ),
                SizedBox(height: 15),
                CustomTextField(
                  label: "Confirm Password *",
                  isPassword: true,
                  controller: confirmPasswordController,
                ),
                SizedBox(height: 30),

                // Next Button
                CustomElevatedButton(
                  text: "Next",
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final confirmPassword =
                        confirmPasswordController.text.trim();

                    if (email.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      // Tampilkan pesan error ke user
                      print("All fields required");
                      return;
                    }

                    if (password != confirmPassword) {
                      print("Passwords do not match");
                      return;
                    }

                    final result = await AuthService.signUp(email, password, confirmPassword);
                    print(result);

                    if (result['success']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountInformationPage()),
                      );
                    } else {
                      // Tampilkan pesan dari backend
                      print(result['message']);
                    }
                  },
                ),

                SizedBox(height: 10),

                // Already have an account? Sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(color: Colors.white)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text("Sign in",
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
