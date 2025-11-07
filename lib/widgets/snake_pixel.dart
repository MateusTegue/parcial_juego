import 'package:flutter/material.dart';

class SnakePixel extends StatelessWidget {
  final bool isHead;

  const SnakePixel({Key? key, this.isHead = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isHead ? Colors.green[700] : Colors.green,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
