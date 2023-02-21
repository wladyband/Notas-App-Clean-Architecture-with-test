import 'dart:convert';

import 'package:notas/app/data/http/failure.dart';
import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/models/enums.dart';

class AuthenticationAPI {
  final Http _http;
  AuthenticationAPI(this._http);
  // final _baseURL = 'http://192.168.1.113:3333/sessions';
  late final String newRequestToken;

  Future<Either<SignFailure, String>> createSessionWithLogin({
    required String email,
    required String password,
  }) async {
    final result = await _http.request(
      '/sessions',
      method: HttpMethod.post,
      body: {
        'email': email,
        'password': password,
      },
    );
    return result.when(
      (failure) {
        if (failure.statusCode != null) {
          switch (failure.statusCode!) {
            case 400:
              return Either.left(SignFailure.invalidEmail);
            case 401:
              return Either.left(SignFailure.unauthorized);
            case 404:
              return Either.left(SignFailure.notFound);
            default:
              return Either.left(SignFailure.unknown);
          }
        }
        if (failure.exception is NetworkException) {
          return Either.left(SignFailure.network);
        }
        return Either.left(SignFailure.unknown);
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        newRequestToken = json['user']['token'] as String;
        return Either.right(newRequestToken);
      },
    );
  }
}
