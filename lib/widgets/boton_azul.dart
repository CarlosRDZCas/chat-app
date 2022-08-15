import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final Function() onPressed;
  final String texto;

  const BotonAzul({Key? key, required this.onPressed, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          onPressed: onPressed,
          child: SizedBox(
              width: double.infinity,
              height: 45,
              child: Center(
                  child: Text(
                texto,
                style: const TextStyle(fontSize: 18),
              )))),
    );
  }
}
