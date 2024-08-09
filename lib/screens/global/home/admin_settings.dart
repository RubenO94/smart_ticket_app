import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/constants/enums.dart';

import 'package:smart_ticket/providers/global/device_id_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/utils/dialogs.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  String _deviceId = '';
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();
  void _loadData() async {
    final id = await ref.read(deviceIdProvider.future);
    final urlService =
        await ref.read(secureStorageProvider).readSecureData('WSApp');
    setState(() {
      _deviceId = id;
      _controller.text = urlService;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opções de Programador'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'ID Dispositivo: ',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface),
                        ),
                        TextSpan(
                          text: _deviceId,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      labelText: 'URL do Servidor',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.text = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton.icon(
                    style: const ButtonStyle(
                        shape:
                            WidgetStatePropertyAll(BeveledRectangleBorder())),
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        await ref
                            .read(secureStorageProvider)
                            .writeSecureData('WSApp', _controller.text);
                        if (mounted) {
                          showToast(context, 'Alterações feitas com sucesso!',
                              ToastType.success);
                        }
                      } else if (mounted) {
                        showToast(context, 'Insira um URL de serviço',
                            ToastType.success);
                      }
                    },
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Guardar Alterações'),
                  ),
                ],
              ),
            ),
    );
  }
}
