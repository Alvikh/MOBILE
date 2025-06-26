import 'package:flutter/material.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/widgets/custom_bottom_container.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang diperbarui
      body: Stack(
        children: [
          // Background Top Circle
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFF1AB9BF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 50), // Menyesuaikan posisi teks
                child: Center(
                  child: Text(
                    "Forgot Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Container
          CustomBottomContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Perbaikan di sini
              children: [
                // Forgot Password Info Text
                Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Pastikan tetap center
                ),
                SizedBox(height: 25),
                Text(
                  "We will send a link to reset your password to your email.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 35),

                CustomTextField(
                  label: "Email *",
                  controller: emailController,
                ),
                SizedBox(height: 25),

                // Send Button
                CustomElevatedButton(
                  text: "Send",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
