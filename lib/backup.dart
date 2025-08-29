import 'package:flutter/material.dart';
import 'package:food_app/homepage/widget/box_item.dart';

class Backup extends StatefulWidget {
  const Backup({super.key});

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/backup.png'), context);
      precacheImage(const AssetImage('assets/restore.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Backup Data", style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Row(
          children: [
            Expanded(
              child: BoxItem(
                images: "assets/backup.png",
                label: "Backup",
                onTap: () {},
              ),
            ),
            Expanded(
              child: BoxItem(
                images: "assets/restore.png",
                label: "Restore",
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
