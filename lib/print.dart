import 'package:flutter/material.dart';

class Print extends StatelessWidget {
  const Print({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/no.png", fit: BoxFit.cover, width: 100),
            SizedBox(height: 20),
            Text(
              "Belum ada printer yang terhubung",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
