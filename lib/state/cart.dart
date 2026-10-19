import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Sepetteki tek bir satır: ürün + adet.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

/// Basit sepet yönetimi (simülasyon).
///
/// Ekstra paket kullanmadan, Flutter'ın kendi ChangeNotifier sınıfı ile
/// state güncellemesi yapılır. Sepet değiştiğinde notifyListeners()
/// çağrılır ve bu sepeti dinleyen ekranlar kendini yeniler.
class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Sepetteki toplam ürün adedi.
  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Sepetin toplam tutarı.
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void add(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Uygulama genelinde kullanılan tek sepet nesnesi.
final Cart cart = Cart();
