import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:utd_advanced_app/features/auth/auth_service.dart';

// 1. MEMBUAT STUNTMAN (MOCK CLIENT)
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AuthService authService;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    // Berikan Stuntman ke AuthService, AuthService tidak akan sadar kalau ini palsu
    authService = AuthService(mockApiClient); // [ARRANGE]
  });

  group('AuthService Login Tests -', () {
    test('Harus mengembalikan pesan error jika email kosong', () async {
      final result = await authService.loginUser("", "password123"); // [ACT]
      
      expect(result, "Email dan Password tidak boleh kosong!"); // [ASSERT]
      // Verifikasi bahwa si Stuntman tidak pernah disuruh kerja karena gagal di awal
      verifyNever(() => mockApiClient.loginKeServer(any(), any()));
    });

    test('Harus mengembalikan "Login Berhasil!" jika API membalas true', () async {
      // Bisiki si Stuntman: "Kalau disuruh login dengan data ini, langsung jawab TRUE ya!"
      when(() => mockApiClient.loginKeServer('admin@utd.id', 'rahasia123'))
          .thenAnswer((_) async => true); // [ARRANGE]

      final result = await authService.loginUser('admin@utd.id', 'rahasia123'); // [ACT]

      expect(result, "Login Berhasil!"); // [ASSERT]
      // Pastikan stuntman benar-benar dipanggil tepat 1 kali
      verify(() => mockApiClient.loginKeServer('admin@utd.id', 'rahasia123')).called(1);
    });

    test('Harus mengembalikan "Terjadi Kesalahan Jaringan" jika API error/mati', () async {
      // Bisiki si Stuntman: "Nanti kalau dipanggil, kamu pura-pura mati/error ya!"
      when(() => mockApiClient.loginKeServer(any(), any()))
          .thenThrow(Exception('No Internet')); // [ARRANGE]

      final result = await authService.loginUser('user@utd.id', 'pass123'); // [ACT]

      expect(result, "Terjadi Kesalahan Jaringan"); // [ASSERT]
    });
  });
}