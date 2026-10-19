import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart.dart';
import 'package:mini_katalog/utils/format.dart';

void main() {
  const product = Product(
    id: 1,
    name: 'Test Ürün',
    tagline: 'Deneme',
    description: 'Açıklama',
    price: 1299,
    currency: 'USD',
    image: '',
    specs: {'Çip': 'A1'},
  );

  test('Product.fromJson JSON verisini doğru okur', () {
    final p = Product.fromJson({
      'id': 5,
      'name': 'iPhone',
      'tagline': 'Kısa',
      'description': 'Uzun',
      'price': 999,
      'currency': 'USD',
      'image': 'x.png',
      'specs': {'Çip': 'A17'},
    });
    expect(p.id, 5);
    expect(p.price, 999.0);
    expect(p.specs['Çip'], 'A17');
    expect(p.toJson()['name'], 'iPhone');
  });

  test('Sepet ekleme ve toplam hesaplama', () {
    final c = Cart();
    c.add(product);
    c.add(product);
    expect(c.totalCount, 2);
    expect(c.totalPrice, 2598.0);
    c.decrease(product);
    expect(c.totalCount, 1);
    c.remove(product);
    expect(c.isEmpty, true);
  });

  test('Fiyat biçimlendirme', () {
    expect(formatPrice(2499), '\$2,499');
    expect(formatPrice(249.9), '\$249.90');
    expect(formatPrice(99), '\$99');
  });
}
