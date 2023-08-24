import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/client/pagamento_callback_provider.dart';
import 'package:smart_ticket/providers/client/pagamentos_provider.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/client/pagamento_pendente_item.dart';
import 'package:smart_ticket/widgets/global/mensagem_centro.dart';
import 'package:url_launcher/url_launcher.dart';

class PagamentosPendentesScreen extends ConsumerStatefulWidget {
  const PagamentosPendentesScreen({super.key});

  @override
  ConsumerState<PagamentosPendentesScreen> createState() =>
      _PagamentosPendentesScreenState();
}

class _PagamentosPendentesScreenState
    extends ConsumerState<PagamentosPendentesScreen> {
  final List<int> _pagamentosSelecionados = [];
  double _total = 0;
  bool _isLoading = false;
  final bool _isPagos = false;

  void _efetuarPagamento() async {
    setState(() {
      _isLoading = true;
    });
    final idCliente = ref.watch(perfilProvider.select((value) => value.id));
    final hasPosted = await ref
        .read(apiServiceProvider)
        .postPagamento(int.parse(idCliente), _pagamentosSelecionados);
    if (hasPosted) {
      final urlPagamento = ref.watch(pagamentoCallbackProvider);

      if (!await launchUrl(Uri.parse(urlPagamento),
          mode: LaunchMode.externalApplication,
          webViewConfiguration:
              const WebViewConfiguration(enableJavaScript: true),
          webOnlyWindowName: '_blank')) {
        if (mounted) {
          showToast(context, 'Serviço insdiponível, tente mais tarde', 'error');
        }
      }
    } else {
      if (mounted) {
        showToast(context, 'Serviço insdiponível, tente mais tarde', 'error');
        setState(() {
          _pagamentosSelecionados.clear();
          _total = 0;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void refreshPagamentosPendentes() {
    ref.read(apiServiceProvider).getPagamentos();
    setState(() {
      _pagamentosSelecionados.clear();
      _total = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagamentosPendentes = ref.watch(pagamentosPendentesProvider);

    if (_isLoading) {
      return const MenssagemCentro(
        widget: CircularProgressIndicator(),
        mensagem:
            'A  processar os detalhes de pagamento. Aguarde um momento, por favor.',
      );
    }

    if (pagamentosPendentes.isEmpty) {
      return const MenssagemCentro(
        widget: Icon(
          Icons.check_circle_outline_outlined,
          size: 64,
        ),
        mensagem: 'Não tem pagamentos pendentes para regularizar.',
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: ListView.builder(
        itemCount: pagamentosPendentes.length,
        itemBuilder: (context, index) => PagamentoPendenteItem(
          pagamento: pagamentosPendentes[index],
        ),
      ),
    );
  }
}
