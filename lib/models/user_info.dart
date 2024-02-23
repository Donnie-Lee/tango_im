import 'trend.dart';

class UserInfo {
  int id;
  String nickname;
  String? avatar;
  String mobile;
  String? bgImage;
  String? signInfo;
  String? introduce;
  String? gender;
  bool? isStared;
  List<Trend> trends;


  UserInfo.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        mobile = map['mobile'],
        avatar = map['avatar'],
        nickname = map['nickname'],
        introduce = map['introduce'],
        signInfo = map['signInfo'],
        gender = map['gender'],
        isStared = map['isStared'],
        bgImage = map['bgImage'],
        trends = List.generate(map['trends'].length, (index) => Trend.fromJson(map['trends'][index]))
  ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['mobile'] = mobile;
    map['avatar'] = avatar;
    map['nickname'] = nickname;
    map['signInfo'] = signInfo;
    map['introduce'] = introduce;
    map['gender'] = gender;
    map['isStared'] = isStared;
    map['bgImage'] = bgImage;
    map['trends'] = trends.map((e) => e.toJson()).toList();;
    return map;
  }

}