import 'package:flutter/material.dart';
import 'package:notas/app/presentation/modules/product/update/controller/product_update_controller.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

class SubmitButtonProductUpdate extends StatelessWidget {
  const SubmitButtonProductUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ProductUpdateController controller = Provider.of(context);
    if (controller.state.fetching!) {
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
      child: const Text('Product'),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final ProductUpdateController controller = context.read();

    final result = await controller.submit();

    if (!controller.mounted) {
      return;
    }
    result.when(left: (failure) {
      final message = failure.when(
        notFound: () => 'não foi encontrado',
        invalidEmail: () => 'email inválido',
        network: () => 'não tem internet',
        unauthorized: () => 'autorização inválida',
        unknown: () => 'Erro interno',
        productUnlist: () => 'Lista não carregada',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }, right: (product) {
      Navigator.pushReplacementNamed(
        context,
        Routes.shopping_list,
      );
    });
  }
}
