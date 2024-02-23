
import 'http.dart';
import '../models/response_data.dart';

class UserInvoker {

  static Future<ResponseData> login(data) async {
    return Http.invoke('POST', '/account/login', data: data);
  }

  static Future<ResponseData> loginSms(data) async {
    return Http.invoke('POST', '/account/loginSms', data: data);
  }

  static Future<ResponseData> getCheckCode(mobile) async {
    return Http.invoke('GET', "/account/getCheckCode/$mobile");
  }

  static Future<ResponseData> currentUser() async {
    return Http.invoke('GET', "/account/currentUser");
  }

  static Future<ResponseData> accountInfo(id) async {
    return Http.invoke('GET', "/account/accountInfo/$id");
  }

  static Future<ResponseData> contacts() async {
    return Http.invoke('GET', "/account/contacts");
  }

}
