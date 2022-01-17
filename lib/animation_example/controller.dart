import 'dart:async';

import 'package:get/get.dart';

class AnimationExampleController extends GetxController {
  RxBool quadratic = false.obs;

  playQuadraticAnimation() {
    if (!quadratic.value) {
      quadratic.value = true;
      Timer(const Duration(milliseconds: 5000), () {
        quadratic.value = false;
      });
    }
  }
}
