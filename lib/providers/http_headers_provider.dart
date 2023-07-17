import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/services/api.dart';
import 'package:smart_ticket/utils/environments.dart';

class HeadersNotifier extends StateNotifier<Map<String, String>> {
  HeadersNotifier() : super({});

  final ApiService _service = ApiService();
  String? _username;
  String? _password;
  String? _token;
  String? _deviceId;

  Future<Map<String, String>> getHeaders() async {
    _username = generateUsername();
    _password = generatePassword();
    _deviceId = await generateDeviceId();
    try {
      if (_username != null && _password != null) {
        _token = await _service.getToken(_username!, _password!);
        if (_token == 'noInternetConnection' ||
            _token == 'notRegistered' ||
            _token == 'errorUnknown') {
          return {};
        }
        if (_token != null && _deviceId != null) {
          state = {'Idioma': 'pt-PT', 'Token': _token!, 'DeviceID': _deviceId!};
        }
        return state;
      }
    } catch (e) {
      return {};
    }

    state = {};
    return state;
  }
}

final headersProvider =
    StateNotifierProvider<HeadersNotifier, Map<String, String>>((ref) {
  return HeadersNotifier();
});
