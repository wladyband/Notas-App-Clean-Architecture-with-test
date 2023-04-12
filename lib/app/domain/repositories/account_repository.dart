import 'package:notas/app/domain/models/user.dart';

abstract class AccountRepository {
  Future<User?> getUserData();
}
