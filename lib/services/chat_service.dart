import 'package:chat_app/global/envireoment.dart';
import 'package:chat_app/services/aut_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/mensajes_response.dart';
import '../models/usuario.dart';

class ChatService with ChangeNotifier {
  Usuario? usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioid) async {
    final uri = Uri.parse('${Enviroment.API_URL}/mensajes/$usuarioid');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthServices.getToken() ?? ''
    });

    final mensajesResponse = MensajesResponse.fromJson(resp.body);

    return mensajesResponse.mensajes;
  }
}
