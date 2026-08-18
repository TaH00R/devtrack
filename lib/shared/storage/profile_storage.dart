import 'package:hive/hive.dart';

class ProfileStorage {
  static const String boxName = 'profile';

  Future<void> saveImagePath(String path) async {
    final box = await Hive.openBox(boxName);
    await box.put('imagePath', path);
  }

  Future<String?> getImagePath() async {
    final box = await Hive.openBox(boxName);
    return box.get('imagePath');
  }

  Future<void> removeImage() async {
    final box = await Hive.openBox(boxName);
    await box.delete('imagePath');
  }
}