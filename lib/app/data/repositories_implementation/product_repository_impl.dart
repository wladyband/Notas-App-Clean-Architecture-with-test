import 'dart:convert';

import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/data/services/remote/productAPI.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/domain/repositories/product_repository.dart';


class ProductRepositoryImpl implements ProductRepository {
  final ProductAPI _productAPI;
  final Http _http;

  ProductRepositoryImpl(this._productAPI, this._http);

  @override
  Future<List<Product>>  getProductData() async{
    final result = await _productAPI.getProductIdUser(
      _http.idUserFind.toString(),
    );
    return result;
  }

  @override
  Future<Either<SignInFailure, String>> createProduct() async{
    try {
      final products = await _productAPI.getProductIdUser(_http.idUserFind.toString());
      final productsJson = Product.toJsonList(products);
      final json = {'products': productsJson};
      final jsonString = jsonEncode(json);
      return Either.right(jsonString);
    } catch (e) {
      return Either.left(SignInFailure.unknown());
    }
  }
}
