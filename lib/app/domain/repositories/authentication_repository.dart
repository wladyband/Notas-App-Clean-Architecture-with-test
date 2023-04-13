import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/domain/models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;

  Future<void> SignOut();
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  );
}
