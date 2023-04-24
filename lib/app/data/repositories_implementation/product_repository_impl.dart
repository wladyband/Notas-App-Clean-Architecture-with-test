import 'package:notas/app/data/http/http.dart';
import 'package:notas/app/data/services/remote/productAPI.dart';
import 'package:notas/app/domain/models/product.dart';
import 'package:notas/app/domain/repositories/ProductRepository.dart';


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
}
