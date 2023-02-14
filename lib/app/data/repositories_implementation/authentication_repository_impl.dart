import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/models/enums.dart';
import 'package:notas/app/domain/models/user.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FlutterSecureStorage _secureStorage;

  AuthenticationRepositoryImpl(this._secureStorage);

  @override
  Future<User?> getUserData() {
    return Future.value(User());
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }

  @override
  Future<Either<SignFailure, User>> signIn(
    String username,
    String password,
  ) async {
    //TODO;
    await Future.delayed(const Duration(seconds: 6));
    if (username != 'test') {
      return Either.left(SignFailure.notFound);
    }
    if (password != '123456') {
      return Either.left(SignFailure.unauthorized);
    }

    await _secureStorage.write(key: _key, value: '123');
    return Either.right(
      User(),
    );
  }

  @override
  Future<void> SignOut() {
    return _secureStorage.delete(key: _key);
  }
}
