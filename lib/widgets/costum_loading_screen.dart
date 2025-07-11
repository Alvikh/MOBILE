import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatefulWidget {
  const CustomLoadingScreen({Key? key}) : super(key: key);

  @override
  State<CustomLoadingScreen> createState() => _CustomLoadingScreenState();
}

class _CustomLoadingScreenState extends State<CustomLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 1.0, end: 0.3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF0F8EEB),
              Color(0xFF085085),
            ],
            stops: [0.37, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Blinking Image Logo
            AnimatedBuilder(
              animation: _opacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacity.value,
                  child: Image.asset(
                    'assets/ICON.png',
                    width: 80,
                    height: 80,
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            // Loading Text
            Text(
              'Memuat...',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),

            // Custom Loading Indicator
            Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Color(0xFF0F8EEB).withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
