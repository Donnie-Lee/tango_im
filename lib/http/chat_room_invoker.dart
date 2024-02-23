import '../models/response_data.dart';
import 'http.dart';

class ChatRoomInvoker {

  static Future<ResponseData> createRoom(data) async {
    return Http.invoke('POST', '/chatRoom', data: data);
  }
}