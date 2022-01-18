import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/articles/article.dart';
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
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
            top: MediaQuery
                .of(context)
                .size
                .height / 2 - 50,
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
            left: MediaQuery
                .of(context)
                .size
                .width / 3,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: SingleChildScrollView(
                child: Container(

                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text("二階貝茲曲線動畫範例 按他→"),
                            GestureDetector(
                              child: Image.asset(
                                "images/shit.png",
                                width: 60,
                              ),
                              onTap: () {
                                Get.back();
                                controller.playQuadraticAnimation();
                                controller.quadraticArticle.value =
                                !controller.quadraticArticle.value;
                              },
                            ),
                          ],
                        ),
                        Obx(() {
                          return AnimatedCrossFade(
                            firstChild: const SizedBox(
                              width: 0.0,
                            ),
                            secondChild: Container(
                              color: Colors.white60,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.6,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.7,
                              child: Article(
                                path:
                                'articles/animation_example/bezier_quadratic.md',
                              ),
                            ),
                            crossFadeState: controller.quadraticArticle.value
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
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
