import 'dart:async';
import 'package:flutter/material.dart';
import 'ani.dart';
import 'my_clipper.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key, required this.screenWidth}) : super(key: key);
  final double screenWidth;

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar>
    with TickerProviderStateMixin {
  bool visible = false;
  late Offset left;
  late Offset right;
  late Offset from;
  late Offset to;
  bool leftSelected = true;
  late AnimationController aniControllerLeft;
  late AnimationController aniControllerRight;
  late Animation<double> aniLeft;
  late Animation<double> aniRight;

  double inRtoL(AnimationController ani) {
    if (ani.isAnimating) {
      return ani.value <= 0.5 ? 50 - ani.value * 100 : 0.0;
    }
    return 0.0;
  }

  double inLtoR(AnimationController ani) {
    if (ani.isAnimating) {
      return ani.value <= 0.5 ? ani.value * 100 - 50 : 0.0;
    }
    return 0.0;
  }

  double outLtoR(AnimationController ani) {
    if (ani.isAnimating) {
      return ani.value <= 0.5 ? ani.value * 100 : 50.0;
    }
    return 50.0;
  }

  double outRtoL(AnimationController ani) {
    if (ani.isAnimating) {
      return ani.value <= 0.5 ? ani.value * -100 : -50.0;
    }
    return -50.0;
  }

  @override
  void initState() {
    left = const Offset(50, 50);
    right = Offset(widget.screenWidth - 50, 50);
    from = left;
    to = right;
    aniControllerLeft = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    aniControllerRight = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    aniLeft = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween(begin: 1, end: 1.1), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 1.1, end: 1), weight: 1),
    ]).animate(aniControllerLeft);
    aniRight = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween(begin: 1, end: 1.1), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 1.1, end: 1), weight: 1),
    ]).animate(aniControllerRight);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD6D6D6),
            blurRadius: 8,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        height: 100,
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: left.dx - 25,
              child: GestureDetector(
                onTap: () {
                  if (leftSelected == false) {
                    setState(() {
                      visible = false;
                      from = right;
                      to = left;
                    });
                    Timer(const Duration(milliseconds: 100), () {
                      setState(() {
                        visible = true;
                      });
                    });
                    Timer(const Duration(milliseconds: 600), () {
                      setState(() {
                        leftSelected = true;
                        aniControllerLeft.reset();
                        aniControllerLeft.forward();
                      });
                    });
                  }
                },
                child: AnimatedBuilder(
                  animation: leftSelected ? aniLeft : aniRight,
                  builder: (context, _) {
                    return ScaleTransition(
                      scale: aniLeft,
                      child: ClipOval(
                        child: Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              color: Colors.blue,
                            ),
                            ClipOval(
                              clipper: MyClipper(
                                width: 50,
                                height: 50,
                                left: leftSelected
                                    ? inRtoL(aniControllerLeft)
                                    : outLtoR(aniControllerRight),
                              ),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 25,
              left: right.dx - 25,
              child: GestureDetector(
                onTap: () {
                  if (leftSelected == true) {
                    setState(() {
                      visible = false;
                      from = left;
                      to = right;
                    });
                    Timer(const Duration(milliseconds: 100), () {
                      setState(() {
                        visible = true;
                      });
                    });
                    Timer(const Duration(milliseconds: 600), () {
                      setState(() {
                        leftSelected = false;
                        aniControllerRight.reset();
                        aniControllerRight.forward();
                      });
                    });
                  }
                },
                child: AnimatedBuilder(
                  animation: leftSelected ? aniLeft : aniRight,
                  builder: (context, _) {
                    return ScaleTransition(
                      scale: aniRight,
                      child: ClipOval(
                        child: Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              color: Colors.deepOrange,
                            ),
                            ClipOval(
                              clipper: MyClipper(
                                width: 50,
                                height: 50,
                                left: leftSelected
                                    ? outRtoL(aniControllerLeft)
                                    : inLtoR(aniControllerRight),
                              ),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            IgnorePointer(
              child: Visibility(
                visible: visible,
                child: Ani(
                  from: from,
                  to: to,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
