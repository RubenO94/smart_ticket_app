import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, String type) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
      backgroundColor: type == 'error'
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.secondaryContainer,
    ),
  );
}

// void showModal(BuildContext context, String title, String message, TextEditingController? controller) {
//   showDialog(
//           context: context,
//           builder: (ctx) {
//             return AlertDialog(
//               title: const Text('Confirmar Registo'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                       message,),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Insira o código aqui',
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child: const Text('Cancelar'),
//                   onPressed: () {
//                     FocusScope.of(context).unfocus();
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: const Text('Confirmar'),
//                   onPressed: () async {
//                     FocusScope.of(context).unfocus();

//                     setState(() {
//                       _activationCode = _codeController.text;
//                     });

//                     final result = await _onActivateDevice(_activationCode);

//                     if (result && mounted) {
//                       showToast(
//                           context,
//                           'Codigo aceite. Dispositivo registado com sucesso!',
//                           'success');
//                       Navigator.of(context).pop(result);
//                     } else {
//                       showToast(
//                           context, 'O código inserido é inválido', 'error');
//                       Navigator.of(context).pop(result);
//                     }
//                   },
//                 ),
//               ],
//             );
//           },
//         );
// }