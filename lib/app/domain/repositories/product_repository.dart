import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/failures/sign_in_failure.dart';
import 'package:notas/app/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductData();

  Future<Either<SignInFailure, String>> createProduct();
}
