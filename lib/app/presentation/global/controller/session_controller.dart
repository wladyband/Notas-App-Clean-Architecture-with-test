import 'package:notas/app/domain/models/user.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';
import 'package:notas/app/presentation/global/state_notifier.dart';

class SessionController extends StateNotifier<User?> {
  SessionController({required this.authenticationRepository}) : super(null);

  final AuthenticationRepository authenticationRepository;

  void setUser(User user) {
    state = user;
  }

  Future<void> signOut() async {
    await authenticationRepository.SignOut();
    onlyUpdate(null);
  }
}
