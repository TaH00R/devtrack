import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class ProfileStorage {
  static const String _boxName =
      "profile_storage";

  static const String _imagePathKey =
      "profile_image_path";

  Future<Box<dynamic>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox(
        _boxName,
      );
    }

    return Hive.box(_boxName);
  }

  Future<String?> getImagePath() async {
    final box =
        await _getBox();

    final path =
        box.get(_imagePathKey);

    if (path is! String ||
        path.isEmpty) {
      return null;
    }

    final file = File(path);

    if (!file.existsSync()) {
      await box.delete(
        _imagePathKey,
      );

      return null;
    }

    return path;
  }

  Future<String> saveImage(
    String sourcePath,
  ) async {
    final directory =
        await getApplicationDocumentsDirectory();

    final profileDirectory =
        Directory(
      '${directory.path}/profile',
    );

    if (!profileDirectory
        .existsSync()) {
      await profileDirectory
          .create(
        recursive: true,
      );
    }

    final extension =
        _getExtension(sourcePath);

    final targetPath =
        '${profileDirectory.path}/profile_image$extension';

    final sourceFile =
        File(sourcePath);

    final targetFile =
        await sourceFile.copy(
      targetPath,
    );

    final box =
        await _getBox();

    final oldPath =
        box.get(_imagePathKey);

    if (oldPath is String &&
        oldPath.isNotEmpty &&
        oldPath != targetFile.path) {
      final oldFile =
          File(oldPath);

      if (oldFile.existsSync()) {
        try {
          await oldFile.delete();
        } catch (_) {}
      }
    }

    await box.put(
      _imagePathKey,
      targetFile.path,
    );

    return targetFile.path;
  }

  Future<void> removeImage() async {
    final box =
        await _getBox();

    final path =
        box.get(_imagePathKey);

    if (path is String &&
        path.isNotEmpty) {
      final file =
          File(path);

      if (file.existsSync()) {
        try {
          await file.delete();
        } catch (_) {}
      }
    }

    await box.delete(
      _imagePathKey,
    );
  }

  String _getExtension(
    String path,
  ) {
    final index =
        path.lastIndexOf(".");

    if (index == -1) {
      return ".jpg";
    }

    return path.substring(
      index,
    );
  }
}