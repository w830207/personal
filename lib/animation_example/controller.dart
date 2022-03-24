import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimationExampleController extends GetxController {
  RxBool quadraticAnimation = false.obs;
  ScrollController sC = ScrollController();

  playQuadraticAnimation() {
    if (!quadraticAnimation.value) {
      quadraticAnimation.value = true;
      Timer(const Duration(milliseconds: 5000), () {
        quadraticAnimation.value = false;
      });
    }
  }
}
