import 'package:smart_ticket/constants/enums.dart';

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

/// Faz a validação dos forms utilizados na aplicação.
///
/// Parâmetros:
/// - [value] : Valor inserido no input para validação
/// - [type] : O tipo de validação a ser feita
///
/// Retorna:
/// Uma String com valor erro caso se confirme a condição, senão retorna null indicando que passou na validação
String? formValidator(String? value, ValidatorType? type) {
  switch (type) {
    case ValidatorType.email:
      if (value == null || value.isEmpty) {
        return 'Insira o Endereço de Email';
      }
      if (!isValidEmail(value)) {
        return 'Insira um Endereço de Email válido';
      }
      return null;
    case ValidatorType.nif:
      if (value == null || value.isEmpty) {
        return 'Insira o Numero de Identificação Fiscal';
      }
      return null;
    default:
      if (value == null || value.isEmpty) {
        return 'Este campo é obrigatório';
      }
      return null;
  }
}
