import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:notas/app/data/repositories_implementation/authentication_repository_impl.dart';
import 'package:notas/app/data/repositories_implementation/connectivity_repository_impl.dart';
import 'package:notas/app/data/services/remote/authentication_api.dart';
import 'package:notas/app/data/services/remote/internet_checker.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';
import 'package:notas/app/domain/repositories/connectivity_repository.dart';
import 'package:notas/app/my_app.dart';

void main() {
  runApp(Injector(
      connectivityRepository:
          ConnectivityRepositoryImpl(Connectivity(), InternetChecker()),
      authenticationRepository: AuthenticationRepositoryImpl(
        const FlutterSecureStorage(),
        AuthenticationAPI(
          http.Client(),
        ),
      ),
      child: const MyApp()));
}

class Injector extends InheritedWidget {
  const Injector(
      {super.key,
      required super.child,
      required this.connectivityRepository,
      required this.authenticationRepository});

  final ConnectivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;

  @override
  bool updateShouldNotify(_) => false;

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'Injector could not be found');
    return injector!;
  }
}
