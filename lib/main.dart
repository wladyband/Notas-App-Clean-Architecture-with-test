import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/data/repositories_implementation/account_repository_impl.dart';
import 'package:notas/app/data/repositories_implementation/authentication_repository_impl.dart';
import 'package:notas/app/data/repositories_implementation/connectivity_repository_impl.dart';
import 'package:notas/app/data/services/remote/account_api.dart';
import 'package:notas/app/data/services/remote/authentication_api.dart';
import 'package:notas/app/data/services/remote/internet_checker.dart';
import 'package:notas/app/domain/repositories/account_repository.dart';
import 'package:notas/app/domain/repositories/authentication_repository.dart';
import 'package:notas/app/domain/repositories/connectivity_repository.dart';
import 'package:notas/app/my_app.dart';
import 'package:notas/app/presentation/global/controller/session_controller.dart';
import 'package:provider/provider.dart';

void main() {
  final http = Http(
    client: Client(),
    baseUrl: 'http://192.168.1.108:3333',
  );
  final accountAPI = AccountAPI(http);
  runApp(
    MultiProvider(
      providers: [
        Provider<AccountRepository>(
          create: (_) => AccountRepositoryImpl(
            accountAPI,
            http,
          ),
        ),
        Provider<ConnectivityRepository>(
          create: (_) => ConnectivityRepositoryImpl(
            Connectivity(),
            InternetChecker(),
          ),
        ),
        Provider<AuthenticationRepository>(
          create: (_) => AuthenticationRepositoryImpl(
            const FlutterSecureStorage(),
            AuthenticationAPI(http),
            accountAPI,
          ),
        ),
        ChangeNotifierProvider(create: (context) => SessionController(
          authenticationRepository: context.read(),
        ))
      ],
      child: const MyApp(),
    ),
  );
}
