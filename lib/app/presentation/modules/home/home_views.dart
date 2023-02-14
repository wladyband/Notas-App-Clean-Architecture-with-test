import 'package:flutter/material.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:notas/main.dart';

class HomeViews extends StatelessWidget {
  const HomeViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              Injector.of(context).authenticationRepository.SignOut();
              Navigator.pushReplacementNamed(context, Routes.signIn);
            },
            child: const Text("HOME VIEWS")),
      ),
    );
  }
}
