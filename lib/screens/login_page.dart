import 'package:chat_app/services/aut_service.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/boton_azul.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';
import '../widgets/snackbar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                Logo(titulo: 'Messenger'),
                _Form(),
                Labels(route: 'register'),
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
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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
                    FocusScope.of(context).unfocus();
                    final login = await authService.login(
                        emailController.text.trim(),
                        passwordController.text.trim());
                    login
                        ? Navigator.pushReplacementNamed(context, 'usuarios')
                        : ShowSnackBar(
                            context, 'Login incorrecto', 5, Colors.red);
                  },
            texto: 'Iniciar sesión',
          ),
        ],
      ),
    );
  }
}
