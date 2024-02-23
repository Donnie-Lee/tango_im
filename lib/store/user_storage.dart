import '../models/user_info.dart';

class UserStorage {

  static late UserInfo _userInfo;


  static setUserInfo(UserInfo userInfo) {
    _userInfo = userInfo;
  }


  static UserInfo getUserInfo(){
    return _userInfo;
  }
}