import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tango/http/user_invoker.dart';
import 'package:tango/pages/login/check_code.dart';

import '../../constants/regex_contants.dart';
import '../../route/routes.dart';

class MobileLoginCheckPage extends StatefulWidget {
  const MobileLoginCheckPage({super.key});

  @override
  State<MobileLoginCheckPage> createState() => _MobileLoginCheckPageState();
}

class _MobileLoginCheckPageState extends State<MobileLoginCheckPage> {
  late TextEditingController _mobileController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _mobileController.dispose();
  }

  getCheckCode() async {
    if (_formKey.currentState!.validate()) {
      // 获取验证码
      UserInvoker.getCheckCode(_mobileController.text).then((res) => {
            if (res.code == 200)
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return CheckCodePage(mobile: _mobileController.text);
                }))

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
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            centerTitle: true),
        body: Center(
            child: Form(
                key: _formKey,
                child: Container(
                    margin: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 48),
                          width: double.maxFinite,
                          child: const Text(
                            '手机号登录',
                            style: TextStyle(
                              color: Colors.black,
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 48),
                          width: double.maxFinite,
                          child: const Text(
                            '未注册的手机号验证后将自动创建',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Material(
                          child: TextFormField(
                            style:
                                const TextStyle(letterSpacing: 5, fontSize: 30, color: Colors.grey),
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入手机号';
                              }
                              if (!mobileRegExp.hasMatch(value)) {
                                return '手机号格式错误';
                              }
                              return null;
                            },
                            controller: _mobileController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: inputBorder(),
                                prefixIcon: const Icon(Icons.phone_android,
                                    size: 30, color: Colors.grey),
                                // constraints: const BoxConstraints(minHeight: 104),
                                hintText: '手机号',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: ElevatedButton(
                            onPressed: () {
                              getCheckCode();
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(9))),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(double.maxFinite, 52)),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  return const Color(0xFF6385e6);
                                })),
                            child: const Text(
                              '下一步',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    )))),
      )),
    );
  }

  UnderlineInputBorder inputBorder() {
    return UnderlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.transparent));
  }
}
