import 'package:flutter/material.dart';
import 'package:notas/app/presentation/modules/home/home_views.dart';
import 'package:notas/app/presentation/modules/offline/offline_vews.dart';
import 'package:notas/app/presentation/modules/product/views/product_registration_form.dart';
import 'package:notas/app/presentation/modules/shopping/views/shopping_list_view.dart';
import 'package:notas/app/presentation/modules/sign_in/views/sign_in_views.dart';
import 'package:notas/app/presentation/modules/splash/views/splash_view.dart';
import 'package:notas/app/presentation/routes/routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.splash: (context) => const SplashView(),
    Routes.signIn: (context) => const SignInViews(),
    Routes.home: (context) => const HomeViews(),
    Routes.offline: (context) => const OfflineViews(),
    Routes.product_registration: (context) => const ProductRegistrationForm(),
    Routes.shopping_list: (context) => const ShoppingListView(),
  };
}
