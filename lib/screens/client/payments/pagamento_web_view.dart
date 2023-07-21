import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://sandbox.meowallet.pt/checkout/8e4b1c3c-4f1c-45f5-8217-399745de30f5');

class PagamentoWebViewScreen extends StatefulWidget {
  const PagamentoWebViewScreen({Key? key}) : super(key: key);

  @override
  State<PagamentoWebViewScreen> createState() => _PagamentoWebViewScreenState();
}

class _PagamentoWebViewScreenState extends State<PagamentoWebViewScreen> with WidgetsBindingObserver {
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pagamento concluído com sucesso!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagamento"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchUrl,
          child: Text('Abrir URL em um navegador externo'),
        ),
      ),
    );
  }
}
