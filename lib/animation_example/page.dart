import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/animation_example/example.dart';
import 'package:personal/widgets/bezier_quadratic.dart';
import 'controller.dart';
import 'package:personal/drawer.dart';

class AnimationExamplePage extends GetView<AnimationExampleController> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  AnimationExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: myDrawer(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5D9FFF),
                  Color(0xFFB8DCFF),
                  Color(0XFF6BBBFF),
                ],
                begin: FractionalOffset(0, 1),
                end: FractionalOffset(1, 0),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 50,
            child: GestureDetector(
              onHorizontalDragUpdate: (_) => _key.currentState!.openDrawer(),
              // onTap: () => _key.currentState!.openDrawer(),
              child: Image.asset(
                "images/pull.png",
                height: 100,
                width: 200,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Obx(() {
                    return Example(
                      label: "二階貝茲曲線動畫範例 按他→",
                      path: 'articles/animation_example/bezier_quadratic.md',
                      imageAdd: "images/shit.png",
                      crossState: controller.quadraticArticle.value,
                      onTap: () {
                        controller.playQuadraticAnimation();
                        controller.quadraticArticle.value =
                            !controller.quadraticArticle.value;
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Obx(() {
            return Visibility(
              visible: controller.quadraticAnimation.value,
              child: const BezierQuadratic(imageAsset: "images/shit.png"),
            );
          }),
        ],
      ),
    );
  }
}
