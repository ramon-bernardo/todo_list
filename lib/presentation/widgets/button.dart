import 'package:flutter/material.dart';

final class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Color? backgroundColor;
  final bool disabled;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.iconColor = const Color(0xFF424242),
    this.textColor = const Color(0xFF424242),
    this.backgroundColor,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: backgroundColor,
        elevation: 1,
      ),
      onPressed: disabled ? null : onPressed,
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, color: iconColor, size: 18),
          Text(text, style: TextStyle(color: textColor, fontSize: 14)),
        ],
      ),
    );
  }
}
