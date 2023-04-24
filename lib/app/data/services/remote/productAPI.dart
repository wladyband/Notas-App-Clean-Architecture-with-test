import 'dart:convert';

import 'package:notas/app/data/http/http.dart';
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
      method: HttpMethod.get,
    );

    return result.when(
      left: (_) => [],
      right: (products) => products,
    );
  }
}
