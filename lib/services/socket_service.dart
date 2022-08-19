import 'package:chat_app/global/envireoment.dart';
import 'package:chat_app/services/aut_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  get serverStatus => _serverStatus;

  io.Socket? _socket;
  io.Socket? get socket => _socket;

  void connect() async {
    final token = await AuthServices.getToken();
    _socket = io.io(Enviroment.SOCKET_URL, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token,
      }
    });
    print(token);
    _socket!.onConnect((_) {
      _serverStatus = ServerStatus.online;
      print('connect');
      notifyListeners();
    });
    _socket!.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }

  void disconnect() {
    socket!.disconnect();
  }
}
