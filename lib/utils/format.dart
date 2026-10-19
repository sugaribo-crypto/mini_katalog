/// Fiyatı "$1,299" ya da "$249.90" biçiminde metne çevirir.
String formatPrice(double price) {
  final int whole = price.truncate();
  final String digits = whole.toString();

  // Binlik ayraç ekle: 2499 -> 2,499
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  final int cents = ((price - whole) * 100).round();
  if (cents == 0) {
    return '\$$buffer';
  }
  return '\$$buffer.${cents.toString().padLeft(2, '0')}';
}
