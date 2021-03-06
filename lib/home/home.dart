import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/widgets/drawer.dart';
import 'package:personal/common/font_theme.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: myDrawer(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5D9FFF),
                  Color(0xFFB8DCFF),
                  Color(0XFF6BBBFF),
                ],
                begin: FractionalOffset(0, 1),
                end: FractionalOffset(1, 0),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 50,
            child: GestureDetector(
              onHorizontalDragUpdate: (_) => _key.currentState!.openDrawer(),
              onTap: () => _key.currentState!.openDrawer(),
              child: Image.asset(
                "images/pull.png",
                height: 100,
                width: 200,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white60,
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Image.asset(
                        "images/head.jpeg",
                        width: 200,
                      ),
                      Text(
                        "my personal blog",
                        style: FontTheme.w03,
                      ),
                      Text(
                        "????????????flutter web",
                        style: FontTheme.w01,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
