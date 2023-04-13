import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/domain/models/user.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';
import 'package:notas/app/presentation/global/state_notifier.dart';
import 'package:notas/app/presentation/modules/sign_in/controller/sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(
    super.state, {
    required this.authenticationRepository,
  });

  final AuthenticationRepository authenticationRepository;

  void onUserNameChanged(String text) {
    onlyUpdate(
      state.copyWith(
        username: text.trim().toLowerCase(),
      ),
    );
  }

  void onPasswordChanged(String text) {
    onlyUpdate(
      state.copyWith(
        password: text.replaceAll(' ', ''),
      ),
    );
  }

  Future<Either<SignInFailure, User>> submit() async {
    state = state.copyWith(fetching: true);
    final result = await authenticationRepository.signIn(
      state.username,
      state.password,
    );
    result.when(
     left:  (_) => state = state.copyWith(fetching: false),
     right:  (p0) => null,
    );
    return result;
  }
}
