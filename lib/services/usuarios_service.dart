import 'package:chat_app/global/envireoment.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/services/aut_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final uri = Uri.parse('${Enviroment.API_URL}/usuarios');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthServices.getToken() ?? ''
      });
      final usuariosResponse = UsuariosResponse.fromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (err) {
      print(err);
    }
    return [];
  }
}
