import 'package:sqflite/sqflite.dart';

import '../../models/chat_room.dart';
import './DBManager.dart';

class ChatRoomDB {
  static const String tableName = "ChatRoom";

  static insert(ChatRoomModel chatRoom) async {
    Database database = await DBManager.db;
    await database.transaction((txn) async {
      // 插入聊天室信息
      await txn.insert(tableName, chatRoom.toJson());
    });
  }

  static Future<List<ChatRoomModel>?> findAll(userId) async {
    Database database = await DBManager.db;
    List<Map<String, Object?>> result =
        await database.query(tableName, where: "userId=?", whereArgs: [userId]);
    if (result.isNotEmpty) {
      return result.map((e) => ChatRoomModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<ChatRoomModel?> find(int id) async {
    Database database = await DBManager.db;
    List<Map<String, Object?>> result =
        await database.query(tableName, where: "id=?", whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.map((e) => ChatRoomModel.fromJson(e)).toList()[0];
    } else {
      return null;
    }
  }

  static Future<ChatRoomModel?> findChatRoomId(int chatRoomId) async {
    Database database = await DBManager.db;
    List<Map<String, Object?>> result =
    await database.query(tableName, where: "chatRoomId=?", whereArgs: [chatRoomId]);
    if (result.isNotEmpty) {
      return result.map((e) => ChatRoomModel.fromJson(e)).toList()[0];
    } else {
      return null;
    }
  }

  static updateTheNewestMsg(int chatRoomId, dynamic newestMsg,
      String? newestMsgTime, int? newestMsgType) async {
    (await DBManager.db).rawUpdate(
        "update ChatRoom set newestMsg =?,newestMsgTime=?,newestMsgType=?,updateTime=? where chatRoomId=?",
        [newestMsg, newestMsgTime, newestMsgType, newestMsgTime, chatRoomId]);
  }

  static updateTheNewestMsgUnReadIncrement(int chatRoomId, dynamic newestMsg,
      String? newestMsgTime, int? newestMsgType) async {
    (await DBManager.db).rawUpdate(
        "update ChatRoom set newestMsg =?,newestMsgTime=?,newestMsgType=?,updateTime=?,unRead=unRead+1 where chatRoomId=?",
        [newestMsg, newestMsgTime, newestMsgType, newestMsgTime, chatRoomId]);
  }

  static clearUnRead(int chatRoomId) async {
    (await DBManager.db).rawUpdate(
        "update ChatRoom set unRead=0 where chatRoomId=?", [chatRoomId]);
  }

  static Future<ChatRoomModel?> findContactId(String id, int userId) async {
    Database database = await DBManager.db;
    List<Map<String, Object?>> result = await database.query(tableName,
        where: "accountIds=? and userId = ?", whereArgs: [id, userId]);
    if (result.isNotEmpty) {
      return result.map((e) => ChatRoomModel.fromJson(e)).toList()[0];
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
