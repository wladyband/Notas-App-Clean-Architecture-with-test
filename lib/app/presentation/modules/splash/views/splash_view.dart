import 'package:flutter/material.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:notas/main.dart';

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
    final injector = Injector.of(context);
    final connectivityRepository = injector.connectivityRepository;
    final hasInternet = await connectivityRepository.hasInternet;

    if (hasInternet) {
      final authenticationRepository = injector.authenticationRepository;
      final isSignedIn = await authenticationRepository.isSignedIn;
      if (isSignedIn) {
        final user = await authenticationRepository.getUserData();
        if (mounted) {
          if (user != null) {
            _goTo(Routes.home);
          } else {
            _goTo(Routes.signIn);
          }
        }
      } else if (mounted) {
        _goTo(Routes.signIn);
      }
    } else {
      _goTo(Routes.offline);
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
