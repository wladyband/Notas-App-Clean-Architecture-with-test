import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notas/app/domain/typedefs.dart';

part 'product.freezed.dart';

part 'product.g.dart';

@Freezed(toJson: true)
class Product with _$Product {
  const factory Product({
    String? id,
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
        price: json['price'] is String
            ? double.parse(json['price'])
            : (json['price'] is num ? json['price'].toDouble() : 0),
        quantity: json['quantity'] is num
            ? int.parse(json['quantity'].toString())
            : 0,
      );

  static List<Product> fromJsonList(jsonListMapDynamic jsonList) =>
      jsonList.map((json) => Product.fromJson(json)).toList();

  static jsonListMapDynamic toJsonList(List<Product> products) =>
      products.map((product) => product.toJson()).toList();
}
