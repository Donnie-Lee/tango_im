import 'package:sqflite/sqflite.dart';

import '../../models/chat_record.dart';
import './DBManager.dart';

class ChatRecordDB {
  static const String tableName = "ChatRecord";

  static insert(ChatRecordModel chatRecordModel) async {
    Database database = await DBManager.db;
    await database.transaction((txn) async {
      // 插入聊天记录
      await txn.insert(tableName, chatRecordModel.toJson());
    });
    return await DBManager.getId(tableName);
  }

  static sendCompleted(ChatRecordModel chatRecordModel) async {
    Database database = await DBManager.db;
    await database.transaction((txn) async {
      // 插入聊天记录
      await txn.update(tableName, chatRecordModel.toJson(), where: "id = ?", whereArgs: [chatRecordModel.id]);
    });
  }

  static Future<List<ChatRecordModel>?> findAll(chatRoomId) async {
    Database database = await DBManager.db;
    List<Map<String, Object?>> result =
        await database.query(tableName, where: "chatRoomId=?", whereArgs: [chatRoomId]);
    if (result.isNotEmpty) {
      return result.map((e) => ChatRecordModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<ChatRecordModel?> find(int id) async {
    Database database = await DBManager.db;
    List<Map<String, Object?>> result =
        await database.query(tableName, where: "id=?", whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.map((e) => ChatRecordModel.fromJson(e)).toList()[0];
    } else {
      return null;
    }
  }

  static Future<ChatRecordModel?> findContactId(int id) async {
    Database database = await DBManager.db;
    List<Map<String, Object?>> result =
        await database.query(tableName, where: "accountIds=?", whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.map((e) => ChatRecordModel.fromJson(e)).toList()[0];
    } else {
      return null;
    }
  }

  /// 删除
  static Future<int> delete(int id) async {
    Database database = await DBManager.db;
    int count =
        await database.delete(tableName, where: "id=?", whereArgs: [id]);
    return count;
  }

  /// 删除全部
  static Future<int> deleteAll() async {
    Database database = await DBManager.db;
    int count = await database.delete(tableName);
    return count;
  }
}
