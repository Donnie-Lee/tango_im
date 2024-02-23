import 'package:flutter/material.dart';
import 'package:tango/http/user_invoker.dart';
import 'package:tango/models/chat_room.dart';
import 'package:tango/models/response_data.dart';
import 'package:tango/models/user_info.dart';
import 'package:tango/store/token_storage.dart';

import '../constants/default_config.dart';
import '../models/token.dart';
import '../notifier/ChatRoomModelChangeNotifier.dart';
import '../pages/homes/chatroom/chat_room.dart';
import '../store/db/ChatRoomDB.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(this.chatRoomModel, {super.key});

  ChatRoomModel chatRoomModel;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  int _status = 0;
  int? _chatRoomId;
  int? _unRead;
  dynamic _newestMsg;
  String? _newestMsgTime;
  int? _newestMsgType;
  UserInfo? _userInfo;

  Color getColor(status) {
    // 0 在线 1 离线 2 忙碌 3 离开
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  @override
  void initState() {
    // 如果当前是单聊，则检测用户状态
    super.initState();

    _chatRoomId = widget.chatRoomModel.chatRoomId;
    _unRead = widget.chatRoomModel.unRead;
    _newestMsg = widget.chatRoomModel.newestMsg;
    _newestMsgTime = widget.chatRoomModel.newestMsgTime;
    _newestMsgType = widget.chatRoomModel.newestMsgType;

    if (widget.chatRoomModel.type == 0) {
      List<String> ids = widget.chatRoomModel.accountIds.split(",");
      ResponseData res;
      TokenStorage.getToken().then((token) async => {
            ids.remove(token!.loginId.toString()),
            res = await UserInvoker.accountInfo(ids[0]),
            if (res.code == 200)
              {
                setState(() {
                  _userInfo = UserInfo.fromJson(res.data);
                })
              }
          });
    }

    ChatRoomModelChangeNotifier().addListener(() {
      if (ChatRoomModelChangeNotifier().chatRoomModelId == _chatRoomId) {
        ChatRoomDB.findChatRoomId(_chatRoomId!).then((chatRoomModel) => {
              if(mounted){
                setState(() {
                  _chatRoomId = chatRoomModel!.chatRoomId;
                  _unRead = chatRoomModel.unRead;
                  _newestMsg = chatRoomModel.newestMsg;
                  _newestMsgTime = chatRoomModel.newestMsgTime;
                  _newestMsgType = chatRoomModel.newestMsgType;
                })
              }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                ChatRoomPage(widget.chatRoomModel, _userInfo!),
            transitionsBuilder: (context, animated, _, child) {
              return SlideTransition(
                //转场动画
                position: Tween(
                  begin: const Offset(1, 0), //Offset一个2D小部件，将记录坐标轴的x=宽，y=高
                  end: Offset.zero, //动画曲线
                ).animate(animated), //获得动画
                child: child,
              );
            },
          ));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
          height: 60,
          child: Row(
            children: [
              Stack(
                children: [
                  ClipOval(
                      child: Image.network(_userInfo?.avatar ?? defaultAvatar,
                          color:
                              _status == 3 ? Colors.grey : Colors.transparent,
                          colorBlendMode: BlendMode.color,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover)),
                  Visibility(
                      visible: _status != 3,
                      child: Positioned(
                          bottom: 0,
                          left: 5,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: getColor(_status),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                          )))
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color(0xffdedede),
                  ))),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userInfo?.nickname ?? "",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            ),
                            Text(_newestMsg ?? "",
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Color(0xff636363),
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 5,
                          right: 4,
                          child: Text(_newestMsgTime ?? "",
                              style: const TextStyle(
                                  color: Color(0xff636363), fontSize: 10))),
                      Visibility(
                        visible: _unRead! > 0,
                        child: Positioned(
                            bottom: 35,
                            right: 4,
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xff6385e6),
                              ),
                              child: Text(
                                '$_unRead',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
