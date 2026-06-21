class SimpleCalculator {
  // Fungsi 1: Pertambahan
  int add(int a, int b) {
    return a + b;
  }

  // Fungsi 2: Perhitungan Diskon
  double calculateDiscount(double price, double discountPercent) {
    if (discountPercent < 0 || discountPercent > 100) {
      throw ArgumentError('Diskon tidak masuk akal!');
    }
    return price - (price * (discountPercent / 100));
  }
}