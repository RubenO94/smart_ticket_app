import 'dart:math';

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

/// Gera uma string aleatória com base em caracteres alfanuméricos.
///
/// Esta função gera uma string aleatória com o comprimento especificado,
/// usando caracteres alfanuméricos (letras minúsculas e números).
/// Isso é útil para criar nomes de arquivos únicos.
///
/// Parâmetros:
///   - [length] : O comprimento da string aleatória a ser gerada.
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
/// - [base64String] : A string em formato base64 para processamento.
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