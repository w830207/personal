import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:personal/controller.dart';

class Article extends StatelessWidget {
  final String name;
  Article({Key? key, required this.name}) : super(key: key);

  final HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString('articles/$name.md'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Markdown(
            data: snapshot.data,
            selectable: true,
          );
        } else {
          return const Text(
            "Loading...",
          );
        }
      },
    );
  }
}
