
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/http_request/http_request_failure.dart';

import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/domain/repositories/product_repository.dart';
import 'package:notas/app/presentation/global/state_notifier.dart';
import 'package:notas/app/presentation/modules/product/register/controller/product_registrarion_state.dart';


class ProductRegistrationController extends StateNotifier<ProductRegistrationState>{
  ProductRegistrationController(super.state, {
    required this.productRepository
  });

  final ProductRepository productRepository;


  void onProductNameChanged(String text) {
    onlyUpdate(
      state.copyWith(
        name: text.trim().toLowerCase(),
      ),
    );
  }

  void onProductPriceChanged(num valor) {
    onlyUpdate(
      state.copyWith(
        price: valor.toDouble(),
      ),
    );
  }

  void onProductQuantityChanged(int valor) {
    onlyUpdate(
      state.copyWith(
        quantity: valor.toInt(),
      ),
    );
  }

  Future<Either<HttpRequestFailure, Product>> submit() async {
    state = state.copyWith(fetching: true);
    final result = await productRepository.createProduct(
      state.name,
      state.price,
      state.quantity,
    );
    result.when(
      left:  (_) => state = state.copyWith(fetching: false),
      right:  (p0) => null,
    );
    return result;
  }

}