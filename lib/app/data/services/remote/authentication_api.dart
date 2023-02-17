import 'dart:convert';

import 'package:http/http.dart';

class AuthenticationAPI {
  final Client _client;

  AuthenticationAPI(this._client);
  final _baseURL = 'http://192.168.1.113:3333/sessions';

  Future<Map> createSessionWithLogin({
    required String username,
    required String password,
  }) async {
    final response = await _client.post(Uri.parse(_baseURL));
    var json = jsonDecode(response.body);
    return json;
  }
}
