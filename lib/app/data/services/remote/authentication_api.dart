import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/domain/models/enums.dart';

class AuthenticationAPI {
  final Http _http;

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode!) {
        case 400:
          return Either.left(SignInFailure.invalidEmail());
        case 401:
          return Either.left(SignInFailure.unauthorized());
        case 404:
          return Either.left(SignInFailure.notFound());
        default:
          return Either.left(SignInFailure.unknown());
      }
    }
    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.network());
    }
    return Either.left(SignInFailure.unknown());
  }

  AuthenticationAPI(this._http);
  // final _baseURL = 'http://192.168.1.113:3333/sessions';
  late final String newRequestToken;

  Future<Either<SignInFailure, String>> createSessionWithLogin({
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
