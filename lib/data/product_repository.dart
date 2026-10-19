import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Ürün verilerini okuyan sınıf.
///
/// Gerçek bir API yerine, uygulamanın içine gömülü JSON dosyasından
/// (assets/data/products.json) veri okunur. Bu bir API simülasyonudur.
class ProductRepository {
  static const String _jsonPath = 'assets/data/products.json';

  static Future<List<Product>> loadProducts() async {
    // JSON dosyasını metin olarak oku
    final String rawJson = await rootBundle.loadString(_jsonPath);

    // Metni Map'e çevir
    final Map<String, dynamic> decoded =
        jsonDecode(rawJson) as Map<String, dynamic>;

    // "data" listesindeki her elemanı Product nesnesine dönüştür
    final List<dynamic> items = decoded['data'] as List<dynamic>;
    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
