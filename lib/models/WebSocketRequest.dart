import 'dart:convert';

class WebSocketRequest {
  Map<String, dynamic>? header;
  dynamic body;
  late int requestNo;


  setBody(dynamic body) {
    this.body = body;
  }

  setHeader(Map<String, dynamic> header) {
    this.header = header;
  }

  addHeader(String key, dynamic value) {
    header ??= <String, dynamic>{};
    header![key] = value;
  }

  addHeaders(Map<String, dynamic> headers) {
    header ??= <String, dynamic>{};
    header!.addAll(headers);
  }


  Map<String, dynamic> toJson() => {'header': header, 'body': body};

  static WebSocketRequest buildByteRequest(String processMethod){
    WebSocketRequest webSocketRequest = WebSocketRequest();
    webSocketRequest.requestNo = DateTime.now().microsecondsSinceEpoch;
    webSocketRequest.addHeader("messageType", 1);
    webSocketRequest.addHeader("processMethod", processMethod);
    return webSocketRequest;
  }

  static WebSocketRequest  buildStringRequest(String processMethod){
    WebSocketRequest webSocketRequest = WebSocketRequest();
    webSocketRequest.requestNo = DateTime.now().microsecondsSinceEpoch;
    webSocketRequest.addHeader("messageType", 0);
    webSocketRequest.addHeader("processMethod", processMethod);
    return webSocketRequest;
  }

}

