import 'package:flutter/material.dart';

class Lantern extends StatefulWidget {
  const Lantern({Key? key}) : super(key: key);

  @override
  _LanternState createState() => _LanternState();
}

class _LanternState extends State<Lantern> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween(begin: 0.5, end: 0.0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: -0.5), weight: 1),
    ]).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutSine));
    super.initState();
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.rotationZ(animation.value),
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.black,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.amber, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Text('測試搖晃動畫'),
                ),
                Row(
                  children: [
                    AnimatedBuilder(
                        child: Container(
                          width: 10,
                          height: 70,
                          color: Colors.blue,
                        ),
                        animation: animation,
                        builder: (context, child) {
                          return Transform(
                            child: child,
                            alignment: Alignment.topCenter,
                            transform: Matrix4.rotationZ(animation.value * 0.7),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedBuilder(
                          child: Container(
                            width: 10,
                            height: 70,
                            color: Colors.blue,
                          ),
                          animation: animation,
                          builder: (context, child) {
                            return Transform(
                              child: child,
                              alignment: Alignment.topCenter,
                              transform:
                                  Matrix4.rotationZ(animation.value * 0.7),
                            );
                          }),
                    ),
                    AnimatedBuilder(
                        child: Container(
                          width: 10,
                          height: 70,
                          color: Colors.blue,
                        ),
                        animation: animation,
                        builder: (context, child) {
                          return Transform(
                            child: child,
                            alignment: Alignment.topCenter,
                            transform: Matrix4.rotationZ(animation.value * 0.7),
                          );
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
