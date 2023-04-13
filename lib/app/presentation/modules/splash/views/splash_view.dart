import 'package:flutter/material.dart';
import 'package:notas/app/domain/repositories/account_repository.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';
import 'package:notas/app/domain/repositories/connectivity_repository.dart';
import 'package:notas/app/presentation/global/controller/session_controller.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _init();
      },
    );
  }

  Future<void> _init() async {
    final ConnectivityRepository connectivityRepository = context.read();
    final AuthenticationRepository authenticationRepository = context.read();
    final AccountRepository accountRepository = context.read();
    final SessionController sessionController = context.read();
    final hasInternet = await connectivityRepository.hasInternet;


    if (!hasInternet){
      _goTo(Routes.offline);
    }
    if (hasInternet) {
      final isSignedIn = await authenticationRepository.isSignedIn;
      if (isSignedIn) {
        final user = await accountRepository.getUserData();

        if (mounted) {
          if (user != null) {
            sessionController.setUser(user);
            _goTo(Routes.home);
          } else {
            _goTo(Routes.signIn);
          }
        }
      } else if (mounted) {
        _goTo(Routes.signIn);
      }
    }

  }

  _goTo(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            SizedBox(width: 80, height: 80, child: CircularProgressIndicator()),
      ),
    );
  }
}
