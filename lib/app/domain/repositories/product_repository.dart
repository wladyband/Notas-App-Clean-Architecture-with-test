import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/http_request/http_request_failure.dart';

import 'package:notas/app/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductData();
  Future<Either<HttpRequestFailure, Product>> getProductIdProduct(String idProduct );

  Future<Either<HttpRequestFailure, Product>> createProduct(
    String name,
    num price,
    int quantity,
  );

  Future<Either<HttpRequestFailure, Product>> updateProduct(
      String idProduct, String name, num price, int quantity);
}
