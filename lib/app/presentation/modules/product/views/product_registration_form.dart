import 'package:flutter/material.dart';
import 'package:notas/app/presentation/modules/sign_in/views/widgets/submit_button.dart';

class ProductRegistrationForm extends StatefulWidget {
  const ProductRegistrationForm({Key? key}) : super(key: key);

  @override
  State<ProductRegistrationForm> createState() =>
      _ProductRegistrationFormState();
}

class _ProductRegistrationFormState extends State<ProductRegistrationForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('CADASTRO DE PRODUTOS')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "nome"),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Preço"),
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Quantidade"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
