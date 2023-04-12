import 'package:flutter/material.dart';
import 'package:notas/app/domain/models/enums.dart';
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
      final message = {
        SignFailure.notFound: 'Not found',
        SignFailure.unauthorized: 'Invalid password',
        SignFailure.unknown: 'Internal erro',
        SignFailure.network: 'no internet access',
        SignFailure.invalidEmail: 'Invalid email',
      }[failure];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message!),
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
