import 'dart:async';

import 'package:get/get.dart';

class AnimationExampleController extends GetxController {
  RxBool quadraticAnimation = false.obs;
  RxBool quadraticArticle = false.obs;

  playQuadraticAnimation() {
    if (!quadraticAnimation.value) {
      quadraticAnimation.value = true;
      Timer(const Duration(milliseconds: 5000), () {
        quadraticAnimation.value = false;
      });
    }
  }
}
