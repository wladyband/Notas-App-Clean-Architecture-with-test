import 'package:flutter/material.dart';
import 'package:notas/app/data/services/utils/validations.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/domain/repositories/product_repository.dart';

import 'package:notas/app/presentation/modules/product/update/controller/product_update_controller.dart';
import 'package:notas/app/presentation/modules/product/update/controller/product_update_state.dart';
import 'package:notas/app/presentation/modules/product/update/views/widget/submit_button_product_update.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

class ProductUpdateForm extends StatefulWidget {
  const ProductUpdateForm({Key? key}) : super(key: key);

  @override
  State<ProductUpdateForm> createState() => _ProductUpdateFormState();
}

class _ProductUpdateFormState extends State<ProductUpdateForm>
    with Validations {
  final int characterSize = 4;

  late String selectedProductId;

  late TextEditingController _productIdController;
  late TextEditingController _productNameController;
  late TextEditingController _productPriceController;
  late TextEditingController _productQuantityController;

  late Product product = const Product(name: '', price: 0, quantity: 0);

  @override
  void initState() {
    super.initState();
    _productIdController = TextEditingController();
    _productNameController = TextEditingController();
    _productPriceController = TextEditingController();
    _productQuantityController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    selectedProductId = ModalRoute.of(context)!.settings.arguments as String;
    final ProductRepository productRepository = context.read();
    final productObject =
        await productRepository.getProductIdProduct(selectedProductId);

    productObject.when(
      left: (failure) {
        print('Erro ao carregar o produto: $failure');
      },
      right: (productData) {
        _productIdController.text = productData.id!;
        _productNameController.text = productData.name;
        _productPriceController.text = productData.price.toString();
        _productQuantityController.text = productData.quantity.toString();
        setState(() {
          product = productData;
        });
      },
    );
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _productNameController.dispose();
    _productPriceController.dispose();
    _productQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return ChangeNotifierProvider<ProductUpdateController>(
      create: (_) => ProductUpdateController(
        const ProductUpdateState(),
        productRepository: context.read(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Atualizar produto'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Routes.shopping_list),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Builder(builder: (context) {
              final controller = Provider.of<ProductUpdateController>(context);


              controller.onProductIdChanged(_productIdController.text);
              controller.onProductNameChanged(_productNameController.text);

              String priceText = _productPriceController.text;
              if (priceText.isNotEmpty) {
                double valueDoublePrice = double.parse(priceText);
                if (valueDoublePrice != null) {
                  controller.onProductPriceChanged(valueDoublePrice);
                }
              }

              String quantityText = _productQuantityController.text;
              if (quantityText.isNotEmpty) {
                int? valueDoubleQuantity = int.tryParse(quantityText);
                if (valueDoubleQuantity != null) {
                  controller.onProductQuantityChanged(valueDoubleQuantity);
                }
              }

              return AbsorbPointer(
                absorbing: controller.state.fetching!,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _productNameController,
                      onChanged: (text) {
                        try {
                          controller.onProductNameChanged(text);
                        } catch (e) {
                          print('Erro  no nome do produto : $e');
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(labelText: "nome"),
                      textInputAction: TextInputAction.next,
                      validator: (text) => combiner([
                        () =>
                            isNotEmpty(text, 'Por favor preencha o campo nome'),
                        () => validatorNumber(text, characterSize),
                      ]),
                    ),
                    TextFormField(
                      controller: _productPriceController,
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
                      controller: _productQuantityController,
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
                    const SubmitButtonProductUpdate(),
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
