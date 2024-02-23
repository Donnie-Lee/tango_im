

class ChatRoomModel {

  String accountIds;
  int? chatRoomId;
  int? id;
  int type;
  int unRead;
  String userId;
  String? name;
  dynamic newestMsg;
  String? newestMsgTime;
  int? newestMsgType;
  String createTime;
  String updateTime;

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      :
        accountIds = json['accountIds'],
        id = json['id'],
        chatRoomId = json['chatRoomId'],
        type = json['type'],
        name = json['name'],
        userId = json['userId'],
        unRead = json['unRead']??0,
        newestMsg = json['newestMsg'],
        newestMsgTime = json['newestMsgTime'],
        newestMsgType = json['newestMsgType'],
        createTime = json['createTime'],
        updateTime = json['updateTime']
   ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['chatRoomId'] = chatRoomId;
    map['accountIds'] = accountIds;
    map['type'] = type;
    map['name'] = name;
    map['userId'] = userId;
    map['unRead'] = unRead;
    map['newestMsg'] = newestMsg;
    map['newestMsgTime'] = newestMsgTime;
    map['newestMsgType'] = newestMsgType;
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    return map;
  }
}
