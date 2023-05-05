import 'package:flutter/cupertino.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/http_request/http_request_failure.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/domain/repositories/product_repository.dart';
import 'package:notas/app/presentation/global/state_notifier.dart';
import 'package:notas/app/presentation/modules/product/update/controller/product_update_state.dart';
import 'package:notas/app/presentation/modules/product/update/views/product_update_form.dart';

class ProductUpdateController extends StateNotifier<ProductUpdateState> {
  ProductUpdateController(this.capturedProduct, {required this.productRepository}) : super(ProductUpdateState()) {
    onInit(capturedProduct);
  }

  final ProductRepository productRepository;
  final ProductUpdateForm? capturedProduct;
  late final productNameController = TextEditingController();
  late final productPriceController = TextEditingController();
  late final productQuantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    productQuantityController.dispose();
    super.dispose();
  }

  void onInit(ProductUpdateForm? product) {
    if (product != null) {
      productNameController.text = product.name ?? '';
      productPriceController.text = product.price?.toString() ?? '';
      productQuantityController.text = product.quantity?.toString() ?? '';
    }
  }

  String get productName => productNameController.text.trim().toLowerCase();
  double get productPrice => double.tryParse(productPriceController.text) ?? 0.0;
  int get productQuantity => int.tryParse(productQuantityController.text) ?? 0;


  Future<Either<HttpRequestFailure, Product>> submit(ProductUpdateForm form) async {
    final result = await productRepository.updateProduct(
      form.id ?? '',
      form.name?.trim()?.toLowerCase() ?? '',
      form.price?.toDouble() ?? 0.0,
      form.quantity ?? 0,
    );
    result.when(
      left: (_) => onlyUpdate(state.copyWith(fetching: false)),
      right: (p0) => null,
    );
    return result;
  }

  FormState getForm() => formKey.currentState!;
}

