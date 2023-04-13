import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notas/app/data/services/remote/account_api.dart';
import 'package:notas/app/data/services/remote/authentication_api.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';

import 'package:notas/app/domain/models/user.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FlutterSecureStorage _secureStorage;

  final AuthenticationAPI _authenticationAPI;
  final AccountAPI _accountAPI;
  AuthenticationRepositoryImpl(
    this._secureStorage,
    this._authenticationAPI,
    this._accountAPI,
  );

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    //TODO;
    final loginResult = await _authenticationAPI.createSessionWithLogin(
      email: username,
      password: password,
    );
    return loginResult.when(
      (failure) {
        return Either.left(failure);
      },
      (newRequestIdUser) async {
        //TUDO  await _secureStorage.write(key: _key, value: newRequestToken);
        final user = await _accountAPI.getAccount(newRequestIdUser);
        if (user == null) {
          return Either.left(SignInFailure.unknown());
        }
        return Either.right(user);
      },
    );
  }

  @override
  Future<void> SignOut() {
    return _secureStorage.delete(key: _key);
  }
}
