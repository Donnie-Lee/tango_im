import 'package:flutter/widgets.dart';
import 'package:tango/pages/homes/home.dart';

import '../pages/login/login.dart';
import '../pages/login/login_mobile_check.dart';

class RouteConfig {
  static const String home = "/";
  static const String login = "/login";
  static const String mobileLoginCheck = "/mobileLoginCheck";

  static Map<String, WidgetBuilder> buildRoute() {
    return {
      home: (context) => const HomePage(),
      login: (context) => const LoginPage(),
      mobileLoginCheck: (context) => const MobileLoginCheckPage(),
    };
  }
}
