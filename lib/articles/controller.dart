import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:core';

class ArticlesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxString articleName = "".obs;
  RxString articlePath = "".obs;
  RxBool isArticleShow = false.obs;

  late String mainfestJson;
  late List<String> assets;

  showArticle(String path) {
    articlePath.value = path;
    articleName.value = path.split('/').last.replaceAll('.md', '');
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
    print(assets[0].split('/').last[0]);
    print(assets);
    assets.sort((a, b) => a.split('/').last[0].compareTo(b.split('/').last[0]));
    print(assets);
  }
}
