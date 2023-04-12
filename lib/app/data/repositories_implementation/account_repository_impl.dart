import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/data/services/remote/account_api.dart';
import 'package:notas/app/domain/models/user.dart';
import 'package:notas/app/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountAPI _accountAPI;
  final Http _http;

  AccountRepositoryImpl(this._accountAPI, this._http);
  @override
  Future<User?> getUserData() async {
    final result = await _accountAPI.getAccount(
      _http.idUserFind.toString(),
    );
    return result;
  }
}
