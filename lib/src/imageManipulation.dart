import 'package:image/image.dart';
import 'dart:io';
import 'dart:async';

import 'const.dart';

//print each pixel postition and channel values of the image
void printPixelPositionAndChannelValuesFromImage(Image image) {
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final int pixel = image.getPixel(x, y);
      final int red = pixel & 0xFF;
      final int green = (pixel >> 8) & 0xFF;
      final int blue = (pixel >> 16) & 0xFF;
      print('$x,$y: $red,$green,$blue');
    }
  }
}

//get first image file from the directory
Future<File?> getFirstImageFile(Directory directory) async {
  final List<FileSystemEntity> files = await directory.list().toList();
  for (FileSystemEntity file in files) {
    if (file is File) {
      final String filename = file.path.split('/').last;
      // If filename ends with one of the supported file formats, return it.
      if (kSupportedFileformats
          .any((String format) => filename.endsWith(format))) {
        return file;
      }
    }
  }
  return null;
}

//get pixel from specified position and channel
int getPixelFromChannel(Image image, int x, int y, int channel) {
  final int pixel = image.getPixel(x, y);
  switch (channel) {
    case 0:
      return pixel & 0xFF;
    case 1:
      return (pixel >> 8) & 0xFF;
    case 2:
      return (pixel >> 16) & 0xFF;
    case 3:
      return (pixel >> 24) & 0xFF;
    default:
      return 0;
  }
}

//get file with specified suffix from the directory. Return if it is supported file format.
Future<File?> getFileWithSuffix(Directory directory, String suffix) async {
  final List<FileSystemEntity> files = await directory.list().toList();
  for (FileSystemEntity file in files) {
    if (file is File) {
      final String filename = file.path.split('\\').last;
      // If filename contains the suffix and ends with one of the supported file formats, return it.
      if (filename.contains(suffix) &&
          kSupportedFileformats
              .any((String format) => filename.endsWith(format))) {
        return file;
      }
    }
  }
  return null;
}

//get albedo file from the directory. Return if it is supported file format.
Future<File?> getAlbedoFile(Directory directory) async {
  for (String suffix in kAlbedoSuffixList) {
    final File? file = await getFileWithSuffix(directory, suffix);
    if (file != null) {
      return file;
    }
  }
  return null;
}

//ger roughness, metallic and ambient occlusion file from the directory. File name matches the albedo file name. Return if it is supported file format.
Future<List<File?>> getRoughnessMetallicAmbientOcclusionFiles(
    Directory directory, File albedoFile) async {
  final String albedoFilename = albedoFile.path.split('\\').last;
  final String albedoFilenameWithoutExtension = albedoFilename.split('_').first;
  final List<File?> files = [];
  File? roughnessFile, metallicFile, ambientOcclusionFile;
  for (String suffix in kAmbientOcclusionSuffixList) {
    final File? file = await getFileWithSuffix(
        directory, albedoFilenameWithoutExtension + suffix);
    if (file != null) {
      ambientOcclusionFile = file;
      break;
    }
  }
  for (String suffix in kRoughnessSuffixList) {
    final File? file = await getFileWithSuffix(
        directory, albedoFilenameWithoutExtension + suffix);
    if (file != null) {
      roughnessFile = file;
    }
  }
  for (String suffix in kMetallicSuffixList) {
    final File? file = await getFileWithSuffix(
        directory, albedoFilenameWithoutExtension + suffix);
    if (file != null) {
      metallicFile = file;
    }
  }
  files.add(ambientOcclusionFile);
  files.add(roughnessFile);
  files.add(metallicFile);
  return files;
}

//Write create oMilmrm image
Image createORMimage(
    Image albedo, Image? occulsion, Image? roughness, Image? metallic) {
  final Image ormImage = Image.from(albedo);
  for (int y = 0; y < albedo.height; y++) {
    for (int x = 0; x < albedo.width; x++) {
      final int occulsionPixel =
          (occulsion != null) ? occulsion.getPixel(x, y) : 255;
      final int roughnessPixel =
          (roughness != null) ? roughness.getPixel(x, y) : 60;
      final int metallicPixel =
          (metallic != null) ? metallic.getPixel(x, y) : 0;

      final int ormPixelOcculsion = occulsionPixel & 0xFF;
      final int ormPixelRoughness = roughnessPixel & 0xFF;
      final int ormPixelMetallic = metallicPixel & 0xFF;
      // final pixel is occulsion red, roughness green, metallic blue and alpha is 255
      final int ormPixel = (255 << 24) |
          (ormPixelMetallic << 16) |
          (ormPixelRoughness << 8) |
          ormPixelOcculsion;

      ormImage.setPixel(x, y, ormPixel);
    }
  }
  return ormImage;
}

void writeImageToDirectory(Image image, Directory directory, String filename) {
  final File file = File('${directory.path}/$filename');
  File(file.path).writeAsBytesSync(encodePng(image));
}

//loop through all directories in the input folder
void recursiveLoop(Directory root) {
  for (FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is File) {
      print("File : " + entity.path);
    }
  }
}
