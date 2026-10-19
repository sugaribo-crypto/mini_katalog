/// Ürün veri modeli.
///
/// assets/data/products.json dosyasındaki her bir ürün bu sınıfa dönüştürülür.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String currency;
  final String image;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  /// JSON (Map) verisinden Product nesnesi oluşturur.
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specs'] as Map<String, dynamic>? ?? {};
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      specs: rawSpecs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  /// Product nesnesini tekrar JSON (Map) formatına çevirir.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'currency': currency,
      'image': image,
      'specs': specs,
    };
  }
}
