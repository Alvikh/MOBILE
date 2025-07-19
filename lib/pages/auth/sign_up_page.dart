import 'package:flutter/material.dart';
import 'package:ta_mobile/services/auth_service.dart';
import 'package:ta_mobile/widgets/custom_bottom_container.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
import 'package:ta_mobile/widgets/custom_header.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';

import '../partial/welcome_page.dart';
import 'account_information_page.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _circleAnimation;
  late Animation<double> _footerAnimation;
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Header slides down
    _headerAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Circle scales up from top-left
    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Footer slides up
    _footerAnimation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated circle from top-left
          Positioned(
            top: -50,
            left: -50,
            child: AnimatedBuilder(
              animation: _circleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _circleAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1AB9BF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                );
              },
            ),
          ),

          // Animated Header
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _headerAnimation.value),
                child: child,
              );
            },
            child: CustomHeader(
              title: "Sign Up",
              onBack: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
            ),
          ),

          // Animated Footer
          AnimatedBuilder(
            animation: _footerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _footerAnimation.value+10),
                child: child,
              );
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      label: "Email *",
                      controller: emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Password *",
                      isPassword: true,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Confirm Password *",
                      isPassword: true,
                      controller: confirmPasswordController,
                    ),
                    const SizedBox(height: 30),

                    // Next Button
                    CustomElevatedButton(
                      text: "Next",
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final confirmPassword = confirmPasswordController.text.trim();

                        if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("All fields are required"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Passwords do not match"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final result = await AuthService.signUp(email, password, confirmPassword);

                        if (result['success']) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AccountInformationPage()),
                          );
                        } else {
                          final errorMessage = result['message'] ?? 'An error occurred';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.fixed,
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 10),

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
            ),
          ),
        ],
      ),
    );
  }
}