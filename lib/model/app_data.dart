import 'package:ende_code/model/image_data.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AppData extends ChangeNotifier {
  Database _db;

  var imageDataList = <ImageData>[];

  Database get db {
    return _db;
  }

  Future<void> openEndecodeDb(String path) async {
    _db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(ImageData.createTableImageData);
      },
    );
  }

  Future close() async => _db.close();

  AppData() {
    openEndecodeDb("endecode_db").then((_) {
      reload();
    });
  }

  Future reload() async {
    ImageDataProvider(db).getAll().then((list) {
      imageDataList = list;
      notifyListeners();
    });
  }
}