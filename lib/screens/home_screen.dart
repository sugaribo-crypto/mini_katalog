import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/cart.dart';
import '../widgets/product_card.dart';

/// Ana sayfa: başlık, arama kutusu, banner ve ürün listesi (GridView).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _bannerUrl = 'https://wantapi.com/assets/banner.png';

  List<Product> _allProducts = [];
  String _query = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ProductRepository.loadProducts();
      setState(() {
        _allProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ürünler yüklenemedi: $e';
        _isLoading = false;
      });
    }
  }

  /// Arama kutusuna yazılan metne göre filtrelenmiş ürünler.
  List<Product> get _filteredProducts {
    if (_query.trim().isEmpty) return _allProducts;
    final q = _query.toLowerCase();
    return _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.tagline.toLowerCase().contains(q))
        .toList();
  }

  void _openDetail(Product product) {
    // Named route ile detay sayfasına geç, ürünü argüman olarak gönder
    Navigator.pushNamed(context, '/detail', arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final products = _filteredProducts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildSearchField(),
          const SizedBox(height: 16),
          _buildBanner(),
          const SizedBox(height: 16),
          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('Aramanıza uygun ürün bulunamadı.')),
            )
          else
            GridView.builder(
              // Sayfanın kendisi kaydığı için GridView'in kendi kaydırması kapalı
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => _openDetail(product),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Image.asset ile uygulama içine gömülü logo
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/images/logo.png', width: 36, height: 36),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keşfet',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(
                'Sana en uygun cihazı bul.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Sepet ikonu: sepet değiştikçe rozet (badge) güncellenir
        ListenableBuilder(
          listenable: cart,
          builder: (context, child) {
            return IconButton(
              tooltip: 'Sepet',
              onPressed: () {
                // Ekranda kalmış bir bilgi mesajı varsa sepete geçmeden kapat
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pushNamed(context, '/cart');
              },
              icon: Badge(
                isLabelVisible: cart.totalCount > 0,
                label: Text('${cart.totalCount}'),
                child: const Icon(Icons.shopping_bag_outlined, size: 28),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: 'Ürün ara',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        _bannerUrl,
        width: double.infinity,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 100,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Text(
            'GIFT STORE',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
