import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/product_service.dart'; // Pastikan import service benar
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _productService;

  // Constructor menerima ProductService dari locator
  ProductCubit(this._productService) : super(ProductInitial());

  Future<void> fetchAllProducts() async {
    emit(ProductLoading());
    try {
      // MEMANGGIL DATA SUNGGUHAN
      final products = await _productService.getAllProducts();
      
      if (products.isEmpty) {
        emit(ProductError("Data produk kosong"));
      } else {
        emit(ProductLoaded(products));
      }
    } catch (e) {
      emit(ProductError("Gagal mengambil data: ${e.toString()}"));
    }
  }
}