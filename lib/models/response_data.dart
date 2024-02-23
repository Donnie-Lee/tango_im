class ResponseData {
  int code;
  String message;
  dynamic data;
  int timestamp;

  ResponseData.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'],
        data = json['data'],
        timestamp = json['timestamp'];


}
