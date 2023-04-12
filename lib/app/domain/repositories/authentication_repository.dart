import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/models/enums.dart';
import 'package:notas/app/domain/models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;

  Future<void> SignOut();
  Future<Either<SignFailure, User>> signIn(
    String username,
    String password,
  );
}
