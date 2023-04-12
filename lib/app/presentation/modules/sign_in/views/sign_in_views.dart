import 'package:flutter/material.dart';
import 'package:notas/app/data/services/utils/validations.dart';
import 'package:notas/app/presentation/modules/sign_in/controller/sign_in_controller.dart';
import 'package:notas/app/presentation/modules/sign_in/controller/sign_in_state.dart';
import 'package:notas/app/presentation/modules/sign_in/views/widgets/submit_button.dart';
import 'package:provider/provider.dart';

class SignInViews extends StatelessWidget with Validations {
  final int characterSize = 4;

  const SignInViews({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_) => SignInController(
        const SignInState(),
        authenticationRepository: context.read(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: Builder(builder: (context) {
                final controller = Provider.of<SignInController>(context);
                return AbsorbPointer(
                  absorbing: controller.state.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onUserNameChanged(text);
                        },
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (text) => combiner([
                          () => isNotEmpty(text, 'Please inform user login'),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //obscureText: true,
                        onChanged: (text) {
                          controller.onPasswordChanged(text);
                        },
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (text) => combiner([
                          () => isNotEmpty(text),
                          () => validatorNumber(text, characterSize),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      const SubmitButton(),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
