import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> simpanGambar(String imagePath) async {
  final directory = await getApplicationDocumentsDirectory();
  //folder permanen
  final String newPath =
      "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png";

  final File newImage = await File(imagePath).copy(newPath);
  return newImage.path;
}
