import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

// Import config baru untuk manajemen flavor
import 'package:utd_advanced_app/core/config/env_config.dart';

// Import halaman lain
import '../../../profile/presentation/pages/profile_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // MENYESUAIKAN MODUL 11: Menampilkan judul dinamis + ENV_NAME 
        title: Text('Katalog UTD [${EnvConfig.environment}]'),
        // CATATAN: backgroundColor & foregroundColor dihapus dari sini agar 
        // otomatis mengikuti ThemeData dinamis yang sudah Anda buat di main.dart [cite: 177, 178]
        leading: IconButton(
          icon: const Icon(Icons.account_circle, size: 30),
          onPressed: () => context.push('/profile'), 
        ),
        actions: [
          // 1. Tombol Menuju Halaman Animasi (Modul 10)
          IconButton(
            icon: const Icon(Icons.animation),
            tooltip: 'Advanced Animations',
            onPressed: () => context.push('/animation'),
          ),
          
          // 2. Tombol Background Sync (Modul 9)
          IconButton(
            icon: const Icon(Icons.sync), 
            tooltip: 'Background Sync',
            onPressed: () => context.push('/sync'),
          ),
          
          // 3. Tombol To-Do List
          IconButton(
            icon: const Icon(Icons.checklist),
            tooltip: 'To-Do List',
            onPressed: () => context.push('/todo'), // [cite: 183]
          ),
          
          // 4. Tombol Native Features
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Native Features',
            onPressed: () => context.push('/native'),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8), 
              itemCount: state.products.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: product.image.isNotEmpty
                        ? Image.network(product.image, fit: BoxFit.contain)
                        : const Icon(Icons.image, size: 40),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('ID: ${product.id}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    context.push('/detail/${product.id}');
                  },
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Menunggu data...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crypto'),
        label: const Text('Live Crypto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.trending_up, color: Colors.white),
        backgroundColor: Colors.orange,
      ),
    );
  }
}