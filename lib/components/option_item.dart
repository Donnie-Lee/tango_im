import 'package:flutter/material.dart';

class Option {
   Widget? prefixIcon;
   Icon? suffixIcon;
   String title;
   TextAlign? textAlign;
   TextStyle? textStyle;
   VoidCallback? onPressed;
   Color? backgroundColor;
   Option(this.title, {this.prefixIcon, this.suffixIcon, this.textAlign, this.onPressed, this.textStyle});
}


class OptionItem extends StatelessWidget {
  const OptionItem(this.title,
      {super.key,
      this.prefixIcon,
      this.suffixIcon,
      this.backgroundColor = Colors.transparent,
      this.textAlign = TextAlign.left,
      this.textStyle = const TextStyle(color: Colors.black, fontSize: 17),
      this.onPressed});

  final Widget? prefixIcon;
  final Icon? suffixIcon;
  final String title;
  final Color backgroundColor;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    if (prefixIcon != null) {
      list.add(prefixIcon!);
    }
    list.add(Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(title, style: textStyle, textAlign: textAlign),
    )));
    if (suffixIcon != null) {
      list.add(suffixIcon!);
    }
    return Material(
        color: backgroundColor,
        child: Ink(
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(
            //             color: Color.fromARGB(80, 0, 0, 0), width: 0.5))),
            child: InkWell(
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(children: list),
            ),
          ),
          onTap: () {
            if (onPressed != null) {
              onPressed!();
            }
          },
        )));
  }
}
