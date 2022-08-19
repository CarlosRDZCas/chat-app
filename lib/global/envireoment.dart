import 'dart:io';

class Enviroment {
  static String API_URL = Platform.isAndroid
      ? 'http://192.168.1.161:3000/api'
      : 'http://localhost:3000/api';

  static String SOCKET_URL = Platform.isAndroid
      ? 'http://192.168.1.161:3000'
      : 'http://localhost:3000';
}
