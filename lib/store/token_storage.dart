import '../models/token.dart';
import 'storage.dart';

class TokenStorage{

  static setToken(Token token) async {
    SharedStorage sharedStorage = await SharedStorage.getInstance();
    sharedStorage.setString("tokenName", token.tokenName);
    sharedStorage.setString("tokenValue", token.tokenValue);
    sharedStorage.setInt("loginId", token.loginId);
  }

  static clearToken() async {
    SharedStorage sharedStorage = await SharedStorage.getInstance();
    sharedStorage.remove("tokenName");
    sharedStorage.remove("tokenValue");
    sharedStorage.remove("loginId");
  }

  static Future<Token?> getToken() async {
    SharedStorage sharedStorage = await SharedStorage.getInstance();
    String? tokenName = sharedStorage.getString("tokenName");
    String? tokenValue = sharedStorage.getString("tokenValue");
    int? loginId = sharedStorage.getInt("loginId");

    if (tokenName == null) {
      return null;
    }

    return Token(
        tokenName,
        tokenValue!,
        loginId!
        );
  }
}