import 'package:flutter/material.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/domain/repositories/product_repository.dart';
import 'package:notas/app/presentation/modules/shopping/views/widget/product_list_widget.dart';
import 'package:provider/provider.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _init();
      },
    );
  }

  Future<void> _init() async {
    final ProductRepository productRepository = context.read();
    List<Product> productList = await productRepository.getProductData();
    setState(() {
      products = productList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LISTA DE COMPRAS'),
      ),
      body: products.isNotEmpty
          ? ProductListWidget(products: products)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
