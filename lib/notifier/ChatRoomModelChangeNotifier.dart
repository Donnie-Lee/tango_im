import 'package:flutter/material.dart';

import '../models/chat_record.dart';
import '../models/chat_room.dart';

class ChatRoomModelChangeNotifier extends ChangeNotifier{

  static final ChatRoomModelChangeNotifier _ChatRoomModelChangeNotifier = ChatRoomModelChangeNotifier._internal();
  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  ChatRoomModelChangeNotifier._internal();

  /// 获取单例内部方法
  factory ChatRoomModelChangeNotifier() {
    return _ChatRoomModelChangeNotifier;
  }


  late int _chatRoomModelId;
  int get chatRoomModelId => _chatRoomModelId;

  void notifyRefreshList(int chatRoomModelId){
    _chatRoomModelId = chatRoomModelId;
    notifyListeners();
  }

}