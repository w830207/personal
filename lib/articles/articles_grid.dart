import 'package:flutter/material.dart';
import 'package:personal/common/font_theme.dart';
import 'package:get/get.dart';
import 'package:personal/common/langs.dart';
import 'package:personal/articles/controller.dart';

class ArticlesGrid extends StatelessWidget {
  ArticlesGrid({Key? key}) : super(key: key);

  final ArticlesController controller = Get.find();
  final Map lang = langs;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      crossAxisCount: 2,
      children: [
        for (int i = 0; i < controller.assets.length; i++)
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: GestureDetector(
              onTap: () {
                controller.showArticle(controller.assets[i]);
              },
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "images/cover.png",
                      fit: BoxFit.cover,
                    ),
                    Text(
                      lang[controller.assets[i]
                          .split('/')
                          .last
                          .replaceAll('.md', '')],
                      style: FontTheme.w02,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
