import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Password para aceder ás opções de programador diretamente da aplicação.
const String adminPassword = 'smartadminapp';

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

/// Verifica se um número de identificação fiscal (NIF) é válido.
///
/// Esta função recebe um [nif] como entrada e verifica se ele é um número de
/// identificação fiscal (NIF) válido de acordo com o algoritmo de validação.
/// Um NIF válido tem 9 dígitos e o último dígito é o dígito de controlo,
/// que é calculado com base nos outros dígitos do NIF.
///
/// - [nif]: O número de identificação fiscal a ser verificado.
/// Retorna `true` se o [nif] é válido, caso contrário, retorna `false`.
bool isValidNIF(String nif) {
  if (nif.isEmpty) return false;
  if (nif.length != 9) return false;

  int sum = 0;
  for (int i = 0; i < 8; i++) {
    int? digit = int.tryParse(nif[i]);
    if (digit == null) return false;
    sum += digit * (9 - i);
  }

  int? checkDigit = int.tryParse(nif[8]);
  if (checkDigit == null) return false;

  int remainder = sum % 11;
  int expectedCheckDigit =
      (remainder == 0 || remainder == 1) ? 0 : (11 - remainder);

  return checkDigit == expectedCheckDigit;
}

/// Verifica se uma string fornecida é um endereço de e-mail válido.
///
/// Esta função recebe uma [email] como entrada e verifica se ele é um endereço
/// de e-mail válido de acordo com um padrão de expressão regular. Se a [email]
/// for uma string vazia, a função retorna `false`. Caso contrário, ela utiliza
/// a expressão regular definida no padrão [pattern] para validar o formato do e-mail.
///
/// - [email]: O endereço de e-mail a ser verificado.
/// Retorna `true` se o [email] é válido, caso contrário, retorna `false`.
bool isValidEmail(String email) {
  if (email.isEmpty) return false;

  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regex = RegExp(pattern);

  return regex.hasMatch(email);
}

/// Formata a descrição removendo qualquer texto entre parênteses.
///
/// Esta função recebe uma [descricao] como entrada e procura o primeiro
/// caractere '(' na descrição. Se for encontrado, a função remove todos os
/// caracteres a partir desse ponto até o final da descrição, retornando a
/// descrição formatada sem o texto entre parênteses.
///
/// - [descricao]: A descrição a ser formatada.
/// Retorna uma [String] com a descrição formatada.
String formatDescricao(String descricao) {
  final index = descricao.indexOf('(');
  if (index != -1) {
    descricao = descricao.substring(0, index).trim();
  }
  return descricao;
}

/// Retorna uma cor de texto apropriada para um fundo de cor fornecido.
///
/// Essa função calcula o contraste relativo entre a cor de fundo dada e escolhe
/// uma cor de texto (preta ou branca) com base no contraste para garantir a
/// legibilidade adequada.
///
/// O cálculo do contraste relativo é baseado nas proporções de luminância
/// entre as cores de fundo e de texto. Se o contraste resultante for maior do
/// que 3.0, uma cor de texto escura (preta) é retornada; caso contrário, uma
/// cor de texto clara (branca) é retornada.
///
/// - [backgroundColor]: A cor de fundo para a qual a cor de texto é calculada.
/// Retorna uma [Color] que representa a cor de texto escolhida (preta ou branca).
Color getTextColorOnBackground(Color backgroundColor) {
  // Calcula o brilho relativo (Contraste Relativo)
  double relativeLuminance = (backgroundColor.red * 0.2126 +
          backgroundColor.green * 0.7152 +
          backgroundColor.blue * 0.0722) /
      255.0;

  // Calcula o contraste relativo entre o texto e o fundo
  double contrast = (relativeLuminance + 0.05) / (0.05 + 0.179);

  // Se o contraste for maior que 3.0, escolhemos uma cor de texto escura (preta),
  // caso contrário, escolhemos uma cor de texto clara (branca).
  return contrast > 3.0 ? const Color(0xFF212121) : const Color(0xF5F5F5F5);
}

/// Retorna o ícone correspondente a uma janela com base em um [id] e [tipoPerfil].
///
/// Esta função recebe um [id] e um [tipoPerfil] como entrada e retorna o ícone correspondente
/// com base nesses valores. Se o [tipoPerfil] for 1 (cliente), ela verifica
/// o [id] e retorna o ícone associado. Se o [tipoPerfil] for 0 (funcionário), ela também
/// verifica o [id] e retorna o ícone correspondente. Se o [tipoPerfil] não for 1 nem 0, retorna um ícone
/// de caixa vazia como valor default.
///
/// - [id]: O ID da janela para a qual o ícone está associado.
/// - [tipoPerfil]: O tipo de perfil associado.
/// Retorna o ícone correspondente ao ID e ao tipo de perfil fornecidos.
IconData getIconJanela(int id, int tipoPerfil) {
  if (tipoPerfil == 1) {
    switch (id) {
      case 100:
        return Icons.assignment;
      case 200:
        return Icons.app_registration_rounded;
      case 300:
        return Icons.payment_rounded;
      case 400:
        return Icons.access_time;
      default:
        return Icons.check_box_outline_blank;
    }
  } else if (tipoPerfil == 0) {
    switch (id) {
      case 100:
        return Icons.assignment_add;
      default:
        return Icons.check_box_outline_blank;
    }
  }
  return Icons.check_box_outline_blank;
}


/// Gera uma string aleatória com base em caracteres alfanuméricos.
///
/// Esta função gera uma string aleatória com o comprimento especificado,
/// usando caracteres alfanuméricos (letras minúsculas e números).
/// Isso é útil para criar nomes de arquivos únicos.
///
/// Parâmetros:
///   - [length]: O comprimento da string aleatória a ser gerada.
///
/// Retorna:
///   Uma string aleatória de comprimento [length].
String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}


/// Remove o prefixo "base64:" de uma string em formato base64.
///
/// Esta função é utilizada para extrair os dados base64 reais de uma string
/// que possui um prefixo "base64:". Se a [base64String] fornecida começar
/// com o prefixo "base64:", a função retornará os dados base64 sem o prefixo.
/// Se a string não tiver o prefixo, a string original será retornada
/// sem alterações.
///
/// Exemplo:
/// ```dart
/// String base64ComPrefixo = "base64:StringBase64Aqui";
/// String base64SemPrefixo = removeBase64Prefix(base64ComPrefixo);
/// ```
///
/// Parâmetros:
/// - [base64String]: A string em formato base64 para processamento.
///
/// Retorna:
/// Uma nova string contendo os dados base64 sem o prefixo "base64:",
/// caso o prefixo esteja presente. Se o prefixo não for encontrado,
/// a string original será retornada.
String removeBase64Prefix(String base64String) {
  const prefixo = "base64:";
  if (base64String.startsWith(prefixo)) {
    return base64String.substring(prefixo.length);
  }
  return base64String;
}
