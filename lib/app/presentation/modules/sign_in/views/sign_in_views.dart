import 'package:flutter/material.dart';
import 'package:notas/app/data/services/utils/validations.dart';
import 'package:notas/app/domain/models/enums.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:notas/main.dart';

class SignInViews extends StatefulWidget {
  const SignInViews({super.key});

  @override
  State<SignInViews> createState() => _SignInViewsState();
}

class _SignInViewsState extends State<SignInViews> with Validations {
  String _username = '', _password = '';
  final int characterSize = 4;
  bool _fetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: AbsorbPointer(
              absorbing: _fetching,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      _username = text.trim().toLowerCase();
                    },
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (text) => combiner([
                      () => isNotEmpty(text, 'Please inform user login'),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      _password = text.replaceAll(' ', '').toLowerCase();
                    },
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (text) => combiner([
                      () => isNotEmpty(text),
                      () => validatorNumber(text, characterSize),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      if (_fetching) {
                        const CircularProgressIndicator();
                      }
                      return MaterialButton(
                        onPressed: () {
                          final isValid = Form.of(context)!.validate();
                          if (isValid) {
                            _submit(context);
                          }
                        },
                        color: Colors.blue,
                        child: const Text('Sign'),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fetching = true;
    });
    final result = await Injector.of(context).authenticationRepository.signIn(
          _username,
          _password,
        );

    if (!mounted) {
      return;
    }
    result.when((failure) {
      setState(() {
        _fetching = false;
      });
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
      Navigator.pushReplacementNamed(
        context,
        Routes.home,
      );
    });
  }
}
