import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Formata uma data no formato fornecido por uma representação de timestamp.
///
/// Esta função recebe uma [timeStampString] como entrada, que é uma representação de timestamp
/// no formato "/Date(timestamp+0000)/". Ela extrai o valor do timestamp da string e o converte
/// em [DateTime]. Em seguida, formata o [DateTime] no formato "dd/MMM/yyyy" usando o locale "pt_PT".
/// Retorna a data formatada como uma string.
///
/// - [timeStampString]: A string contendo a representação do timestamp.
/// Retorna a data formatada ou 'sem informação' se o formato não for reconhecido.
String formattedDate(String timeStampString) {
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_PT';
  final regex = RegExp(r'/Date\((\d+)\+\d+\)/');
  final match = regex.firstMatch(timeStampString);
  if (match == null) {
    return 'sem informação';
  }

  final timestamp = int.parse(match.group(1)!);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final formato = DateFormat('dd/MMM/yyyy', 'pt_PT');
  final result = formato.format(dateTime);
  return result;
}

/// Obtém a data atual no formato utilizado pela API.
///
/// Esta função retorna a data atual formatada no formato utilizado pela API, que é "/Date(timestamp+0000)/".
/// O timestamp é calculado em relação à data base de 1 de janeiro de 1970.
///
/// Retorna a data atual formatada conforme o formato da API.
String getCurrentDateInApiFormat() {
  DateTime currentDate = DateTime.now().toUtc();
  DateTime baseDate = DateTime.utc(1970, 1, 1);
  Duration difference = currentDate.difference(baseDate);
  int milliseconds = difference.inMilliseconds;
  return "/Date($milliseconds+0000)/";
}

/// Converte uma string de data para um objeto [DateTime].
///
/// Esta função recebe uma [dateString] como entrada no formato "dd-MM-yyyy" e a converte em um objeto [DateTime].
///
/// - [dateString]: A string de data no formato "dd-MM-yyyy".
/// Retorna o objeto [DateTime] correspondente à data fornecida.
DateTime convertStringToDate(String dateString) {
  final dateFormat = DateFormat("dd-MM-yyyy");
  return dateFormat.parse(dateString);
}

/// Converte um objeto [DateTime] em uma string no formato "dd-MM-yyyy".
///
/// Esta função recebe um objeto [date] do tipo [DateTime] e o converte em uma string no formato "dd-MM-yyyy".
///
/// - [date]: O objeto [DateTime] a ser convertido em string.
/// Retorna a string formatada correspondente à data fornecida.
String convertDateToString(DateTime date) {
  final dateFormat = DateFormat("dd-MM-yyyy");
  return dateFormat.format(date);
}
