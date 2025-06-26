import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onBack;
  final double height; // Added height parameter

  const CustomHeader({
    Key? key,
    required this.title,
    this.backgroundColor = const Color(0xFF1AB9BF),
    this.textColor = Colors.white,
    this.onBack,
    this.height = 180, // Default height that fits your design
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, // Constrain the Stack with explicit height
      child: Stack(
        clipBehavior: Clip.none, // Allows elements to overflow visually
        children: [
          // Background Circle
          Positioned(
            left: -50,
            top: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Back Button
          if (onBack != null)
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: onBack!,
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: textColor),
                    const SizedBox(width: 5),
                    Text(
                      "Back",
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // Page Title
          Positioned(
            top: 70,
            left: 30,
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold, // Added for better visibility
              ),
            ),
          ),
        ],
      ),
    );
  }
}
