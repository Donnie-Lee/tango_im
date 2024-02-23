import 'package:sqflite/sqflite.dart';

class DBManager {
  static Database? _db;

  /// 初始化数据库
  static Future<Database> _initDB() async {
    return openDatabase('tango.db', version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ChatRoom (id INTEGER PRIMARY KEY, chatRoomId INTEGER, newestMsg BLOB, newestMsgTime TEXT, newestMsgType INTEGER,unRead INTEGER, top BOOL, createTime TEXT, updateTime TEXT,  accountIds TEXT, userId TEXT, type INTEGER, name TEXT, messageType INTEGER )');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ChatRecord (id INTEGER PRIMARY KEY, chatRoomId INTEGER, status INTEGER, senderId TEXT, receiverId TEXT, message BLOB, messageType INTEGER, sendTime TEXT, canceled BOOL, quoteId INTEGER )');
    });
  }

  static Future<Database> get db async {
    return _db ??= await _initDB();
  }

  static  getId(String table) async{
    Database database = await DBManager.db;
    List<Map<String, Object?>> result = await database.rawQuery("select last_insert_rowid() from $table LIMIT 1;");
    if (result.isNotEmpty) {
      return result.first.values.first;
      // return result.map((e) => ChatRecordModel.fromJson(e)).toList()[0];
    } else {
      return null;
    }
  }
}
