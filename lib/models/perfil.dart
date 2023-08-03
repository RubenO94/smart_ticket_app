import 'package:smart_ticket/models/janela.dart';

class Perfil {
  const Perfil(
      {required this.id,
      required this.name,
      required this.email,
      required this.entity,
      required this.photo,
      required this.userType,
      required this.numeroCliente,
      required this.janelas});
  final String id;
  final String name;
  final String email;
  final String numeroCliente;
  final String entity;
  final String photo;
  final int userType;
  final List<Janela> janelas;

  String get nameToTitleCase {
    if (name.isEmpty) {
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

  String getFirstNameInTitleCase() {
    if (name.isEmpty) {
      return '';
    }

    String firstName = name.split(' ').first;
    return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
  }

  String getLastNameInTitleCase() {
    if (name.isEmpty) {
      return '';
    }

    String lastName = name.split(' ').last;
    return lastName[0].toUpperCase() + lastName.substring(1).toLowerCase();
  }
}
