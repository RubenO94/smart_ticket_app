import 'package:flutter/material.dart';

class RespostaItem extends StatelessWidget {
  const RespostaItem({super.key, required this.resposta, required this.onTap});
  final String resposta;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        backgroundColor: const Color.fromARGB(255, 33, 1, 95),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        resposta,
        textAlign: TextAlign.center,
      ),
    );
  }
}