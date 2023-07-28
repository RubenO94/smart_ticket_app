import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/alerta.dart';
import 'package:smart_ticket/providers/avaliacoes_disponiveis_provider.dart';
import 'package:smart_ticket/providers/pagamentos_pendentes_provider.dart';

final alertasProvider = Provider<List<Alerta>>((ref) {
  List<Alerta> alertas = [];
  String message = '';
  final pagamentosPendentesNotifications =
      ref.watch(pagamentosNotificationsProvider);
  int avaliacoesNotifications = 0;
  ref.watch(avaliacoesNotificationsProvider.future).then(
    (value) {
      avaliacoesNotifications = value;
    },
  );
//TODO: BUG - Talvez um FutureProvider resolva...
  if (avaliacoesNotifications > 0) {
    final isAvaliacaoplural = avaliacoesNotifications > 1 ? true : false;
    if (isAvaliacaoplural) {
      message = 'Tem $avaliacoesNotifications novas avaliações conluídas';
    } else {
      'Tem $avaliacoesNotifications nova avaliação conluída';
    }

    final alerta = Alerta(
      type: 'Avaliações',
      message: message,
    );
    alertas.add(alerta);
  }

  if (pagamentosPendentesNotifications > 0) {
    final isPagamentosPlural =
        pagamentosPendentesNotifications > 1 ? true : false;
    if (isPagamentosPlural) {
      message =
          'Tem $pagamentosPendentesNotifications pagamentos por regularizar.';
    } else {
      message =
          'Tem $pagamentosPendentesNotifications pagamento por regularizar.';
    }
    final alerta = Alerta(
      type: 'Pagamentos',
      message: message,
    );
    alertas.add(alerta);
  }

  return alertas;
});
