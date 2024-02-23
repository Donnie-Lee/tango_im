import 'user_info.dart';

class Contact {
  UserInfo accountInfo;
  String createTime;
  bool stared;
  String? nickNameRemark;
  int status;

  Contact.fromJson(Map<String, dynamic> map)
      : createTime = map['createTime'],
        stared = map['stared'],
        nickNameRemark = map['nickNameRemark'],
        status = map['status'],
        accountInfo = UserInfo.fromJson(map['accountInfo']);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createTime'] = createTime;
    map['stared'] = stared;
    map['nickNameRemark'] = nickNameRemark;
    map['status'] = status;
    map['accountInfo'] = accountInfo.toJson();
    return map;
  }
}
