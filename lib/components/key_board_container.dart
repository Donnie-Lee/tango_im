import 'package:flutter/material.dart';

class KeyBoardContainer extends StatefulWidget {
  KeyBoardContainer({super.key, this.child, this.onKeyBoard});

  final Widget? child;
  Function()? onKeyBoard;

  @override
  State<KeyBoardContainer> createState() => _KeyBoardContainerState();
}

class _KeyBoardContainerState extends State<KeyBoardContainer>
    with WidgetsBindingObserver {
  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      final double viewInsetsBottom = EdgeInsets.fromViewPadding(
              View.of(context).viewInsets, View.of(context).devicePixelRatio)
          .bottom;
      setState(() {
        _keyboardHeight = viewInsetsBottom;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (MediaQuery.of(context).viewInsets.bottom == 0) {
            /// 键盘收回
          } else {
            widget.onKeyBoard!();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _keyboardHeight,
      child: widget.child,
    );
  }
}
