import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  const Labels({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50, bottom: 65),
      child: route != 'register'
          ? Column(
              children: [
                const Text('Ya tienes cuenta?',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w300)),
                const SizedBox(height: 5),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, route);
                    },
                    child: const Text('Inicia sesion ahora!',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                const SizedBox(height: 30),
              ],
            )
          : Column(
              children: [
                const Text('No tienes una cuenta?',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w300)),
                const SizedBox(height: 5),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, route);
                    },
                    child: const Text('Crea una ahora!',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                const SizedBox(height: 30),
              ],
            ),
    );
  }
}
