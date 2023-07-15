import 'package:android_id/android_id.dart';
import 'package:smart_ticket/models/quiz_answer.dart';

const _username = 'SmartTicketWSApp';

String generatePassword() {
  DateTime now = DateTime.now();
  String formattedDate = now.year.toString() +
      now.month.toString().padLeft(2, '0') +
      now.day.toString().padLeft(2, '0');

  String reversedUsername = _username.split('').reversed.join();

  String reversedDate = formattedDate.split('').reversed.join();

  return reversedDate + reversedUsername;
}

String generateUsername() {
  return _username;
}

Future<String> generateDeviceId() async {
  //TODO: Implementar o gerador de ID para iOS com o package: device_info_plus

  const androidId = AndroidId();
  final deviceId = await androidId.getId();
  if (deviceId == null) {
    return '';
  }
  return deviceId;
}

enum Classificacao {
  MuitoBom,
  Bom,
  AMelhorar,
  MateriaNaoLecionada,
}

List<QuizAnswer> answers = [
  QuizAnswer(classificacao: Classificacao.MuitoBom),
  QuizAnswer(classificacao: Classificacao.Bom),
  QuizAnswer(classificacao: Classificacao.AMelhorar),
  QuizAnswer(classificacao: Classificacao.MateriaNaoLecionada),
];
