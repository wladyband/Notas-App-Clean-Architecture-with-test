import 'package:flutter/material.dart';

class ProductRegistrationView extends StatefulWidget {
  const ProductRegistrationView({Key? key}) : super(key: key);

  @override
  State<ProductRegistrationView> createState() =>
      _ProductRegistrationViewState();
}

class _ProductRegistrationViewState extends State<ProductRegistrationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRO DE PRODUTOS'),
      ),
    );
  }
}
