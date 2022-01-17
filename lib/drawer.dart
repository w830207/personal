import 'package:flutter/material.dart';
import 'package:get/get.dart';

Container myDrawer() {
  return Container(
    width: 200,
    color: Colors.white,
    child: ListView(
      children: [
        ListTile(
          title: const Text("Home"),
          onTap: () {
            Get.offAllNamed("/home");
          },
        ),
        ListTile(
          title: const Text("Articles"),
          onTap: () {
            Get.offAllNamed("/home/articles");
          },
        ),
        ListTile(
          title: const Text("Animation"),
          onTap: () {
            Get.offAllNamed("/home/animation");
          },
        ),
      ],
    ),
  );
}
