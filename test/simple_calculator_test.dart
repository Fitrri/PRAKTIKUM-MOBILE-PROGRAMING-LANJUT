import 'package:flutter_test/flutter_test.dart';
import 'package:utd_advanced_app/features/calculator/simple_calculator.dart';

void main() {
  group('Pengujian SimpleCalculator -', () {
    late SimpleCalculator calculator;

    // setUp() akan berjalan otomatis SEBELUM setiap test() dimulai
    setUp(() {
      calculator = SimpleCalculator(); // [ARRANGE]: Menyiapkan objek
    });

    test('Fungsi add() harus mengembalikan hasil 5 jika 2 ditambah 3', () {
      final result = calculator.add(2, 3); // [ACT]: Panggil fungsi
      expect(result, 5); // [ASSERT]: Buktikan hasilnya 5
    });

    test('Fungsi calculateDiscount() harus mengembalikan 8000 jika harga 10000 diskon 20%', () {
      final result = calculator.calculateDiscount(10000, 20); // [ACT]
      expect(result, 8000); // [ASSERT]
    });

    test('Fungsi calculateDiscount() harus melempar error jika diskon 150%', () {
      // Menguji error harus dibungkus dalam fungsi anonim () =>
      expect(
        () => calculator.calculateDiscount(10000, 150), // [ACT]
        throwsArgumentError, // [ASSERT]: Berharap kode ini meledak/error
      );
    });
  });
}