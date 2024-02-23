import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tango/models/WebSocketClient.dart';
import 'package:tango/models/token.dart';
import 'package:tango/store/token_storage.dart';

import '../../../components/avatar.dart';
import '../../../components/messageInput/message_input.dart';
import '../../../models/WebSocketRequest.dart';
import '../../../models/chat_record.dart';
import '../../../models/chat_room.dart';
import '../../../models/user_info.dart';
import '../../../notifier/ChatRecordModelChangeNotifier.dart';
import '../../../notifier/ChatRoomModelChangeNotifier.dart';
import '../../../store/db/ChatRecordDB.dart';
import '../../../store/db/ChatRoomDB.dart';
import 'message_item.dart';

class ChatRoomPage extends StatefulWidget {
  ChatRoomPage(this.chatRoomModel, this.userInfo, {super.key});

  ChatRoomModel chatRoomModel;
  UserInfo userInfo;

  @override
  State<ChatRoomPage> createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  late ScrollController _scrollController;
  late GlobalKey<MessageInputState> _messageInputKey;
  List<ChatRecordModel> _messages = [];
  late int loginId;
  bool _newMessage = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    ChatRecordModelChangeNotifier().removeListener(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent <=
          _scrollController.offset + 50) {
        setState(() {
          _newMessage = false;
        });
      }
    });
    _messageInputKey = GlobalKey<MessageInputState>();
    TokenStorage.getToken().then((token) => {
          setState(() {
            loginId = token!.loginId;
          })
        });
    // 加载本地消息
    ChatRecordDB.findAll(widget.chatRoomModel.chatRoomId).then((records) => {
          if (records != null)
            {
              records.forEach((element) {
                _messages.add(element);
              }),
              setState(() {
                _messages = _messages;
              }),
              Future.delayed(const Duration(milliseconds: 100), () {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              })
            }
        });
    // 监听收到消息内容
    ChatRecordModelChangeNotifier().addListener(() {
      ChatRecordModel chatRecordModel =
          ChatRecordModelChangeNotifier().chatRecordModel;
      if (chatRecordModel.chatRoomId == widget.chatRoomModel.chatRoomId) {
        if (!mounted) {
          return;
        }
        ChatRoomDB.clearUnRead(widget.chatRoomModel.chatRoomId!);
        setState(() {
          _messages.add(chatRecordModel);
        });
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    // 清除未付标记
    ChatRoomDB.clearUnRead(widget.chatRoomModel.chatRoomId!);
    // 通知消息列表刷新
    ChatRoomModelChangeNotifier()
        .notifyRefreshList(widget.chatRoomModel.chatRoomId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff4f5f8),
        body: buildBody());
  }

  _onSendMessage(message) async {
    Token? token = await TokenStorage.getToken();
    List<String> ids = widget.chatRoomModel.accountIds.split(",");
    ids.remove(token!.loginId);
    var chatRecordModel = ChatRecordModel.fromJson({
      "chatRoomId": widget.chatRoomModel.chatRoomId,
      "senderId": token.loginId,
      "receiverId": ids[0],
      "message": message,
      "messageType": 0,
      "sendTime": intl.DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
      "canceled": 0,
      "status": 0
    });

    setState(() {
      _messages.add(chatRecordModel);
    });

    var id = await ChatRecordDB.insert(chatRecordModel);
    chatRecordModel.id = id;

    WebSocketRequest webSocketRequest =
        WebSocketRequest.buildStringRequest("send");
    webSocketRequest.setBody(chatRecordModel.toJson());
    WebSocketUtility().sendMessage(webSocketRequest.toJson());

    chatRecordModel.status = 1;
    ChatRecordDB.sendCompleted(chatRecordModel);
    ChatRoomDB.updateTheNewestMsg(
        chatRecordModel.chatRoomId,
        chatRecordModel.message,
        chatRecordModel.sendTime,
        chatRecordModel.messageType);
    ChatRoomModelChangeNotifier().notifyRefreshList(chatRecordModel.chatRoomId);
  }

  _onKeyBoardUp(height) {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  _onSendMessageCompleted() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  buildBody() {
    return Column(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () {
            _messageInputKey.currentState?.closeKeyboard();
          },
          child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messageItem(_messages[index]);
              }),
        )),
        MessageInput(
          key: _messageInputKey,
          onKeyBoardUp: _onKeyBoardUp,
          onSendMessage: _onSendMessage,
          onSendMessageCompleted: _onSendMessageCompleted,
        )
      ],
    );
  }

  _messageItem(ChatRecordModel chatRecordModel) {
    bool self = loginId == chatRecordModel.senderId.toString();
    return Container(
      padding: const EdgeInsets.only(top: 8, right: 10, left: 10),
      alignment: self ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        textDirection: self ? TextDirection.rtl : TextDirection.ltr,
        children: [
          MessageItem(
            chatRecordModel,
            self: self,
          )
        ],
      ),
    );
  }

  buildActions() {
    return [
      SizedBox(
          width: 35,
          height: 18,
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Image.asset('images/video_recorder_white.png'))),
      SizedBox(
          width: 35,
          height: 18,
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Image.asset('images/phone.png'))),
      SizedBox(
          width: 35,
          height: 18,
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_rounded,
                size: 18,
                color: Colors.white,
              )))
    ];
  }

  buildAppBar() {
    return AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Avatar(widget.userInfo.avatar),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.userInfo.nickname,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ))
          ],
        ),
        titleSpacing: 0,
        actions: buildActions(),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff9773e7),
              Color(0xff7280e6),
            ],
            stops: [
              0.1,
              0.5,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        )));
  }
}
