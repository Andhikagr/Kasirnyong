import 'package:flutter/material.dart';

class ButtonProduk extends StatelessWidget {
  final String label;
  final IconData icons;

  const ButtonProduk({super.key, required this.label, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurple,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icons, color: Colors.white),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
