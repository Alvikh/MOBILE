import 'package:flutter/material.dart';

class CustomBottomContainer extends StatelessWidget {
  final Widget child;
  final double height;

  const CustomBottomContainer({
    Key? key,
    required this.child,
    this.height = 500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Color(0xFF084A83),
          borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: child,
      ),
    );
  }
}
