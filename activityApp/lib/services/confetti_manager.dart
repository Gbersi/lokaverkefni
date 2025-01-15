import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiManager extends StatefulWidget {
  final bool shouldShow;
  final Alignment alignment;
  final Duration duration;

  const ConfettiManager({
    super.key,
    required this.shouldShow,
    this.alignment = Alignment.topCenter,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _ConfettiManagerState createState() => _ConfettiManagerState();
}

class _ConfettiManagerState extends State<ConfettiManager> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);

    if (widget.shouldShow) {
      _controller.play();
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldShow) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [Colors.red, Colors.blue, Colors.green, Colors.orange],
      ),
    );
  }
}
