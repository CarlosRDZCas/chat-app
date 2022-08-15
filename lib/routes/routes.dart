import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:flutter/material.dart';

import '../screens/loading_page.dart';
import '../screens/login_page.dart';
import '../screens/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => const UsuariosScreen(),
  'register': (_) => const RegisterScreen(),
  'chat': (_) => const ChatScreen(),
  'login': (_) => const LoginScreen(),
  'loading': (_) => const LoadingScreen()
};
