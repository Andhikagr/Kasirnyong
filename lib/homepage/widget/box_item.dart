import 'package:flutter/material.dart';

class BoxItem extends StatelessWidget {
  final String images;
  final String label;
  final VoidCallback? onTap;
  const BoxItem({
    super.key,
    required this.images,
    required this.label,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Image.asset(images, fit: BoxFit.contain, width: 60),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
