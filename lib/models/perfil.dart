import 'package:smart_ticket/models/janela.dart';

class Perfil {
  const Perfil(
      {required this.id, required this.name, required this.photo, required this.userType, required this.janelas});
  final String id;
  final String name;
  final String photo;
  final int userType;
  final List<Janela> janelas;

  String get nameToTitleCase {
    if (name == null || name.isEmpty) {
      return '';
    }

    List<String> words = name.toLowerCase().split(' ');

    words = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return '';
    }).toList();

    return words.join(' ');
  }
}
