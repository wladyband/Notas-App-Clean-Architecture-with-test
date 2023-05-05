import 'package:flutter/material.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/presentation/modules/product/update/controller/product_update_controller.dart';
import 'package:notas/app/presentation/modules/product/update/views/product_update_form.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

class SubmitButtonProductUpdate extends StatelessWidget {
  final Product capturedProduct;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;

  const SubmitButtonProductUpdate({
    Key? key,
    required this.capturedProduct,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductUpdateController>();
    if (controller.state.fetching!) {
      return const CircularProgressIndicator();
    }
    return MaterialButton(
      onPressed: () => _submit(context),
      color: Colors.blue,
      child: const Text('Product'),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final controller = context.read<ProductUpdateController>();
    final form = Form.of(context)!;
    if (form.validate()) {
      form.save();
      final updatedProduct = ProductUpdateForm(
        id: capturedProduct.id,
        name: nameController.text,
        price: double.parse(priceController.value.text),
        quantity: int.parse(quantityController.value.text),
      );
      final result = await controller.submit(updatedProduct);
      result.when(
        left: (failure) {
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
        },
        right: (product) {
          Navigator.pushReplacementNamed(
            context,
            Routes.shopping_list,
          );
        },
      );
    }
  }
}
