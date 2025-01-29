import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? borderColor; // New parameter for border color
  final Color? textColor; // New parameter for text color
  final double? width;
  final double? height;
  final IconData? icon; // Icon parameter for additional flexibility

  const AnimatedButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width ?? 150,
        height: height ?? 50,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          border: Border.all(color: borderColor ?? Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor ?? Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
