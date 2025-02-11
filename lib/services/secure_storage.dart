import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  /// Retorna as opções de configuração do Android para uso seguro.
  ///
  /// Esta função retorna um [AndroidOptions] com as opções de configuração do Android
  /// para operações seguras de armazenamento. Atualmente, as opções incluem
  /// a configuração para usar o SharedPreferences criptografado.
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  /// Escreve dados no SecureStorage [FlutterSecureStorage].
  ///
  /// Esta função escreve um valor associado à chave fornecida.
  /// - [key]: A chave associada aos dados a serem gravados.
  /// - [value]: O valor a ser gravado.
  Future<void> writeSecureData(String key, String value) async {
    await _secureStorage.write(
        key: key, value: value, aOptions: _getAndroidOptions());
  }

  /// Lê dados seguros SecureStorage [FlutterSecureStorage].
  ///
  /// Esta função lê o valor associado à chave fornecida.
  /// - [key]: A chave associada aos dados a serem lidos.
  /// Retorna o valor associado à chave, ou uma string vazia se não houver valor.
  Future<String> readSecureData(String key) async {
    final readData =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    if (readData != null) {
      return readData;
    }
    return '';
  }

  /// Exclui dados do SecureStorage [FlutterSecureStorage].
  ///
  /// Esta função exclui o valor associado à chave fornecida no parâmetro.
  /// - [key]: A chave associada aos dados a serem excluídos.
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  /// Exclui todos os dados do SecureStorage [FlutterSecureStorage].
  ///
  /// Esta função exclui todos os valores do armazenamento.
  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }
}
