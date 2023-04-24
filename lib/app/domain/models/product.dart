import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    price: num.parse(json['price']),
    quantity: json['quantity'],
  );

  static List<Product> fromJsonList(List<Map<String, dynamic>> jsonList) =>
      jsonList.map((json) => Product.fromJson(json)).toList();

  static List<Map<String, dynamic>> toJsonList(List<Product> products) =>
      products.map((product) => product.toJson()).toList();
}
