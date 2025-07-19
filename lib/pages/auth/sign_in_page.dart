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

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _circleAnimation;
  late Animation<double> _footerAnimation;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
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
                title: "Sign In",
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
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: "Password *",
                        isPassword: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password Button
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

                      const SizedBox(height: 20),

                      // Sign In Button
                      CustomElevatedButton(
                        text: "Sign in",
                        onPressed: () async {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text("Email and password cannot be empty."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text("Invalid email format."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (password.length < 6) {
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text("Password must be at least 6 characters."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

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

                      const SizedBox(height: 10),

                      // Sign Up Link
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}