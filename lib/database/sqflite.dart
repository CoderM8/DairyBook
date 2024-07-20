import 'dart:convert';
import 'dart:io';

import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  static Future<String> get localPath async {
    if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return (await getExternalStorageDirectory())!.path;
    }
  }

  ///init database
  static Future<Database?> _initDatabase() async {
    final String path = join(await localPath, 'dailyDiary.db');
    final Database? db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static void _onCreate(Database db, int version) async {
    ///create database
    await db.execute(
        'CREATE TABLE ${DiaryModel.table} (Id INTEGER PRIMARY KEY autoincrement,title TEXT,description TEXT,createdAt TEXT,updatedAt TEXT,date TEXT,reminder TEXT,notification INTEGER,images TEXT,items TEXT,emoji TEXT,bgColor TEXT,bgImg TEXT,style TEXT,pdf TEXT,catIndex INTEGER,hide INTEGER)');
    if (kDebugMode) {
      print('::::Table Create::::');
    }
  }

  /// DELETE LOCAL DATA
  static Future<bool> deleteDatabaseFile() async {
    final String databasePath = join(await localPath, 'dailyDiary.db');

    // Check if the database file exists
    final bool exists = await databaseExists(databasePath);

    if (exists) {
      await deleteDatabase(databasePath);
      final Database currentDb = await openDatabase(databasePath);
      await currentDb.close();
      _database = await _initDatabase();
      if (kDebugMode) {
        print('Database deleted successfully.');
      }
      return true;
    } else {
      if (kDebugMode) {
        print('Database file not found.');
      }
      return false;
    }
  }

  /// SAVE BACKUP IN DEVICE
  static Future<bool> exportDatabase() async {
    // Get the path to the directory where the database file is located
    final String dbPath = join(await localPath, "dailyDiary.db");

    // Open the database file as a File object
    final File dbFile = File(dbPath);
    // Open the database
    final Database database = await openDatabase(dbPath);
    // Check if the database is empty
    final List<Map<String, dynamic>> result = await database.rawQuery('SELECT COUNT(*) FROM ${DiaryModel.table}');
    final int? count = Sqflite.firstIntValue(result);

    if (count == 0) {
      print('The database is empty. No backup will be created.');
      return false;
    }

    // Read the database file as bytes
    final bytes = await dbFile.readAsBytesSync();
    final String? backupPath = await FilePicker.platform.saveFile(fileName: '${DateTime.now().microsecondsSinceEpoch}backup.db', bytes: bytes);
    print('hello backup path $backupPath');
    if (backupPath != null) {
      return true;
    }
    return false;
  }

  /// IMPORT BACKUP FROM DEVICE
  static Future<bool> importDatabase() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null && result.files.isNotEmpty) {
      final String backupFilePath = result.files[0].path!;

      print('Database import path $backupFilePath');
      if (!backupFilePath.endsWith('db')) {
        return false;
      }
      // Open connections to backup and current databases
      final Database backupDb = await openDatabase(backupFilePath);
      final Database? currentDb = await database;
      try {
        // Transfer data from backup database to current database
        final List<Map<String, dynamic>> dataToTransfer = await backupDb.query(DiaryModel.table);
        if (dataToTransfer.isEmpty) {
          return false;
        }
        // Insert data into current database
        for (Map<String, dynamic> row in dataToTransfer) {
          await currentDb!.insert(DiaryModel.table, row, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      } catch (_) {
        return false;
      }

      // Close database connections
      await backupDb.close();
      await currentDb!.close();
      _database = await _initDatabase();
      print('Database import successfully');
      return true;
    }
    return false;
  }

  /// CURRENT DATABASE SIZE IN [MB]
  static Future<String?> sizeInMB() async {
    final String originalPath = join(await localPath, 'dailyDiary.db');

    final bool backupExists = await databaseExists(originalPath);
    if (!backupExists) {
      if (kDebugMode) {
        print("Not found database $originalPath");
      }
      return null;
    }
    final File databaseFile = File(originalPath);

    // Get the size of the file
    final FileStat fileStat = await databaseFile.stat();
    final double bytes = fileStat.size.toDouble(); // size in bytes

    // Convert bytes to megabytes (MB)
    const int MBInBytes = 1024 * 1024;
    final double sizeInMB = bytes / MBInBytes;

    // Format the result to two decimal places
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  /// ADD
  static Future<int> addDiary(DiaryModel diary) async {
    final Database? db = await database;
    return await db!.insert(DiaryModel.table, diary.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// UPDATE
  static Future<int> updateDiary(int id, DiaryModel diary) async {
    final Database? db = await database;
    return await db!.update(DiaryModel.table, diary.toMap(), where: 'Id = ?', whereArgs: [id]);
  }

  /// REMOVE
  static Future<int> removeDiary(int id) async {
    final Database? db = await database;
    return await db!.delete(DiaryModel.table, where: 'Id = ?', whereArgs: [id]);
  }

  static Future<List<DiaryModel>> getById(int id) async {
    final Database? db = await database;
    final List<Map> maps = await db!.query(DiaryModel.table, where: 'Id = ?', whereArgs: [id]);
    List<DiaryModel> myDiaryList = [];
    if (maps.isNotEmpty) {
      for (final element in maps) {
        myDiaryList.add(DiaryModel.fromMap(element));
      }
    }
    return myDiaryList;
  }

  static Future<List<DiaryModel>> searchByTitle(String title) async {
    final Database? db = await database;
    if (title.isEmpty) {
      return [];
    }
    final List<Map> maps = await db!.query(DiaryModel.table, where: 'title LIKE ? OR description LIKE ?', whereArgs: ['%$title%', '%$title%'], orderBy: 'date ASC');
    List<DiaryModel> myDiaryList = [];
    if (maps.isNotEmpty) {
      for (final element in maps) {
        myDiaryList.add(DiaryModel.fromMap(element));
      }
    }
    return myDiaryList;
  }

  static Future<List<DiaryModel>> getMyDiary() async {
    final Database? db = await database;
    final List<Map> maps = await db!.query(DiaryModel.table, orderBy: 'date ASC', where: 'hide = ?', whereArgs: [0]);
    List<DiaryModel> myDiaryList = [];
    if (maps.isNotEmpty) {
      for (final element in maps) {
        myDiaryList.add(DiaryModel.fromMap(element));
      }
    }
    return myDiaryList;
  }

  static Future<List<DiaryModel>> getMyHideDiary() async {
    final Database? db = await database;
    final List<Map> maps = await db!.query(DiaryModel.table, orderBy: 'date ASC', where: 'hide = ?', whereArgs: [1]);
    List<DiaryModel> myDiaryList = [];
    if (maps.isNotEmpty) {
      for (final element in maps) {
        myDiaryList.add(DiaryModel.fromMap(element));
      }
    }
    return myDiaryList;
  }

  static Future<List<DiaryModel>> getGalleryDiary() async {
    final Database? db = await database;
    final List<Map> maps = await db!.query(DiaryModel.table, orderBy: 'date ASC', where: 'hide = ?', whereArgs: [0]);
    List<DiaryModel> myDiaryList = [];
    if (maps.isNotEmpty) {
      for (final element in maps) {
        final DiaryModel diary = DiaryModel.fromMap(element);
        if (diary.images.isNotEmpty) {
          myDiaryList.add(diary);
        }
      }
    }
    return myDiaryList;
  }

  static Future<List<DiaryModel>> getMyDiaryByDate(DateTime datetime) async {
    final Database? db = await database;

    // Format the start and end dates for the query
    final String start = DateFormat('y-MM-dd 00:00').format(datetime); // Start of the day
    final String end = DateFormat('y-MM-dd 23:59').format(datetime); // End of the day

    final List<Map<String, dynamic>> maps = await db!.query(DiaryModel.table, where: 'date > ? AND date < ? AND hide = ?', whereArgs: [start, end, 0], orderBy: 'date ASC');

    List<DiaryModel> myDiaryList = [];
    if (maps.isNotEmpty) {
      myDiaryList = maps.map((map) => DiaryModel.fromMap(map)).toList();
    }
    return myDiaryList;
  }
}

class DiaryModel {
  static const String table = "MyDiary";
  final int? id;
  final String reminder;
  final bool notification;
  final String title;
  final String description;
  final String createdAt;
  final String updatedAt;
  final String date;
  final List images;
  final List<Task> items;
  final String emoji;
  final String bgImg;
  final Fonts style;
  final int bgColor;
  final int catIndex;
  final bool hide;
  final String pdf;

  DiaryModel({
    this.id,
    required this.reminder,
    required this.notification,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.images,
    required this.emoji,
    required this.bgColor,
    required this.style,
    required this.items,
    required this.bgImg,
    required this.catIndex,
    required this.hide,
    required this.pdf,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': id,
      'reminder': reminder,
      'notification': notification ? 1 : 0,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'date': date,
      'images': images.join(','),
      'items': jsonEncode(items.map((task) => task.toMap()).toList()), // Serialize List<Task> to JSON
      'emoji': emoji,
      'bgColor': bgColor,
      'bgImg': bgImg,
      'catIndex': catIndex,
      'pdf': pdf,
      'hide': hide ? 1 : 0,
      'style': jsonEncode(style.toMap())
    };
  }

  factory DiaryModel.fromMap(Map<dynamic, dynamic> map) {
    return DiaryModel(
      id: map['Id'],
      reminder: map['reminder'],
      notification: map['notification'] == 1,
      title: map['title'],
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'],
      date: map['date'],
      description: map['description'],
      emoji: map['emoji'],
      bgImg: map['bgImg'],
      pdf: map['pdf'],
      hide: map['hide'] == 1,
      catIndex: map['catIndex'] ?? 0,
      bgColor: int.parse(map['bgColor'].toString()),
      items: (jsonDecode(map['items']) as List<dynamic>).map((item) => Task.fromMap(item)).toList(),
      // Deserialize JSON to List<Task>
      images: map['images'].toString().isNotEmpty ? (map['images'] as String).split(',').map((file) => file).toList() : [],
      style: Fonts.fromMap(jsonDecode(map['style'])),
    );
  }
}

class Fonts {
  final String code;
  final TextAlign align;
  final FontWeight fontWeight;
  final int color;

  Fonts({required this.code, required this.fontWeight, required this.align, required this.color});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'code': code, 'fontWeight': fontWeightToString(fontWeight), 'align': textAlignToString(align), 'color': color};
  }

  factory Fonts.fromMap(Map<dynamic, dynamic> map) {
    return Fonts(code: map['code'], fontWeight: stringToFontWeight(map['fontWeight']), align: stringToTextAlign(map['align']), color: map['color']);
  }
}

String textAlignToString(TextAlign align) {
  return align.toString().split('.').last; // Convert TextAlign enum to String
}

TextAlign stringToTextAlign(String value) {
  return TextAlign.values.firstWhere((e) => e.toString() == 'TextAlign.$value', orElse: () => TextAlign.left);
}

String fontWeightToString(FontWeight weight) {
  return weight.toString().split('.').last; // Convert FontWeight enum to String
}

FontWeight stringToFontWeight(String value) {
  return FontWeight.values.firstWhere((e) => e.toString() == 'FontWeight.$value', orElse: () => FontWeight.normal);
}
