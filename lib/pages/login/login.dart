import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';

import '../../components/key_board_container.dart';
import '../../constants/regex_contants.dart';
import '../../http/user_invoker.dart';
import '../../models/token.dart';
import '../../route/routes.dart';
import '../../store/storage.dart';
import '../../store/token_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ScrollController _sc;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _sc = ScrollController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _sc.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  onLogin() {
    if (_formKey.currentState!.validate()) {
      var params = {
        "username": _usernameController.text,
        "password": _passwordController.text,
      };
      Token token;
      SharedStorage storage;
      UserInvoker.login(params).then((res) async => {
            if (res.code == 200)
              {
                token = Token.fromJson(res.data),
                TokenStorage.setToken(token),
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(RouteConfig.home, (route) => false)
              }
            else
              {
                GFToast.showToast(res.message, context,
                    backgroundColor: Color(0xffdadada),
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
            backgroundColor: Theme.of(context).colorScheme.background,
            resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          controller: _sc,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                                height: 200,
                                width: double.infinity,
                                child: Image.asset('images/login-logo.png'),
                              ),
                              Text("TANGO",
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(24, 48, 24, 20),
                                child: Column(
                                  children: [
                                    Material(
                                      elevation: 2,
                                      shadowColor: const Color.fromRGBO(
                                          69, 91, 99, 0.05),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '请输入手机号';
                                          }
                                          if (!mobileRegExp.hasMatch(value)) {
                                            return '手机号格式错误';
                                          }
                                          return null;
                                        },
                                        controller: _usernameController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                                Icons.phone_android,
                                                color: Colors.grey),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    20.0, 0, 0, 0),
                                            // constraints: const BoxConstraints(minHeight: 104),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: inputBorder(),
                                            focusedBorder: inputBorder(),
                                            border: inputBorder(),
                                            errorBorder: inputBorder(),
                                            focusColor: Colors.transparent,
                                            hintText: '手机号',
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                            )),
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 0),
                                        child: Stack(
                                          children: [
                                            Material(
                                              elevation: 2,
                                              shadowColor: const Color.fromRGBO(
                                                  69, 91, 99, 0.05),
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return '请输入密码';
                                                  }
                                                  return null;
                                                },
                                                controller: _passwordController,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                      Icons.security,
                                                      color: Colors.grey,
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .fromLTRB(
                                                            20.0, 0, 0, 0),
                                                    // constraints: const BoxConstraints(minHeight: 104),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder:
                                                        inputBorder(),
                                                    focusedBorder:
                                                        inputBorder(),
                                                    border: inputBorder(),
                                                    errorBorder: inputBorder(),
                                                    focusColor:
                                                        Colors.transparent,
                                                    hintText: '密码',
                                                    hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                    )),
                                              ),
                                            ),
                                            Positioned(
                                                right: 0,
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    '忘记密码？',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        letterSpacing: 0,
                                                        color: Colors.black),
                                                  ),
                                                ))
                                          ],
                                        )),
                                    Center(
                                        widthFactor: double.infinity,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width: 180,
                                          child: TextButton(
                                              onPressed: () {},
                                              child: const Row(children: [
                                                Text(
                                                  "还没有账号？",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      color: Color(0xff929292)),
                                                ),
                                                Text("马上注册",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      color: Color(0xff333333),
                                                    ))
                                              ])),
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          onLogin();
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9))),
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size(
                                                        double.maxFinite, 52)),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) {
                                              return const Color(0xFF6385e6);
                                            })),
                                        child: const Text(
                                          '登录',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  "其他账号登录",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      color: Color(0xff929292)),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: buildOtherLogin(),
                                ),
                              )
                            ],
                          ))),
                  KeyBoardContainer(
                    onKeyBoard: () {
                      _sc.jumpTo(_sc.position.maxScrollExtent);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.transparent));
  }

  List<Widget> buildOtherLogin() {
    List<LoginType> loginOthers = [
      LoginType('images/mobile_login.png', RouteConfig.mobileLoginCheck),
    ];

    return List.generate(
      loginOthers.length,
      (index) => MaterialButton(
        child: Image.asset(
          loginOthers[index].image,
          width: 50,
          height: 50,
        ),
        onPressed: () {
          _formKey.currentState!.reset();
          Navigator.of(context).pushNamed(loginOthers[index].route);
        },
      ),
    );
  }
}

class LoginType {
  late String image;
  late String route;

  LoginType(this.image, this.route);
}
