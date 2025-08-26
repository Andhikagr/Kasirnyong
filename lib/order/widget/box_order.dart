import 'package:flutter/material.dart';

class BoxOrder extends StatelessWidget {
  final String label;
  final double? height;
  final double? width;
  final Color? bgColors;
  final Color? textColors;

  const BoxOrder({
    super.key,
    required this.label,
    this.height,
    this.width,
    this.bgColors,
    this.textColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: bgColors,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: textColors, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
