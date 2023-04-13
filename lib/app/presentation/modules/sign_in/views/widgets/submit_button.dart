import 'package:flutter/material.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/presentation/global/controller/session_controller.dart';
import 'package:notas/app/presentation/modules/sign_in/controller/sign_in_controller.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController controller = Provider.of(context);
    if (controller.state.fetching) {
      return const CircularProgressIndicator();
    }
    return MaterialButton(
      onPressed: () {
        final isValid = Form.of(context).validate();
        if (isValid!) {
          _submit(context);
        }
      },
      color: Colors.blue,
      child: const Text('Sign'),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInController controller = context.read();

    final result = await controller.submit();

    if (!controller.mounted) {
      return;
    }
    result.when((failure) {
      final message = () {
        if (failure is NotFound) {
          return 'Not found';
        }
        if (failure is Unauthorized) {
          return 'invalid authentication';
        }
        if (failure is Network) {
          return 'Not network';
        }
        if (failure is InvalidEmail) {
          return 'Not invalid email';
        }
        return 'Internal error';
      }();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }, (user) {
      final SessionController sessionController = context.read();
      sessionController.setUser(user);
      Navigator.pushReplacementNamed(
        context,
        Routes.home,
      );
    });
  }
}
