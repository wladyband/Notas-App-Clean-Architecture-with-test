import 'package:notas/app/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>>   getProductData();
}
