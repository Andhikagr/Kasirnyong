import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ButtonProduk extends StatefulWidget {
  final String label;
  final IconData icons;
  final Function(String path) onImage;

  const ButtonProduk({
    super.key,
    required this.label,
    required this.icons,
    required this.onImage,
  });

  @override
  State<ButtonProduk> createState() => _ButtonProdukState();
}

class _ButtonProdukState extends State<ButtonProduk> {
  File? imageFile;

  Future<void> _pickImage(ImageSource source) async {
    //request permission
    bool izinDulu = false;

    if (source == ImageSource.camera) {
      izinDulu = await Permission.camera.request().isGranted;
    } else if (source == ImageSource.gallery) {
      izinDulu =
          await Permission.photos.request().isGranted ||
          await Permission.mediaLibrary.request().isGranted ||
          await Permission.storage.request().isGranted;
    }

    if (!izinDulu) {
      Get.snackbar(
        "Error",
        "Akses ditolak",
        icon: Icon(Icons.warning, color: Colors.red),
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }

    //lanjut
    final ImagePicker picker = ImagePicker();
    final XFile? pick = await picker.pickImage(source: source);

    if (pick != null) {
      setState(() {
        imageFile = File(pick.path);
      });

      widget.onImage(pick.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //tombol ambil kamera
        if (widget.label.toLowerCase().contains("foto")) {
          await _pickImage(ImageSource.camera);
        } else {
          //tombol pilih gambar
          await _pickImage(ImageSource.gallery);
        }
      },
      child: Ink(
        padding: EdgeInsets.all(10),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icons, color: Colors.white),
              SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
