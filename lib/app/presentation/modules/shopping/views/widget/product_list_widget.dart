import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/presentation/routes/routes.dart';
import 'package:pagination_view/pagination_view.dart';

class ProductListWidget extends StatefulWidget {
  final List<Product> products;

  const ProductListWidget({Key? key, required this.products}) : super(key: key);

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final int _pageSize = 10;
  final GlobalKey<PaginationViewState> _paginationViewKey = GlobalKey();

  Future<List<Product>> _fetchPage(int page) async {
    if (page <= 0) {
      return [];
    }
    final start = (page - 1) * _pageSize;
    final end = start + _pageSize;
    final newProducts = widget.products.getRange(start, end).toList();
    await Future.delayed(const Duration(seconds: 1));
    return newProducts;
  }

  Future<void> _refresh() async {
    _paginationViewKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: PaginationView<Product>(
        key: _paginationViewKey,
        paginationViewType: PaginationViewType.listView,
        preloadedItems: widget.products,
        itemBuilder: (BuildContext context, Product product, int index) => ListTile(
          title: Text(product.name),
          subtitle: Text('Preço: ${product.price} - Quantidade: ${product.quantity}'),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                Routes.product_update,
                arguments: product.id,
              );
            },
          ),
        ),
        pageFetch: _fetchPage,
        onError: (dynamic error) => const Center(
          child: Text('Algum erro ocorreu'),
        ),
        onEmpty: const Center(
          child: Text('Não há produtos disponíveis'),
        ),
        bottomLoader: const Center(
          child: CircularProgressIndicator(),
        ),
        initialLoader: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

