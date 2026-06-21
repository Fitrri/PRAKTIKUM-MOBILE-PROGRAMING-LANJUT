// Kontrak/Interface tiruan untuk ApiClient
abstract class ApiClient {
  Future<bool> loginKeServer(String email, String password);
}

class AuthService {
  final ApiClient apiClient;
  AuthService(this.apiClient); // Dependency Injection lewat Constructor

  Future<String> loginUser(String email, String password) async {
    // 1. Validasi lokal
    if (email.isEmpty || password.isEmpty) {
      return "Email dan Password tidak boleh kosong!";
    }

    try {
      // 2. Memanggil layanan API internet
      final isSuccess = await apiClient.loginKeServer(email, password);
      
      if (isSuccess) {
        return "Login Berhasil!";
      } else {
        return "Kredensial Salah!";
      }
    } catch (e) {
      return "Terjadi Kesalahan Jaringan";
    }
  }
}