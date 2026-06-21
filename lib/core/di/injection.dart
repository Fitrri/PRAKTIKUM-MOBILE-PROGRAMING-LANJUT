import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/domain/product_service.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../../features/todo/data/isar_service.dart'; // Import Isar Service

final locator = GetIt.instance;

void setupLocator() {
  // 1. Network (Modul 4)
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // 2. Database (Modul 6)
  // Daftarkan IsarService agar bisa dipanggil di mana saja
  locator.registerLazySingleton<IsarService>(() => IsarService());

  // 3. Repository & Service (Modul 4)
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());
  locator.registerFactory<ProductService>(() => ProductService(locator()));

  // 4. Cubit (Modul 3 & 4)
  locator.registerFactory<ProductCubit>(() => ProductCubit(locator<ProductService>()));
}