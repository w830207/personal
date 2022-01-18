import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/common/font_theme.dart';
import 'package:personal/drawer.dart';
import 'package:personal/controller.dart';
import 'article.dart';
import 'articles_grid.dart';

class ArticlesPage extends StatelessWidget {
  ArticlesPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final HomeController controller = Get.find();

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
          Obx(() {
            return Visibility(
              visible: !controller.isArticleShow.value,
              child: Positioned(
                top: MediaQuery.of(context).size.width / 10,
                left: MediaQuery.of(context).size.width / 3,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ArticlesGrid(),
                ),
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: controller.isArticleShow.value,
              child: Positioned(
                left: MediaQuery.of(context).size.width / 3,
                child: InkWell(
                  onTap: controller.backToGrid,
                  child: Text(
                    "< back",
                    style: FontTheme.w01,
                  ),
                ),
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: controller.isArticleShow.value,
              child: Positioned(
                left: MediaQuery.of(context).size.width / 3,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Container(
                    color: Colors.white60,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Article(
                      path: controller.articlePath.value,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
