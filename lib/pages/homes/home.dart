import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:tango/http/user_invoker.dart';
import 'package:tango/pages/homes/contact/contacts.dart';
import 'package:tango/pages/homes/message/message_list.dart';
import 'package:tango/store/db/ChatRoomDB.dart';
import 'package:tango/store/token_storage.dart';
import '../../components/custom_animated_bottom_bar.dart';
import '../../constants/default_config.dart';
import '../../models/WebSocketClient.dart';
import '../../models/WebSocketRequest.dart';
import '../../models/chat_record.dart';
import '../../models/token.dart';
import '../../models/user_info.dart';
import '../../notifier/ChatRecordModelChangeNotifier.dart';
import '../../notifier/ChatRoomModelChangeNotifier.dart';
import '../../route/routes.dart';
import '../../store/db/ChatRecordDB.dart';
import '../../store/user_storage.dart';
import 'userinfo/my.dart';

class PageBody {
  late String title;
  late String appTitle;
  late Icon icon;
  late Color activeColor;
  late Color inactiveColor;
  Widget widget;
  IconButton? leading;
  Function? leadingAction;
  List<Widget>? actions;

  PageBody(this.title, this.appTitle, this.icon, this.activeColor,
      this.inactiveColor, this.widget,
      {this.leading, this.leadingAction, this.actions});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<String> bodyImages = [];
  List<PageBody>? _pages;
  GlobalKey<MessageListPageState> messageListPageState =
      GlobalKey<MessageListPageState>();
  ChatRecordModelChangeNotifier chatRecordModelChangeNotifier =
      ChatRecordModelChangeNotifier();
  final player = AudioPlayer();

  buildPages() {
    _pages = [];
    _pages?.add(PageBody(
        '聊天',
        '消息',
        const Icon(Icons.chat_bubble_outline),
        const Color(0xff6385e6),
        const Color(0xffa4afcf),
        const MessageListPage(),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.format_list_bulleted_sharp),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ]));
    _pages?.add(PageBody('通讯录', '通讯录', const Icon(Icons.contact_page_outlined),
        const Color(0xff6385e6), const Color(0xffa4afcf), const ContactsPage(),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.format_list_bulleted_sharp),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ]));
    _pages?.add(PageBody(
      '个人中心',
      '个人中心',
      const Icon(Icons.person_outline_outlined),
      const Color(0xff6385e6),
      const Color(0xffa4afcf),
      const MyPage(),
    ));
  }

  @override
  void initState() {
    super.initState();

    TokenStorage.getToken().then((token) => {
          if (token == null)
            {Navigator.of(context).pushReplacementNamed(RouteConfig.login)}
          else
            {
              // 获取当前用户信息
              UserInvoker.currentUser().then((data) => {
                    if (data.code == 200)
                      {
                        UserStorage.setUserInfo(UserInfo.fromJson(data.data)),
                        connectWS()
                      }
                    else
                      {
                        GFToast.showToast(data.message, context,
                            backgroundColor: const Color(0xffdadada),
                            textStyle: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            toastPosition: GFToastPosition.CENTER),
                        Navigator.of(context)
                            .pushReplacementNamed(RouteConfig.login)
                      }
                  }),
            }
        });
    _pageController = PageController();
    buildPages();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget getBody() {
    return PageView.builder(
        onPageChanged: (value) {
          setState(() {
            if (value == 0) {
              messageListPageState.currentState?.refresh();
            }
            _currentIndex = value;
          });
        },
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: _pages!.length,
        itemBuilder: (context, index) {
          return _pages![index].widget;
        });
  }

  CustomAnimatedBottomBar buildBottomNavigationBar() {
    return CustomAnimatedBottomBar(
        backgroundColor: const Color(0xfff8f8f8),
        containerHeight: 60,
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeInOut,
        onItemSelected: (index) => setState(() => {
              _currentIndex = index,
              _pageController
                  .jumpTo(MediaQuery.of(context).size.width * _currentIndex)
              // 动画切换
              //   _pageController.animateToPage(
              //       _currentIndex,
              //       duration: const Duration(milliseconds: 200),
              //       curve: Curves.easeInSine)
            }),
        items: List.generate(_pages!.length, (index) {
          return bottomNavigationBarItem(_pages![index]);
        }));
  }

  MyBottomNavigationBarItem bottomNavigationBarItem(PageBody pageBody) {
    return MyBottomNavigationBarItem(
      icon: pageBody.icon,
      title: Text(
        pageBody.title,
        style: const TextStyle(fontSize: 12),
      ),
      activeColor: pageBody.activeColor,
      inactiveColor: pageBody.inactiveColor,
      textAlign: TextAlign.center,
    );
  }

  connectWS() async {
    Token? token = await TokenStorage.getToken();
    WebSocketUtility().initWebSocket(onOpen: () {
      WebSocketUtility().initHeartBeat();
      // 登录连接
      WebSocketRequest webSocketRequest =
          WebSocketRequest.buildStringRequest("login");
      webSocketRequest.setBody(
          {"userId": token!.loginId, "username": '张三', "password": "admin"});
      WebSocketUtility().sendMessage(webSocketRequest.toJson());
    }, onMessage: (data) async {
      var chatRecordModel = ChatRecordModel.fromJson(jsonDecode(data));
      await ChatRecordDB.insert(chatRecordModel);
      ChatRoomDB.updateTheNewestMsgUnReadIncrement(
          chatRecordModel.chatRoomId,
          chatRecordModel.message,
          chatRecordModel.sendTime,
          chatRecordModel.messageType);
      ChatRecordModelChangeNotifier().setChatRecordModel(chatRecordModel);
      ChatRoomModelChangeNotifier()
          .notifyRefreshList(chatRecordModel.chatRoomId);
      player.play(UrlSource(ding1Message));
    }, onError: (e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _pages![_currentIndex].leading,
        automaticallyImplyLeading: _pages![_currentIndex].leading != null,
        title: Text(_pages![_currentIndex].appTitle),
        actions: _pages![_currentIndex].actions,
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF6385e6),
              Color(0xFFb36ae8),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          ),
        ),
      ),
      body: getBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
