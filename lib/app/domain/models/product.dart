import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notas/app/domain/typedefs.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@Freezed(toJson: true)
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required num price,
    required int quantity,
  }) = _Product;

  const Product._();

  String getFormatted() {
    return '$id $name $price $quantity';
  }

  factory Product.fromJson(jsonMapDynamic json) => Product(
    id: json['id'],
    name: json['name'],
    price: num.parse(json['price']),
    quantity: json['quantity'],
  );

  static List<Product> fromJsonList(jsonListMapDynamic jsonList) =>
      jsonList.map((json) => Product.fromJson(json)).toList();

  static jsonListMapDynamic toJsonList(List<Product> products) =>
      products.map((product) => product.toJson()).toList();
}
