class ChatMessageUserInfo {
  String avatar;
  String username;
  String theNewestMessage;
  int unReadCount;
  String theNewestMessageTime;

// 0 在线 1 离线 2 忙碌 3 离开
  int status = 0;

  ChatMessageUserInfo.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'],
        username = json['username'],
        theNewestMessage = json['theNewestMessage'],
        unReadCount = json['unReadCount'],
        theNewestMessageTime = json['theNewestMessageTime'],
        status = json['status'];
}