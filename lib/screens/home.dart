import 'dart:convert';
import 'package:smart_ticket/widgets/janela_item.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_ticket/data/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          //TODO: custom widget...
          ),
      appBar: AppBar(
        title: const Text('Menu Principal'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: MemoryImage(
                  base64Decode(user.photo),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${user.nameToTitleCase}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
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
                  for(final janela in user.janelas)
                  JanelaItem(janela: janela,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
