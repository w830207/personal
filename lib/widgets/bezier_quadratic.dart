import 'package:flutter/material.dart';
import 'dart:math';

class BezierQuadratic extends StatefulWidget {
  final String imageAsset;

  ///貝茲二階曲線動畫範例組件
  const BezierQuadratic({
    Key? key,
    required this.imageAsset,
  }) : super(key: key);

  @override
  _BezierQuadraticState createState() => _BezierQuadraticState();
}

class _BezierQuadraticState extends State<BezierQuadratic>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        child: Image.asset(
          widget.imageAsset,
          width: 50,
        ),
        animation: animation,
        builder: (context, child) {
          double x0 = 100.0;
          double y0 = 100.0;

          double x2 = 1000.0;
          double y2 = 800.0;

          double x1 = (x0 + x2) * 0.7;
          double y1 = y0 - 80;

          return Transform.translate(
            offset: Offset(
                pow(1 - animation.value, 2) * x0 +
                    2 * animation.value * (1 - animation.value) * x1 +
                    pow(animation.value, 2) * x2,
                pow(1 - animation.value, 2) * y0 +
                    2 * animation.value * (1 - animation.value) * y1 +
                    pow(animation.value, 2) * y2),
            child: child,
          );
        });
  }
}
