import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatelessWidget {
  const CustomLoadingScreen({Key? key}) : super(key: key);

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
            // App Logo or Icon
            Icon(
              Icons.electric_bolt,
              size: 80,
              color: Colors.white,
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