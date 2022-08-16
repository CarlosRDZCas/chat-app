import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TextEditingController inputController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  maxRadius: 14,
                  child: const Text('To', style: TextStyle(fontSize: 12)),
                ),
                const Text('Tony Stark',
                    style: TextStyle(fontSize: 12, color: Colors.black87))
              ],
            ),
          )),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            height: 50,
            child: inputChat(),
          )
        ],
      ),
    );
  }

  Widget inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: inputController,
              onSubmitted: _handleSubmited,
              onChanged: (value) {
                setState(() {
                  value.trim().isNotEmpty
                      ? _estaEscribiendo = true
                      : _estaEscribiendo = false;
                });
              },
              decoration:
                  const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: !Platform.isIOS
                  ? IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmited(inputController.text.trim())
                            : null,
                      ),
                    )
                  : CupertinoButton(
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmited(inputController.text.trim())
                          : null,
                      child: const Text('Enviar'),
                    )),
        ],
      ),
    ));
  }

  _handleSubmited(String texto) {
    if (texto.isEmpty) return;

    print(texto);
    inputController.clear();
    _focusNode.requestFocus();

    setState(() {
      _estaEscribiendo = false;
      final _message = ChatMessage(
        text: texto,
        uid: '123',
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 800)),
      );
      _messages.insert(0, _message);
      _message.animationController.forward();
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
