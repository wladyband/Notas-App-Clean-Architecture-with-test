import 'package:flutter/material.dart';
import 'package:notas/app/data/services/utils/validations.dart';
import 'package:notas/app/presentation/modules/product/controller/product_registrarion_state.dart';
import 'package:notas/app/presentation/modules/product/controller/product_registration_controller.dart';
import 'package:notas/app/presentation/modules/product/views/widget/submit_button.dart';
import 'package:provider/provider.dart';

class ProductRegistrationForm extends StatelessWidget with Validations {
  final int characterSize = 4;

  const ProductRegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductRegistrationController>(
      create: (_) => ProductRegistrationController(
        const ProductRegistrationState(),
        productRepository: context.read(),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Builder(builder: (context) {
              final controller =
                  Provider.of<ProductRegistrationController>(context);
              return AbsorbPointer(
                absorbing: controller.state.fetching,
                child: ListView(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (text) {
                        try {
                          controller.onProductNameChanged(text);
                        } catch (e) {
                          print('Erro  no nome do produto : $e');
                        }
                      },
                      decoration: const InputDecoration(labelText: "nome"),
                      textInputAction: TextInputAction.next,
                      validator: (text) => combiner([
                        () =>
                            isNotEmpty(text, 'Por favor preencha o campo nome'),
                        () => validatorNumber(text, characterSize),
                      ]),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        try {
                          controller.onProductPriceChanged(double.parse(value));
                        } catch (e) {
                          print('Erro  no preço do produto : $e');
                        }
                      },
                      decoration: const InputDecoration(labelText: "Preço"),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) => combiner([
                        () => isNotEmpty(
                            value, 'Por favor preencha o campo preço'),
                        () => isNumeric(value),
                      ]),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        try {
                          controller.onProductQuantityChanged(int.parse(value));
                        } catch (e) {
                          print('Erro  na quantidade do produto : $e');
                        }
                      },
                      decoration:
                          const InputDecoration(labelText: "Quantidade"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (text) => combiner([
                        () => isNotEmpty(
                            text, 'Por favor preencha o campo quantidade'),
                        () => isNumeric(text),
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
    );
  }
}
