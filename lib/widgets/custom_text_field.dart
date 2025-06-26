import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Color labelColor;
  final Color textColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color iconColor;
  final IconData? prefixIcon;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.maxLines = 1,
    this.labelColor = Colors.grey,
    this.textColor = Colors.black87,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.green,
    this.iconColor = Colors.grey,
    this.prefixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      style: TextStyle(color: widget.textColor),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.labelColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.focusedBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: widget.iconColor)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: widget.iconColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
    );
  }
}
