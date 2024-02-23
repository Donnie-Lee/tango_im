import 'package:flutter/material.dart';
import 'package:tango/models/contact.dart';

import '../constants/default_config.dart';
import '../pages/homes/userinfo/userinfo.dart';

class ChatInfoWidget extends StatefulWidget {
  const ChatInfoWidget(this.contactInfo, {super.key});

  final Contact contactInfo;

  @override
  State<ChatInfoWidget> createState() => _ChatInfoWidgetState();
}

class _ChatInfoWidgetState extends State<ChatInfoWidget> {
  Color getColor(status) {
    // 0 在线 1 离线 2 忙碌 3 离开
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return UserInfoPage(widget.contactInfo.accountInfo);
          }));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
          height: 60,
          child: Row(
            children: [
              Stack(
                children: [
                  ClipOval(
                      child: Image.network(
                          widget.contactInfo.accountInfo.avatar ??
                              defaultAvatar,
                          color: widget.contactInfo.status == 3
                              ? Colors.grey
                              : Colors.transparent,
                          colorBlendMode: BlendMode.color,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover)),
                  Visibility(
                      visible: widget.contactInfo.status != 3,
                      child: Positioned(
                          bottom: 0,
                          left: 5,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: getColor(widget.contactInfo.status),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                          )))
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color(0xffdedede),
                  ))),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contactInfo.accountInfo.nickname,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          Text(widget.contactInfo.accountInfo.signInfo ?? "",
                              style: const TextStyle(
                                  color: Color(0xff636363), fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
