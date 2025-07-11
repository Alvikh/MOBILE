import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor; // Masih dipakai untuk ikon "Back"
  final VoidCallback? onBack;
  final double height;

  const CustomHeader({
    Key? key,
    required this.title,
    this.backgroundColor = const Color(0xFF1AB9BF),
    this.textColor = Colors.white,
    this.onBack,
    this.height = 180,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
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

          // Page Title with gradient text
          Positioned(
            top: 70,
            left: 30,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF085085), // Dark blue (kiri)
                    Color(0xFF085085), // Dark blue (kiri)
                    Color(0xFF085085), // Dark blue (kiri)
                    Color.fromARGB(255, 170, 217, 251), // Light blue (kanan)
                    Color.fromARGB(255, 170, 217, 251), // Light blue (kanan)
                    Color.fromARGB(255, 170, 217, 251), // Light blue (kanan)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
              },
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Masih dibutuhkan oleh ShaderMask
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
