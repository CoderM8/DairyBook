import 'package:daily_diary/constant/constant.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

class Storages {
  static GetStorage box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
    initializeDateFormatting();
    box.writeIfNull('languageCode', 'en');
    box.writeIfNull('format', 'dd/MM');
    box.writeIfNull('themeMode', 0);

    themeMode = box.read('themeMode');
    appPassword = box.read('password');
    dateFormat.value = box.read('format');
  }

  /// Reads a value in your box with the given key.
  static T? read<T>(String key) {
    return box.read(key);
  }

  /// Write data on your box
  static Future<void> write(String key, value) async {
    await box.write(key, value);
  }

  /// writeIfNull data on your box
  static Future<void> writeIfNull(String key, value) async {
    await box.writeIfNull(key, value);
  }

  /// remove data from container by key
  static Future<void> remove(String key) async {
    await box.remove(key);
  }

  /// clear all data on your box
  static void eraseAll() async {
    await box.erase();
  }
}
