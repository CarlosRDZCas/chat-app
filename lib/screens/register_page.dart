import 'package:chat_app/services/aut_service.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';
import '../widgets/boton_azul.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';
import '../widgets/snackbar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                Logo(titulo: 'Registrate'),
                _Form(),
                Labels(route: 'login'),
                Text('Terminos y condiciones en uso',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w300))
              ],
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomTextField(
              icon: Icons.person_outline,
              hint: 'Nombre',
              obscureText: false,
              textController: nombreController,
              textInputType: TextInputType.text),
          CustomTextField(
              icon: Icons.mail_outline,
              hint: 'Correo',
              obscureText: false,
              textController: emailController,
              textInputType: TextInputType.emailAddress),
          CustomTextField(
              icon: Icons.lock_outline,
              hint: 'Contraseña',
              obscureText: true,
              textController: passwordController,
              textInputType: TextInputType.text),
          BotonAzul(
            onPressed: authService.autenticando
                ? null
                : () async {
                    final register = await authService.register(
                        nombreController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim());
                    if (register) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      ShowSnackBar(
                          context, 'Error al registrarse', 5, Colors.red);
                    }
                  },
            texto: 'Registrarse',
          ),
        ],
      ),
    );
  }
}
