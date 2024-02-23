import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tango/components/avatar.dart';
import 'package:tango/components/option_item.dart';
import 'package:tango/http/chat_room_invoker.dart';
import 'package:tango/models/chat_room.dart';
import 'package:tango/models/response_data.dart';
import 'package:tango/models/token.dart';
import 'package:tango/models/user_info.dart';
import 'package:tango/pages/homes/call/call.dart';
import 'package:tango/pages/homes/chatroom/chat_room.dart';
import 'package:tango/store/token_storage.dart';

import '../../../constants/default_config.dart';
import '../../../store/db/ChatRoomDB.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage(this.userInfo, {super.key});

  UserInfo userInfo;

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                // padding: const EdgeInsets.only(bottom: 50, left: 20),
                height: 280,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    // borderRadius: const BorderRadius.only(
                    //     bottomLeft: Radius.elliptical(200, 50),
                    //     bottomRight: Radius.elliptical(200, 50)),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.8), BlendMode.dstATop),
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          widget.userInfo.bgImage ?? defaultBgImage,
                        ))),
              ),
              Positioned(
                  left: 28,
                  bottom: 50,
                  child: Avatar(widget.userInfo.avatar,
                      size: 100,
                      border: Border.all(color: Colors.white, width: 3))),
              Positioned(
                  left: 28,
                  bottom: 13,
                  child: Text(
                    widget.userInfo.nickname,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  )),
              Positioned(
                  left: 12,
                  top: 40,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white),
                  )),
              Positioned(
                  right: 12,
                  top: 40,
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    color: Colors.white,
                    onPressed: () {},
                  ))
            ],
          ),
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    offset: const Offset(0, 10),
                    blurRadius: 20,
                    spreadRadius: 00,
                  )
                ],
                color: Colors.white),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: 25, left: 25, right: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "关于",
                            style: TextStyle(fontSize: 17),
                          )),
                      Text(widget.userInfo.signInfo ?? '',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xff929292)))
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: 25, left: 25, right: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "所有动态",
                            style: TextStyle(fontSize: 17),
                          )),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(
                                widget.userInfo.trends.length,
                                (index) => Container(
                                      // padding: const EdgeInsets.only(bottom: 50, left: 20),
                                      height: 82,
                                      width: 82,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                          image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white.withOpacity(0.8),
                                                  BlendMode.dstATop),
                                              filterQuality: FilterQuality.low,
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                widget.userInfo.trends![index]
                                                    .images[0],
                                              ))),
                                    ))),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(
                      top: 25, bottom: 25, left: 25, right: 13),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userInfo.mobile,
                            style: TextStyle(fontSize: 17),
                          ),
                          Text("手机号",
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xff929292))),
                        ],
                      ),
                      Positioned(
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (_) {
                                      return CallPage();
                                    }));
                                  },
                                  icon: const Image(
                                    height: 28,
                                    width: 28,
                                    image:
                                        AssetImage('images/video_recorder.png'),
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Image(
                                    height: 28,
                                    width: 28,
                                    image: AssetImage('images/mobile.png'),
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    Token? token =
                                        await TokenStorage.getToken();
                                    List<int> ids = [];
                                    ids.add(widget.userInfo.id);
                                    ids.add(token!.loginId);
                                    ids.sort();
                                    String accountIds = "";
                                    for (int i = 0; i < ids.length; i++) {
                                      accountIds += "${ids[i]},";
                                    }
                                    accountIds = accountIds.substring(
                                        0, accountIds.length - 1);
                                    // 查询当前用户是否存在聊天室
                                    ChatRoomModel? result =
                                        await ChatRoomDB.findContactId(
                                            accountIds, token.loginId);
                                    if (result == null) {
                                      var dateStr =
                                          DateFormat('yyyy-MM-dd hh:mm:ss')
                                              .format(DateTime.now());
                                      // 若不存在，则创建聊天室
                                      result = ChatRoomModel.fromJson({
                                        "accountIds": accountIds,
                                        "type": 0,
                                        "unRead": 0,
                                        "userId": token.loginId,
                                        "createTime": dateStr,
                                        "updateTime": dateStr
                                      });
                                      ResponseData res =
                                          await ChatRoomInvoker.createRoom(
                                              result.toJson());
                                      if (res.code == 200) {
                                        result.chatRoomId = res.data;
                                        ChatRoomDB.insert(result);
                                      }
                                    }
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (_) {
                                      return ChatRoomPage(
                                          result!, widget.userInfo);
                                    }));
                                  },
                                  icon: const Image(
                                    height: 28,
                                    width: 28,
                                    image: AssetImage('images/chat_1.png'),
                                  ))
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: OptionItem(
              "加入黑名单",
              backgroundColor: Colors.white,
              textStyle:
                  const TextStyle(color: Color(0xffec5e68), fontSize: 15),
              prefixIcon: Image.asset(
                'images/black.png',
                height: 22,
                width: 22,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: OptionItem(
              "删除用户",
              backgroundColor: Colors.white,
              textStyle:
                  const TextStyle(color: Color(0xffec5e68), fontSize: 15),
              prefixIcon: Image.asset(
                'images/delete.png',
                height: 22,
                width: 22,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: OptionItem(
              "清空聊天信息",
              backgroundColor: Colors.white,
              textStyle:
                  const TextStyle(color: Color(0xffec5e68), fontSize: 15),
              prefixIcon: Image.asset(
                'images/clean.png',
                height: 22,
                width: 22,
              ),
            ),
          )
        ],
      ),
    ));
  }
}
