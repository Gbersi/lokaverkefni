import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const AnimatedButton({super.key, required this.label, required this.onPressed});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isPressed ? 150 : 160,
        height: _isPressed ? 50 : 60,
        decoration: BoxDecoration(
          color: _isPressed ? Colors.blueAccent : Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
