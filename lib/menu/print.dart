import 'package:flutter/material.dart';

class Print extends StatelessWidget {
  const Print({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/no.png", fit: BoxFit.cover, width: 150),
            SizedBox(height: 20),
            Text(
              "Belum ada printer yang terhubung",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
