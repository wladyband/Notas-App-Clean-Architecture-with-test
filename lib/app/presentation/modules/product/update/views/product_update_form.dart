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
  const ProductUpdateForm({Key? key,  this.id,  this.name,  this.price,  this.quantity}) : super(key: key);
  final String? id;
  final String? name;
  final num? price;
  final int? quantity;

  @override
  State<ProductUpdateForm> createState() => _ProductUpdateFormState();
}

class _ProductUpdateFormState extends State<ProductUpdateForm>
    with Validations {
  final int characterSize = 4;
  final _formKey = GlobalKey<FormState>();
  late String selectedProductId;
  late Product capturedProduct;
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  _ProductUpdateFormState() {
    capturedProduct = _createMockProduct();
  }

  Product _createMockProduct() {
    return const Product(
      id: '1',
      name: 'Mock Product',
      price: 19.99,
      quantity: 10,
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _priceController = TextEditingController(text: widget.price?.toString());
    _quantityController =
        TextEditingController(text: widget.quantity?.toString());
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
        _nameController.text = productData.name;
        _priceController.text = productData.price.toString();
        _quantityController.text = productData.quantity.toString();
        setState(() {
          capturedProduct = productData;
        });
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<ProductUpdateController>(
      create: (_) => ProductUpdateController(
        const ProductUpdateForm(),
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
              return AbsorbPointer(
                absorbing: controller.state.fetching!,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
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
                      controller: _priceController,
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
                      controller: _quantityController,
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
                    SubmitButtonProductUpdate(
                      capturedProduct: capturedProduct,
                      nameController: _nameController,
                      priceController: _priceController,
                      quantityController: _quantityController,
                    ),
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
