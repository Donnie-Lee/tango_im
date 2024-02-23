

class ChatRecordModel{


   int? id;
   int chatRoomId;
   String senderId;
   String? receiverId;
   dynamic message;
   int messageType;
   String sendTime;
   int canceled;
   int? quoteId;
   int? status;


   ChatRecordModel.fromJson(Map<String, dynamic> json)
       : id = json['id'],
         chatRoomId = json['chatRoomId'],
         receiverId = json['receiverId'],
         senderId = json['senderId'],
         message = json['message'],
         messageType = json['messageType'],
         canceled = json['canceled'],
         quoteId = json['quoteId'],
         status = json['status'],
         sendTime = json['sendTime'];

   Map<String, dynamic> toJson() {
     final map = <String, dynamic>{};
     map['id'] = id;
     map['chatRoomId'] = chatRoomId;
     map['receiverId'] = receiverId;
     map['senderId'] = senderId;
     map['message'] = message;
     map['messageType'] = messageType;
     map['canceled'] = canceled;
     map['quoteId'] = quoteId;
     map['status'] = status;
     map['sendTime'] = sendTime;
     return map;
   }
}