import 'package:flutter/material.dart';

import '../state/cart.dart';
import '../utils/format.dart';
import '../widgets/product_image.dart';

/// Sepet sayfası (simülasyon).
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Sepet'),
        titleSpacing: 0,
      ),
      // Sepet her değiştiğinde (ekle / çıkar) bu bölüm yeniden çizilir
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: cart.isEmpty ? _buildEmpty() : _buildList(),
              ),
              _buildBottom(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: Colors.grey.shade500),
          const SizedBox(height: 12),
          const Text(
            'Sepetiniz boş',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Alışverişe başlamak için ürün ekleyin.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final items = cart.items;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;
        return Row(
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ProductImage(url: product.image),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    product.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(formatPrice(product.price),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            // Adet azalt / artır
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => cart.decrease(product),
            ),
            Text('${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => cart.add(product),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottom(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: Colors.grey.shade700),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Bu bir demo uygulamasıdır, gerçek ödeme alınmaz.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Toplam (${cart.totalCount} ürün)',
                    style: const TextStyle(fontSize: 15)),
                Text(
                  formatPrice(cart.totalPrice),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: cart.isEmpty ? null : () => _checkout(context),
                child: const Text('Siparişi Tamamla'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkout(BuildContext context) {
    final total = formatPrice(cart.totalPrice);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sipariş alındı 🎉'),
        content: Text(
            'Toplam $total tutarındaki siparişiniz alındı.\n(Bu bir simülasyondur.)'),
        actions: [
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(dialogContext);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
