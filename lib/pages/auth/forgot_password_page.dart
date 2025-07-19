import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/widgets/custom_bottom_container.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> 
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _footerAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Animated Header Background
              AnimatedBuilder(
                animation: _headerAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _headerAnimation.value),
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1AB9BF),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(
                        s.forgotPasswordTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Main Content
              Positioned(
                top: 180,
                bottom: 300,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s.forgotPasswordHeader,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        s.forgotPasswordDescription,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Animated Footer
              AnimatedBuilder(
                animation: _footerAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _footerAnimation.value),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: child,
                    ),
                  );
                },
                child: CustomBottomContainer(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                          label: "${s.emailLabel} *",
                          controller: emailController,
                        ),
                        const SizedBox(height: 25),
                        CustomElevatedButton(
                          text: s.send,
                          onPressed: () async {
                            final email = emailController.text.trim();

                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(s.emailRequired)),
                              );
                              return;
                            }

                            try {
                              final response = await ApiService().post(
                                ApiService().forgotPassword,
                                {'email': email},
                                useToken: false,
                              );

                              if (response['success'] == true) {
                                emailController.text = "";
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(s.linkSentSuccess)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response['message'] ?? 
                                      s.sendFailed),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${s.errorOccurred}: ${e.toString()}'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}