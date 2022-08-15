import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../widgets/boton_azul.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

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
            onPressed: () {
              print(emailController.text);
            },
            texto: 'Registrarse',
          ),
        ],
      ),
    );
  }
}
