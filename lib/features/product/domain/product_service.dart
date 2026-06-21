import 'product_model.dart';
import '../data/product_repository.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  Future<List<Product>> getAllProducts() async {
    return await _repository.getProducts();
  }

  Future<Product> fetchProductDetail(String id) async {
    final products = await _repository.getProducts();
    return products.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception("Produk tidak ditemukan"),
    );
  }
}