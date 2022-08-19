import 'dart:io';

import 'package:chat_app/services/aut_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mensajes_response.dart';
import '../services/chat_service.dart';
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

  ChatService? chatService;
  SocketService? socketService;
  AuthServices? authService;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthServices>(context, listen: false);
    socketService!.socket!.on('mensaje-personal', escucharMensaje);
    _cargarHistorial(chatService!.usuarioPara!.uid);
    super.initState();
  }

  @override
  void dispose() {
    socketService!.socket!.off('mensaje-personal');
    for (final message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  void escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      text: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  maxRadius: 14,
                  child: Text(chatService!.usuarioPara!.nombre.substring(0, 2),
                      style: const TextStyle(fontSize: 12)),
                ),
                Text(chatService!.usuarioPara!.nombre,
                    style: const TextStyle(fontSize: 12, color: Colors.black87))
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

    inputController.clear();
    _focusNode.requestFocus();

    setState(() {
      _estaEscribiendo = false;
      final message = ChatMessage(
        text: texto,
        uid: authService!.usuario!.uid,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 800)),
      );
      _messages.insert(0, message);
      message.animationController.forward();
    });

    socketService!.socket!.emit('mensaje-personal', {
      'de': authService!.usuario!.uid,
      'para': chatService!.usuarioPara!.uid,
      'mensaje': texto
    });
  }

  void _cargarHistorial(String uid) async {
    List<Mensaje> chat = await chatService!.getChat(uid);
    final history = chat.map((e) => ChatMessage(
        text: e.mensaje,
        uid: e.de,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }
}
