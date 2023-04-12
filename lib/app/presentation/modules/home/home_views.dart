import 'package:flutter/material.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';
import 'package:notas/app/presentation/global/controller/session_controller.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

class HomeViews extends StatefulWidget {
  const HomeViews({super.key});

  @override
  State<HomeViews> createState() => _HomeViewsState();
}

class _HomeViewsState extends State<HomeViews> {
  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = Provider.of(context);
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
             await sessionController.signOut();
              if(mounted){
                Navigator.pushReplacementNamed(context, Routes.signIn);
              }
            },
            child: Text(sessionController.state!.name)),
      ),
    );
  }
}
