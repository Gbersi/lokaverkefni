import 'package:flutter/material.dart';

class ScalableTextWidget extends StatelessWidget {
  final Widget child;

  const ScalableTextWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);


    final double scaleFactor = mediaQuery.size.width < 360 ? 0.9 : 1.0;

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: TextScaler.linear(scaleFactor),
      ),
      child: child,
    );
  }
}
