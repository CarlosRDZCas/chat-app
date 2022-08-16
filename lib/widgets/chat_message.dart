import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;
  const ChatMessage(
      {Key? key,
      required this.text,
      required this.uid,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animationController,
    child: SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      child: Container(child: uid == '123' ? _myMessage() : _notMyMessage())));
  }

  Widget _notMyMessage() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(right: 50, left: 5, top: 5),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: const Color(0xffE4E5E8),
              borderRadius: BorderRadius.circular(20)),
          child: Text(text, style: const TextStyle(color: Colors.black87)),
        ));
  }

  Widget _myMessage() {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(right: 5, left: 50, top: 5),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: const Color(0xff4D9EF6),
              borderRadius: BorderRadius.circular(20)),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ));
  }
}