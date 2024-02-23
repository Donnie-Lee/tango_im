import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';

import '../../http/user_invoker.dart';
import '../../models/token.dart';
import '../../route/routes.dart';
import '../../store/storage.dart';
import '../../store/token_storage.dart';

class CheckCodePage extends StatefulWidget {
  CheckCodePage({super.key, required this.mobile});

  String mobile;

  @override
  State<CheckCodePage> createState() => _CheckCodePageState();
}

class _CheckCodePageState extends State<CheckCodePage> {
  late TextEditingController _checkCodeController;
  late FocusNode _focusNode;
  late int _countdown;
  bool _lock = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    countDown();
    _checkCodeController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _checkCodeController.selection = TextSelection.fromPosition(
          TextPosition(offset: _checkCodeController.text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _checkCodeController.dispose();
    _focusNode.dispose();
  }

  countDown() {
    _countdown = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        _countdown--;
      });
      if (_countdown == 0) {
        timer.cancel();
        setState(() {
          _countdown = -1;
        });
      }
    });
  }

  getCheckCode() async {
    if (!_lock && _countdown < 0) {
      _lock = true;
      // 获取验证码
      UserInvoker.getCheckCode(widget.mobile).then((res) => {
            _lock = false,
            if (res.code == 200)
              {
                countDown(),
              }
            else
              {
                GFToast.showToast(res.message, context,
                    backgroundColor: const Color(0xffdadada),
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.black),
                    toastPosition: GFToastPosition.CENTER)
              }
          });
    }
  }

  loginSms() {
    var params = {
      "mobile": widget.mobile,
      "checkCode": _checkCodeController.text
    };
    Token token;
    UserInvoker.loginSms(params).then((res) async => {
          if (res.code == 200)
            {
              token = Token.fromJson(res.data),
              TokenStorage.setToken(token),
              timer.cancel(),
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(RouteConfig.home, (route) => false),

            }
          else
            {
              GFToast.showToast(res.message, context,
                  backgroundColor: const Color(0xffdadada),
                  textStyle: const TextStyle(fontSize: 15, color: Colors.black),
                  toastPosition: GFToastPosition.CENTER)
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Material(
            child: Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.grey,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    centerTitle: true),
                body: Container(
                  margin: const EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "输入你收到的验证码",
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                      const Center(
                        child: Text("请在下方输入你收到的验证码",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Stack(children: [
                          Positioned(
                              top: 30,
                              left: 15,
                              right: 15,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: buildCheckCodeBorder())),
                          TextFormField(
                            focusNode: _focusNode,
                            style: const TextStyle(
                                color: Colors.grey,
                                letterSpacing: 50,
                                fontSize: 50),
                            autofocus: true,
                            validator: (value) {
                              return null;
                            },
                            cursorColor: Colors.transparent,
                            controller: _checkCodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: inputBorder(),
                              focusedBorder: inputBorder(),
                              enabledBorder: inputBorder(),
                              errorBorder: inputBorder(),
                              disabledBorder: inputBorder(),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            loginSms();
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9))),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(double.maxFinite, 52)),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                return const Color(0xFF6385e6);
                              })),
                          child: const Text(
                            '登录',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 20),
                        child: Row(children: [
                          const Text(
                            "没有接收到验证码短信？",
                          ),
                          TextButton(
                              onPressed: () {
                                getCheckCode();
                              },
                              child: Text(
                                _countdown > 0 ? "$_countdown秒后重新发送" : "重新发送",
                                style: const TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0,
                                    color: Colors.grey),
                              ))
                        ]),
                      ),
                    ],
                  ),
                ))));
  }

  List<Container> buildCheckCodeBorder() {
    return List.generate(
        4,
        (index) => Container(
              margin: const EdgeInsets.only(right: 15),
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2.0, color: Colors.grey),
                    left: BorderSide(width: 2.0, color: Colors.grey),
                    right: BorderSide(width: 2.0, color: Colors.grey),
                    bottom: BorderSide(width: 2.0, color: Colors.grey),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ));
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.transparent));
  }
}
