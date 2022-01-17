import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/pages.dart';
import 'controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final HomeController controller = Get.put(HomeController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: AppPages.routes,
      initialRoute: "/home",
      onReady: controller.getArticlesList,
    );
  }
}
