import '../domain/product_model.dart';
import '../../../core/network/api_client.dart';

class ProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiClient.get('products'); 
      // Karena Dio, data biasanya ada di response.data
      final List data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Gagal muat produk: $e");
    }
  }
}