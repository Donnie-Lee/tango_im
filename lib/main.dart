import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tango/route/routes.dart';
import './store/storage.dart';
import 'notifier/NavigatorProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    ThemeData light = ThemeData(
        colorScheme: const ColorScheme.light(
            background: Color.fromRGBO(249, 250, 253, 1)),
        brightness: Brightness.light,
        textTheme: const TextTheme(
            labelLarge: TextStyle(
                fontSize: 48,
                letterSpacing: 14.4,
                color: Color.fromRGBO(180, 187, 201, 1),
                fontWeight: FontWeight.bold)));

    ThemeData dark = ThemeData(
        colorScheme: const ColorScheme.dark(
            background: Color.fromRGBO(249, 250, 253, 1)),
        brightness: Brightness.dark,
        textTheme: const TextTheme(
            labelLarge: TextStyle(
                fontSize: 48,
                letterSpacing: 14.4,
                color: Color.fromRGBO(180, 187, 201, 1),
                fontWeight: FontWeight.bold)));

    return MaterialApp(
      navigatorKey: NavigatorProvider.navigatorKey,
      theme:  light,
      initialRoute: RouteConfig.home,
      routes: RouteConfig.buildRoute(),
    );
  }

}
