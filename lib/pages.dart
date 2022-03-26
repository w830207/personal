import 'package:get/get.dart';
import 'articles/page.dart';
import 'animation_example/page.dart';
import 'animation_example/binding.dart';
import 'home/home.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: "/home",
      page: () => HomePage(),
      children: [
        GetPage(
          name: "/articles",
          page: () => ArticlesPage(),
        ),
        GetPage(
          name: "/animation",
          binding: AnimationExampleBinding(),
          page: () => AnimationExamplePage(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 200),
        ),
      ],
    ),
  ];
}
