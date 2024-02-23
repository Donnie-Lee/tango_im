import 'package:flutter/material.dart';
import 'package:tango/models/chat_record.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(this.message, {super.key, this.self = false});

  final ChatRecordModel message;
  final bool self;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: self
                  ? const LinearGradient(
                      colors: [
                        Color(0xff9375e7),
                        Color(0xff7f7ce7),
                      ],
                      stops: [
                        0.1,
                        0.4,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )
                  : null,
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              message.message,
              style: TextStyle(
                  color: self ? Colors.white : Colors.black, fontSize: 14),
            ),
          ),
        ),
        self ? Positioned(
          top: 30,
            right: 3,
            child: Container(
          height: 0,
          width: 0,
          decoration: const BoxDecoration(
              border:  Border(
                bottom: BorderSide(
                    color: Colors.transparent,                  // 朝上; 其他的全部透明transparent或者不设置
                    width: 8,
                    style: BorderStyle.solid),
                right: BorderSide(
                    color: Color(0xff9375e7),     // 朝左;  把颜色改为目标色就可以了；其他的透明
                    width: 8,
                    style: BorderStyle.solid),
                left: BorderSide(
                    color: Colors.transparent,   // 朝右；把颜色改为目标色就可以了；其他的透明
                    width: 8,
                    style: BorderStyle.solid),
                top: BorderSide(
                    color: Colors.transparent,  // 朝下;  把颜色改为目标色就可以了；其他的透明
                    width: 8,
                    style: BorderStyle.solid),
              ),
        ))) : Positioned(
            top: 30,
            left: 3,
            child: Container(
                height: 0,
                width: 0,
                decoration: const BoxDecoration(
                  border:  Border(
                    bottom: BorderSide(
                        color: Colors.transparent,                  // 朝上; 其他的全部透明transparent或者不设置
                        width: 8,
                        style: BorderStyle.solid),
                    right: BorderSide(
                        color: Colors.transparent,     // 朝左;  把颜色改为目标色就可以了；其他的透明
                        width: 8,
                        style: BorderStyle.solid),
                    left: BorderSide(
                        color: Colors.white,   // 朝右；把颜色改为目标色就可以了；其他的透明
                        width: 8,
                        style: BorderStyle.solid),
                    top: BorderSide(
                        color: Colors.transparent,  // 朝下;  把颜色改为目标色就可以了；其他的透明
                        width: 8,
                        style: BorderStyle.solid),
                  ),
                ))),

      ],
    );
  }
}
