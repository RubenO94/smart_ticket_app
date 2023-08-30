import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/widgets/client/download_fatura_button.dart';
import 'package:smart_ticket/widgets/client/fatura_indisponivel_container.dart';

class PagamentoPagoItem extends ConsumerStatefulWidget {
  const PagamentoPagoItem({super.key, required this.pagamento});
  final Pagamento pagamento;

  @override
  ConsumerState<PagamentoPagoItem> createState() => _PagamentoPagoItemState();
}

class _PagamentoPagoItemState extends ConsumerState<PagamentoPagoItem> {
  bool _isDownLoading = false;

  void _createPdf() async {
    // final PermissionStatus status = Platform.isAndroid ? 
    //     await Permission.manageExternalStorage.request() : await Permission.mediaLibrary.request();
    // if (status.isGranted) {
     
    // }
     setState(() {
        _isDownLoading = true;
      });
      final base64WithPrefix = await ref
          .read(apiServiceProvider)
          .getDownloadDocumento(widget.pagamento.idDocumento);
      if (base64WithPrefix.startsWith('base64:')) {
        try {
          final base64 = removeBase64Prefix(base64WithPrefix);
          var bytes = base64Decode(base64.replaceAll('\n', ''));
          final output = await getTemporaryDirectory();
          final randomFileName = 'fatura_${generateRandomString(5)}';
          final file = File("${output.path}/$randomFileName.pdf");
          await file.writeAsBytes(bytes.buffer.asUint8List());
          await OpenFile.open("${output.path}/$randomFileName.pdf");
        } catch (e) {
          print(e.toString());
          setState(() {
            _isDownLoading = false;
          });
        }
      } else if (mounted) {
        showToast(context, 'Ocorreu um erro. Tente mais tarde', 'error');
      }
      setState(() {
        _isDownLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 10,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        title: Text(
          widget.pagamento.plano,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded),
                const SizedBox(
                  width: 8,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: formattedDate(widget.pagamento.dataInicio),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: '  a  ',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: formattedDate(widget.pagamento.dataFim),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              height: 16,
            ),
            if (widget.pagamento.idDocumento.isEmpty)
              const FaturaIndisponivelContainer(),
            if (widget.pagamento.idDocumento.isNotEmpty)
              _isDownLoading
                  ? const LinearProgressIndicator()
                  : DownloadFaturaButton(createPdf: _createPdf),
          ],
        ),
        trailing: Text(
          '${widget.pagamento.valor.toStringAsFixed(2)} €',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
