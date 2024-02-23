import 'package:flutter/material.dart';

import '../models/chat_record.dart';

class ChatRecordModelChangeNotifier extends ChangeNotifier{

  static final ChatRecordModelChangeNotifier _chatRecordModelChangeNotifier = ChatRecordModelChangeNotifier._internal();
  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  ChatRecordModelChangeNotifier._internal();

  /// 获取单例内部方法
  factory ChatRecordModelChangeNotifier() {
    return _chatRecordModelChangeNotifier;
  }

  late ChatRecordModel _chatRecordModel;
  ChatRecordModel get chatRecordModel => _chatRecordModel;
  void setChatRecordModel(ChatRecordModel chatRecordModel){
    _chatRecordModel= chatRecordModel;
    notifyListeners();
  }

}