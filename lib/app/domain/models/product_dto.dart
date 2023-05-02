class ProductFormData {
  final String? id;
  final String name;
  final double price;
  final int quantity;

  ProductFormData({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  ProductFormData copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return ProductFormData(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}