import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/models/enums.dart';

class AuthenticationAPI {
  final Http _http;

  Either<SignFailure, String> _handleFailure(HttpFailure failure) {
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
  }

  AuthenticationAPI(this._http);
  // final _baseURL = 'http://192.168.1.113:3333/sessions';
  late final String newRequestToken;

  Future<Either<SignFailure, String>> createSessionWithLogin({
    required String email,
    required String password,
  }) async {
    final result = await _http.request(
      '/sessions',
      onSuccess: ((responseBody) {
        final json = responseBody as Map;
        final resultId = json['user']['user']['id'];
        return resultId as String;
      }),
      method: HttpMethod.post,
      body: {
        'email': email,
        'password': password,
      },
    );
    return result.when(
      _handleFailure,
      (newRequestIdUser) => Either.right(newRequestIdUser),
    );
  }
}
