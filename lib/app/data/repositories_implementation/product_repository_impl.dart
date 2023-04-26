import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/data/services/remote/productAPI.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/http_request/http_request_failure.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductAPI _productAPI;
  final Http _http;

  ProductRepositoryImpl(this._productAPI, this._http);

  @override
  Future<List<Product>> getProductData() async {
    final result = await _productAPI.getProductIdUser(
      _http.idUserFind.toString(),
    );
    return result;
  }

  @override
  Future<Either<HttpRequestFailure, Product>> createProduct(
    String name,
    num price,
    int quantity,
  ) async {
    try {
      await _productAPI.createProduct(
        _http.idUserFind.toString(),
        name: name,
        price: price,
        quantity: quantity,
      );
      final product = Product(name: name, price: price, quantity: quantity);
      return Right(product);
    } catch (e) {
      return Left(HttpRequestFailure.productUnlist());
    }
  }
}
