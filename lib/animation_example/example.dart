import 'package:flutter/material.dart';
import 'package:personal/articles/article.dart';

typedef ShowArticleFunc = Function(bool showArticle);

class Example extends StatefulWidget {
  const Example({
    Key? key,
    required this.onTap,
    required this.label,
    required this.imageAdd,
    required this.path,
    this.child,
  }) : super(key: key);

  final String label;
  final String imageAdd;
  final String path;
  final ShowArticleFunc onTap;
  final Widget? child;

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool isArticleShown = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.label),
              GestureDetector(
                child: Image.asset(
                  widget.imageAdd,
                  width: 60,
                ),
                onTap: () {
                  widget.onTap(isArticleShown);
                  setState(() {
                    isArticleShown = !isArticleShown;
                  });
                },
              ),
            ],
          ),
          if (widget.child != null)
            Visibility(
              visible: isArticleShown,
              child: widget.child!,
            ),
          AnimatedCrossFade(
            firstChild: const SizedBox(
              width: 0.0,
            ),
            secondChild: Container(
              color: Colors.white60,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Article(
                path: widget.path,
              ),
            ),
            crossFadeState: isArticleShown
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
