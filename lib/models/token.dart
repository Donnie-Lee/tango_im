class Token {
  String tokenName;
  String tokenValue;
  int loginId;

  Token.fromJson(Map<String, dynamic> json)
      : tokenName = json['tokenName'],
        tokenValue = json['tokenValue'],
        loginId = json['loginId'];

  Token(this.tokenName, this.tokenValue, this.loginId);
}
