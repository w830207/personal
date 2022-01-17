import 'package:get/get.dart';
import 'controller.dart';

class AnimationExampleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnimationExampleController());
  }
}
