import 'package:flutter/material.dart';
import 'package:smart_ticket/resources/enums.dart';
import 'package:smart_ticket/widgets/global/botao_dialog.dart';

/// Exibe um snackbar de notificação com base no [tipo].
///
/// Esta função exibe um snackbar de notificação com uma mensagem especificada
/// e um ícone correspondente com base no tipo fornecido. O [context] é necessário
/// para acessar o tema e outras configurações do Flutter.
///
/// - [context]: O contexto de onde o snackbar será exibido.
/// - [message]: A mensagem a ser exibida no snackbar.
/// - [type]: O tipo de snackbar ('error' para erro, 'warning' para aviso, outros valores por defeito será 'success' de sucesso.
void showToast(BuildContext context, String message, String type) {
  // Cores e ícones padrão
  Color background = Theme.of(context).colorScheme.primaryContainer;
  Color foreground = Theme.of(context).colorScheme.onPrimaryContainer;
  Icon icon = const Icon(Icons.check);

  // Configuração de cores e ícones com base no tipo
  switch (type) {
    case 'error':
      background = Theme.of(context).colorScheme.error;
      foreground = Theme.of(context).colorScheme.onError;
      icon = Icon(
        Icons.error,
        color: foreground,
      );
      break;
    case 'warning':
      background = Theme.of(context).colorScheme.tertiary;
      foreground = Theme.of(context).colorScheme.onTertiary;
      icon = Icon(
        Icons.report,
        color: foreground,
      );
      break;
  }

  // Limpar snackbar existente e exibir um novo
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      closeIconColor: foreground,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      content: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            const SizedBox(
              width: 8,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: foreground,
                  ),
            ),
          ],
        ),
      ),
      backgroundColor: background,
    ),
  );
}

///Exibe um Dialog com Titulo e Contexto dinâmico
AlertDialog showMensagemDialog(
    BuildContext context, String titulo, String mensagem) {
  return AlertDialog(
    title: Text(titulo),
    content: Text(mensagem),
    actions: [
      BotaoDialog(onPressed: () => Navigator.of(context).pop(), type: ButtonDialogOptions.sair)
    ],
  );
}
