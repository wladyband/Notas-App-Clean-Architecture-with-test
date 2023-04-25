import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/domain/models/enums.dart';
import 'package:notas/app/domain/models/product.dart';

class ProductAPI {
  final Http _http;

  ProductAPI(this._http);



  Future<List<Product>> getProductIdUser(String newRequestIdUser) async {
    final result = await _http.request(
      '/products',
      queryParameter: {
        'id': newRequestIdUser,
      },
      onSuccessCustom: (json) {
        List<Map<String, dynamic>> productsJson = json;
        List<Product> products = Product.fromJsonList(productsJson);
        return products;
      },
    );

    return result.when(
      left: (_) => [],
      right: (products) => products,
    );
  }

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode!) {
        case 400:
          return Either.left(SignInFailure.invalidEmail());
        case 401:
          return Either.left(SignInFailure.unauthorized());
        case 404:
          return Either.left(SignInFailure.notFound());
        default:
          return Either.left(SignInFailure.unknown());
      }
    }
    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.network());
    }
    return Either.left(SignInFailure.unknown());
  }

  Future<Either<SignInFailure, String>> createProduct(String newRequestIdUser, {
    required String name,
    required double price,
    required int quantity,

  }) async {
    final result = await _http.request(
      '/products',
      onSuccess: ((responseBody) {
        final json = responseBody as Map;
        final productId = json['id'] as String;
        return productId;
      }),
      method: HttpMethod.post,
      body: {
        'name': name,
        'price': price.toString(),
        'quantity': quantity.toString(),
        'user_id': newRequestIdUser,
      },
    );
    return result.when(
      left: _handleFailure,
      right: (productId) => Either.right(productId),
    );
  }
}
