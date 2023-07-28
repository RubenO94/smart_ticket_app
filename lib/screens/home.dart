import 'dart:convert';
import 'package:smart_ticket/models/perfil.dart';
import 'package:smart_ticket/screens/admin_settings.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/widgets/janela_item.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.perfil});
  final Perfil perfil;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AdminSettingsScreen(),
        ),
      );
    }
  }

  void _developerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SmartTicket App'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              prefixIcon: Icon(Icons.lock_person_rounded),
              labelText: 'Password',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'O Campo Password não pode ser vazio!';
              }
              if (value != adminPassword) {
                return 'Password Incorreta';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _submit();
              },
              child: const Text('Entrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.perfil.entity,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            GestureDetector(
              onLongPress: () => _developerDialog(),
              child: Container(
                width: 80,
                height: 50,
                color: Theme.of(context).colorScheme.surface,
              ),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 16, right: 8, bottom: 16, top: 8),
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Olá, ${widget.perfil.nameToTitleCase}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  clipBehavior: Clip.hardEdge,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurStyle: BlurStyle.solid,
                          blurRadius: 1.0,
                          color: Theme.of(context).colorScheme.primary,
                          spreadRadius: 2.5),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: MemoryImage(
                      base64Decode(widget.perfil.photo),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 48,
          ),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              children: [
                for (final janela in widget.perfil.janelas)
                  JanelaItem(
                    janela: janela,
                    tipoPerfil: widget.perfil.userType,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
