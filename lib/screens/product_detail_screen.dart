import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart.dart';
import '../utils/format.dart';
import '../widgets/product_image.dart';

/// Ürün detay sayfası.
/// Gösterilecek ürün, Route Arguments ile ana sayfadan gönderilir.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Route Arguments: ana sayfada pushNamed ile gönderilen ürünü al
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Geri'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Büyük ürün görseli
            Container(
              width: double.infinity,
              height: 280,
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(24),
              child: Hero(
                tag: 'product-${product.id}',
                child: ProductImage(url: product.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.tagline,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Açıklama',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Özellikler',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.specs.entries
                        .map((spec) => _SpecChip(
                              label: spec.key,
                              value: spec.value,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Alt kısım: fiyat ve sepete ekle butonu
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Text(
                formatPrice(product.price),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Sepete Ekle'),
                  onPressed: () {
                    cart.add(product);
                    // Kısa bilgi mesajı. Buton (action) eklenmediği için
                    // mesaj 2 saniye sonra kendiliğinden kaybolur.
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('${product.name} sepete eklendi'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Özellik kutucuğu (ör. "Çip / A17 Pro").
class _SpecChip extends StatelessWidget {
  final String label;
  final String value;

  const _SpecChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
