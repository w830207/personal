import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:core';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxString articleNumber = "".obs;
  RxBool isArticleShow = false.obs;

  late String mainfestJson;
  late List<String> assets;
  List<String> chineseFileName = [];

  showArticle(String name) {
    articleNumber.value = name;
    isArticleShow.value = true;
  }

  backToGrid() {
    isArticleShow.value = false;
  }

  getArticlesList() async {
    mainfestJson = await rootBundle.loadString('AssetManifest.json');
    assets = json
        .decode(mainfestJson)
        .keys
        .where((String key) => key.startsWith('articles'))
        .toList();
  }
}
