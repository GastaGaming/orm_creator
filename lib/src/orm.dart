import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:async';
import 'imageManipulation.dart';
import 'package:get/get.dart';

Future<void> recursiveORMgenerator(Directory root, BuildContext context) async {
  for (FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is Directory) {
      oRMgeneration(entity, context);
    }
  }
}

Future<void> oRMgeneration(Directory targetDir, BuildContext context) async {
  File? albedoFile = await getAlbedoFile(Directory(targetDir.path));
  if (albedoFile != null) {
    String albedoFileName = albedoFile.path.split("\\").last;
    albedoFileName = albedoFileName.split('_').first;
    //Randome color for the file name
    String ormFileName = '${albedoFileName}_ORM.png';
    //Decode albedo image
    img.Image albedoImage = img.decodeImage(albedoFile.readAsBytesSync())!;
    List<File?> files = await getRoughnessMetallicAmbientOcclusionFiles(
        Directory(targetDir.path), albedoFile);
    img.Image? occulsionImage = (files[0] != null)
        ? img.decodeImage(files[0]!.readAsBytesSync())!
        : null;
    img.Image? metallicImage = (files[1] != null)
        ? img.decodeImage(files[1]!.readAsBytesSync())!
        : null;
    img.Image? roughnessImage = (files[2] != null)
        ? img.decodeImage(files[2]!.readAsBytesSync())!
        : null;

    img.Image ormImage = createORMimage(
        albedoImage, occulsionImage, metallicImage, roughnessImage);
    writeImageToDirectory(ormImage, Directory(targetDir.path), ormFileName);

    Get.snackbar("Job well done 💪🥳", "$ormFileName: Created");
  } else {
    Get.snackbar("Cant find Albedo", "Please check the path");
  }
}
