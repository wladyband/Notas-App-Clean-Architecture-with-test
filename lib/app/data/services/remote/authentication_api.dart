import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/models/enums.dart';

class AuthenticationAPI {
  final Client _client;

  AuthenticationAPI(this._client);
  final _baseURL = 'http://192.168.1.113:3333/sessions';
  late final String newRequestToken;

  Future<Either<SignFailure, String>> createSessionWithLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      switch (response.statusCode) {
        case 200:
          final json = Map<String, dynamic>.from(
            jsonDecode(response.body),
          );
          newRequestToken = json['user']['token'] as String;
          return Either.right(newRequestToken);
        case 401:
          return Either.left(SignFailure.unauthorized);
        case 404:
          return Either.left(SignFailure.notFound);
        default:
          return Either.left(SignFailure.unknown);
      }
    } catch (e) {
      if (e is SocketException) {
        return Either.left(
          SignFailure.network,
        );
      }
      return Either.left(SignFailure.unknown);
    }
  }
}
