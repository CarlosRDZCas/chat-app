import 'dart:convert';

import 'package:chat_app/global/envireoment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/usuario.dart';

class AuthServices with ChangeNotifier {
  Usuario? usuario;
  bool _autenticando = false;

  bool get autenticando => _autenticando;

  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {'email': email, 'password': password};
    final resp = await http.post(Uri.parse('${Enviroment.API_URL}/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;
      await guardarToken(loginResponse.token);
      autenticando = false;
      return true;
    } else {
      autenticando = false;
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    autenticando = true;
    final data = {'nombre': nombre, 'email': email, 'password': password};
    final resp = await http.post(Uri.parse('${Enviroment.API_URL}/login/new'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;
      await guardarToken(loginResponse.token);
      autenticando = false;
      return true;
    } else {
      autenticando = false;
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      final resp = await http
          .get(Uri.parse('${Enviroment.API_URL}/login/renew'), headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      });
      if (resp.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(resp.body);
        usuario = loginResponse.usuario;
        await guardarToken(loginResponse.token);
        return true;
      } else {
        logOut();
        return false;
      }
    } else {
      logOut();
      return false;
    }
  }

  guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  logOut() async {
    await _storage.delete(key: 'token');
  }
}
