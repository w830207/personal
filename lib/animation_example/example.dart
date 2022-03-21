import 'package:flutter/material.dart';
import 'package:personal/articles/article.dart';

class Example extends StatefulWidget {
  const Example(
      {Key? key,
      required this.crossState,
      required this.onTap,
      required this.label,
      required this.imageAdd,
      required this.path})
      : super(key: key);
  final bool crossState;
  final String label;
  final String imageAdd;
  final String path;
  final onTap;

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
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
                    onTap: widget.onTap,
                  ),
                ],
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
                crossFadeState: widget.crossState
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
