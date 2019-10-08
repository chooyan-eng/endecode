import 'package:sqflite/sqflite.dart';

class ImageData {

  static final String tableImageData = 'image_data';
  static final String columnId = '_id';
  static final String columnTitle = 'title';
  static final String columnCreator = 'creator';
  static final String columnData = 'data';

  static final String createTableImageData = '''
    create table $tableImageData (
      $columnId integer primary key autoincrement,
      $columnTitle text not null,
      $columnCreator text not null,
      $columnData text not null)
  ''';

  int id;
  String dataStr;
  String title;
  String creator;

  ImageData({this.id, this.dataStr, this.title, this.creator});

  int get cellNum {
    return int.parse(dataStr.substring(0,2));
  }

  List<int> get data {
    return RegExp(r"[0-9]{2}").allMatches(dataStr.substring(2, dataStr.length)).map((match) => int.parse(match.group(0))).toList();
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnCreator: creator,
      columnData: dataStr,
    };

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ImageData.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    creator = map[columnCreator];
    dataStr = map[columnData];
  }
}


class ImageDataProvider {

  final Database db;

  ImageDataProvider(this.db);

  Future<ImageData> insert(ImageData data) async {
    data.id = await db.insert(ImageData.tableImageData, data.toMap());
    return data;
  }

  Future<ImageData> getChild(int id) async {
    List<Map> maps = await db.query(ImageData.tableImageData,
        columns: [ImageData.columnId, ImageData.columnTitle, ImageData.columnCreator, ImageData.columnData],
        where: '$ImageData.columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ImageData.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ImageData>> getAll() async {
    List<Map> maps = await db.query(
      ImageData.tableImageData,
      columns: [ImageData.columnId, ImageData.columnTitle, ImageData.columnCreator, ImageData.columnData],
    );

    final result = List<ImageData>();
    maps.forEach((map) {
      result.add(ImageData.fromMap(map));
    });
    return result;
  }

  Future<int> delete(int id) async {
    return await db.delete(ImageData.tableImageData, where: '$ImageData.columnId = ?', whereArgs: [id]);
  }

  Future<int> update(ImageData child) async {
    return await db.update(ImageData.tableImageData, child.toMap(),
        where: '$ImageData.columnId = ?', whereArgs: [child.id]);
  }
}