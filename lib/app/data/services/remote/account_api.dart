import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/domain/models/enums.dart';
import 'package:notas/app/domain/models/user.dart';

class AccountAPI {
  final Http _http;

  AccountAPI(this._http);

  Future<User?> getAccount(String newRequestIdUser) async {
    final result = await _http.request(
      '/users',
      queryParameter: {
        'id': newRequestIdUser,
      },
      onSuccess: (json) {
        return User.fromJson(json);
      },
    );

    return result.when(
      left: (_) => null,
      right: (user) => user,
    );
  }
}
