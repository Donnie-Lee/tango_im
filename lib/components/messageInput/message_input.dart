import 'dart:async';

import 'package:flutter/material.dart';

import 'InputType.dart';

class MessageInput extends StatefulWidget {
  const MessageInput(
      {super.key,
      this.onKeyBoardUp,
      this.onKeyBoardDown,
      this.onSendMessage,
      this.onSendMessageCompleted});

  final Function? onKeyBoardUp;
  final Function? onKeyBoardDown;
  final Function? onSendMessage;
  final Function? onSendMessageCompleted;

  @override
  State<MessageInput> createState() => MessageInputState();
}

class MessageInputState extends State<MessageInput>
    with WidgetsBindingObserver {
  late FocusNode _focusNode;
  late TextEditingController _messageController;
  bool _voidceMode = false;
  bool _visible = false;
  bool _speaking = false;
  bool _turning = false;
  bool _show = false;
  double _bottomContentHeight = 0;
  double _maxContentHeight = 200;
  InputType _type = InputType.text;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _messageController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _type = InputType.text;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _focusNode.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      final double viewInsetsBottom = EdgeInsets.fromViewPadding(
              View.of(context).viewInsets, View.of(context).devicePixelRatio)
          .bottom;

      if (viewInsetsBottom > 0 && _bottomContentHeight < viewInsetsBottom) {
        // _updateHeight(viewInsetsBottom);
        if (_maxContentHeight < viewInsetsBottom) {
          setState(() {
            _maxContentHeight = viewInsetsBottom;
          });
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_show && _bottomContentHeight == _maxContentHeight) {
          return;
        }
        if (_type == InputType.text || _type == InputType.voice) {
          _updateHeight(MediaQuery.of(context).viewInsets.bottom);
        }

        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          if (widget.onKeyBoardDown != null) {
            widget.onKeyBoardDown!();
          }
          /// 键盘收回
        } else {
          if (widget.onKeyBoardUp != null) {
            widget.onKeyBoardUp!(viewInsetsBottom);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _messageInput();
  }

  closeKeyboard() {
    setState(() {
      _show = false;
    });
    _focusNode.unfocus();
    Timer(const Duration(milliseconds: 300), () {
      _updateHeight(0.0);
    });
  }

  _updateHeight(height) {
    setState(() {
      _bottomContentHeight = height;
    });
  }

  _messageInput() {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: IconButton(
                  icon: Icon(
                    _voidceMode ? Icons.keyboard : Icons.keyboard_voice,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _bottomContentHeight = 0;
                      _voidceMode = !_voidceMode;
                      if (_voidceMode) {
                        _type = _voidceMode ? InputType.voice : InputType.text;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                  child: _voidceMode
                      ? InkWell(
                          onTapDown: (details) => {startSpeak()},
                          onTapCancel: () {
                            stopSpeak();
                          },
                          onTapUp: (details) => {stopSpeak()},
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: _speaking,
                                  child: _turning
                                      ? const Icon(
                                          Icons.settings_voice,
                                          size: 16,
                                        )
                                      : const Icon(
                                          Icons.settings_voice_outlined,
                                          size: 16,
                                        ),
                                ),
                                const Text(
                                  '按住说话',
                                )
                              ],
                            ),
                          ),
                        )
                      : TextField(
                          focusNode: _focusNode,
                          onChanged: (value) {
                            setState(() {
                              _visible = value.isNotEmpty;
                            });
                          },
                          controller: _messageController,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 0, bottom: 0),
                              constraints:
                                  BoxConstraints(maxHeight: 40, minHeight: 36),
                              border: InputBorder.none,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                        )),
              InkWell(
                onTap: () {
                  setState(() {
                    _show = true;
                    _type = InputType.emoji;
                    _updateHeight(_maxContentHeight);
                  });
                  if (_focusNode.hasFocus) {
                    _focusNode.unfocus();
                  }
                },
                child: const SizedBox(
                  width: 40,
                  child: Icon(
                    Icons.mood,
                    color: Colors.grey,
                  ),
                ),
              ),
              Visibility(
                  visible: !_visible,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _show = true;
                        _type = InputType.other;
                        _updateHeight(_maxContentHeight);
                      });
                      if (_focusNode.hasFocus) {
                        _focusNode.unfocus();
                      }
                    },
                    child: const SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.add_box,
                        color: Colors.grey,
                      ),
                    ),
                  )),
              Visibility(
                visible: _visible,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff7f7ce7)),
                      ),
                      onPressed: () {
                        _send();
                      },
                      child: const Text(
                        '发送',
                        style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 0, fontWeight: FontWeight.normal),
                      )),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: _bottomContentHeight,
          color: Colors.grey,
        )
      ],
    );
  }

  _send() {
    if (widget.onSendMessage != null) {
      widget.onSendMessage!(_messageController.text);
    }
    _focusNode.requestFocus();
    setState(() {
      _messageController.text = "";
      _visible = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.onSendMessageCompleted != null) {
        widget.onSendMessageCompleted!();
      }
    });
  }

  void startSpeak() {
    setState(() {
      _speaking = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _turning = !_turning;
      });
      if (!_speaking) {
        timer.cancel();
      }
    });
  }

  void stopSpeak() {
    setState(() {
      _speaking = false;
    });
  }
}
