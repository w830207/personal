import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Ani extends StatefulWidget {
  const Ani({Key? key, required this.from, required this.to}) : super(key: key);
  final Offset from;
  final Offset to;

  @override
  _AniState createState() => _AniState();
}

class _AniState extends State<Ani> with TickerProviderStateMixin {
  late List<AnimationController> listTop;
  late List<AnimationController> listBottom;
  int countBottom = 0;
  int countTop = 0;
  int timeCount = 0;
  late Timer loop1;
  Timer loop2 =
      Timer.periodic(const Duration(milliseconds: 100000), (timer) {});
  late Timer loop3;

  //圓點出發間隔時間
  int between = 100;

  //圓點動畫時間
  int time = 400;

  @override
  void initState() {
    super.initState();
    listTop = [];
    listBottom = [];
    for (int i = 0; i < 3; i++) {
      listTop.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: time)));
    }

    for (int i = 0; i < 2; i++) {
      listBottom.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: time)));
    }

    for (int j = 0; j < listTop.length; j++) {
      listTop[j].reset();
      if (j < listBottom.length) {
        listBottom[j].reset();
      }
    }
    loop1 = Timer.periodic(Duration(milliseconds: between), (timer) {
      listTop[countBottom].forward();
      countBottom++;
      if (countBottom == listTop.length) {
        timer.cancel();
        countBottom = 0;
      }
    });

    Timer(Duration(milliseconds: between ~/ 2), () {
      loop2 = Timer.periodic(Duration(milliseconds: between), (timer) {
        listBottom[countTop].forward();
        countTop++;
        if (countTop == listBottom.length) {
          timer.cancel();
          countTop = 0;
        }
      });
    });

    loop3 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      timeCount += 10;
      setState(() {});
      if (timeCount == (between * listTop.length + time)) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    loop1.cancel();
    loop2.cancel();
    loop3.cancel();
    for (int j = 0; j < listTop.length; j++) {
      listTop[j].dispose();
      if (j < listBottom.length) {
        listBottom[j].dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 100),
      painter: PointPainter(
        Colors.green,
        listTop,
        listBottom,
        widget.from,
        widget.to,
      ),
    );
  }
}

class PointPainter extends CustomPainter {
  final Color color;
  final List<AnimationController> listTop;
  final List<AnimationController> listBottom;
  final Offset from;
  final Offset to;

  PointPainter(this.color, this.listTop, this.listBottom, this.from, this.to);

  getOffset(double time, bool bottom) {
    double x0 = from.dx;
    double y0 = from.dy;

    double x2 = to.dx;
    double y2 = to.dy;

    double x1 = (from.dx + to.dx) / 2;
    double y1 = bottom ? from.dy * 2 : 0;

    double dx =
        pow(1 - time, 2) * x0 + 2 * time * (1 - time) * x1 + pow(time, 2) * x2;
    double dy =
        pow(1 - time, 2) * y0 + 2 * time * (1 - time) * y1 + pow(time, 2) * y2;
    return Offset(dx, dy);
  }

  getRadius(double time) {
    double r = time <= 0.2
        ? 20 * time
        : time <= 0.8
            ? 4
            : 20 * (1 - time);
    return r;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 1.0
      ..color = color;

    for (int i = 0; i < listTop.length; i++) {
      canvas.drawCircle(getOffset(listTop[i].value, false),
          getRadius(listTop[i].value), paint);
    }

    for (int i = 0; i < listBottom.length; i++) {
      canvas.drawCircle(getOffset(listBottom[i].value, true),
          getRadius(listBottom[i].value), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
