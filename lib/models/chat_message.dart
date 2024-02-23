class ChatMessage {
  int type;
  String fromUserId;
  String toUserId;
  String? groupTo;
  int messageType;
  String message;

  ChatMessage.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        fromUserId = json['fromUserId'],
        toUserId = json['toUserId'],
        groupTo = json['groupTo'],
        messageType = json['messageType'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['fromUserId'] = fromUserId;
    map['toUserId'] = toUserId;
    map['groupTo'] = groupTo;
    map['messageType'] = messageType;
    map['message'] = message;
    return map;
  }

}