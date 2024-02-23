import 'package:flutter/material.dart';
import 'package:tango/components/option_item.dart';
import 'package:tango/constants/default_config.dart';
import 'package:tango/http/user_invoker.dart';
import 'package:tango/models/response_data.dart';
import 'package:tango/models/user_info.dart';
import 'package:tango/pages/homes/userinfo/userinfo.dart';

import '../../../route/routes.dart';
import '../../../store/token_storage.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<UserInfo?>? getUserInfo() async {
    ResponseData res = await UserInvoker.currentUser();
    if (res.code == 200) {
      return UserInfo.fromJson(res.data!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<UserInfo?>(
              future: getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                  UserInfo userInfo = snapshot.data!;
                  return Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      height: 80,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                          spreadRadius: 00,
                        )
                      ]),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return UserInfoPage(userInfo);
                          }));
                        },
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: ClipOval(
                                    child: Image.network(
                                        userInfo.avatar ??
                                            defaultAvatar,
                                        colorBlendMode: BlendMode.color,
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover)),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userInfo.nickname,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(userInfo.signInfo ?? "",
                                        style: const TextStyle(
                                            color: Color(0xff636363),
                                            fontSize: 14)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ));
                }
                throw "should not happen";
              }),
          Container(
              margin: const EdgeInsets.only(top: 24, bottom: 24),
              padding: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  offset: const Offset(0, 10),
                  blurRadius: 20,
                  spreadRadius: 00,
                ),
              ]),
              child: Column(
                children: buildOptions(),
              ))
        ],
      ),
    );
  }

  buildOptions() {
    List<Option> options = [];
    options.add(Option("个人资料",
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.grey,
        ),
        prefixIcon: Image.asset(
          'images/userinfo.png',
          height: 40,
          width: 40,
        )));
    options.add(Option("聊天",
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.grey,
        ),
        prefixIcon: Image.asset(
          'images/chat.png',
          height: 40,
          width: 40,
        )));
    options.add(Option("通知",
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.grey,
        ),
        prefixIcon: Image.asset(
          'images/notification.png',
          height: 40,
          width: 40,
        )));
    options.add(Option("隐私设置",
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.grey,
        ),
        prefixIcon: Image.asset(
          'images/security.png',
          height: 40,
          width: 40,
        )));
    options.add(Option("帮助中心",
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.grey,
        ),
        prefixIcon: Image.asset(
          'images/help.png',
          height: 40,
          width: 40,
        )));
    options.add(Option("关于我们",
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.grey,
        ),
        prefixIcon: Image.asset(
          'images/about.png',
          height: 40,
          width: 40,
        )));
    options.add(Option("退出登录",
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.grey,
        ),
        prefixIcon: Image.asset(
          'images/exit.png',
          height: 40,
          width: 40,
        ), onPressed: () {
      showGeneralDialogFunction(context);
    }));

    return List.generate(
        options.length,
        (index) => OptionItem(options[index].title,
            suffixIcon: options[index].suffixIcon,
            prefixIcon: options[index].prefixIcon,
            onPressed: options[index].onPressed));
  }

  /// showBottomSheet：底部弹窗
  showGeneralDialogFunction(context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "提示",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          content: const Text(
            "确定退出吗？",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "取消",
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
            TextButton(
                onPressed: () async {
                  TokenStorage.clearToken();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteConfig.login, (Route<dynamic> route) => false);
                },
                child: const Text(
                  "确定",
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                )),
          ],
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(
          alignment: Alignment.center,
          scale: animation,
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
