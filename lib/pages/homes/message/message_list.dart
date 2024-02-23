import 'package:flutter/material.dart';
import 'package:tango/store/token_storage.dart';

import '../../../components/chat_room.dart';
import '../../../models/chat_room.dart';
import '../../../notifier/ChatRoomModelChangeNotifier.dart';
import '../../../store/db/ChatRoomDB.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  State<MessageListPage> createState() => MessageListPageState();
}

class MessageListPageState extends State<MessageListPage> {
  List<ChatRoomModel> _data = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() {
    TokenStorage.getToken().then((token) => {
          ChatRoomDB.findAll(token!.loginId).then((res) => {
                if (mounted)
                  {
                    setState(() {
                      _data = res ?? [];
                    })
                  }
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children:
              List.generate(_data.length, (index) => ChatRoom(_data[index]))),
    );
  }
}
