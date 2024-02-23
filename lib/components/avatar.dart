import 'package:flutter/material.dart';
import 'package:tango/constants/default_config.dart';

class Avatar extends StatelessWidget {
  Avatar(this.image, {super.key, this.size = 40, this.border});

  double size;
  String? image;
  BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.all(Radius.circular(size)),
          image: DecorationImage(image: NetworkImage(image??defaultAvatar))),
    );
  }
}
