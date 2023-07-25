// import 'package:flutter/material.dart';
// import 'package:smart_ticket/data/dummy_data.dart';
// import 'package:smart_ticket/models/pergunta.dart';
// import 'package:smart_ticket/models/resposta.dart';

// class MinhaAvaliacaoScreen extends StatelessWidget {
//   const MinhaAvaliacaoScreen({super.key});

//    @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Resultados da Avaliação'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: categorias.length,
//           itemBuilder: (context, categoriaIndex) {
//             final categoria = categorias[categoriaIndex];
//             final perguntasDaCategoria = listPerguntas.where((pergunta) => pergunta.categoria == categoria).toList();

//             return _buildCategoriaExpansionTile(categoria, perguntasDaCategoria);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoriaExpansionTile(String categoria, List<Pergunta> perguntas) {
//     return ExpansionTile(
//       title: Text(
//         categoria,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       ),
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: perguntas.length,
//           itemBuilder: (context, index) {
//             final pergunta = perguntas[index];
//             final resposta = listRespostas.firstWhere((resposta) => resposta.idDesempenhoLinha == pergunta.idDesempenhoLinha);

//             return _buildPerguntaCard(pergunta, resposta);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildPerguntaCard(Pergunta pergunta, Resposta resposta) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               pergunta.descricao,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Resposta: ${resposta.classificacao}',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
