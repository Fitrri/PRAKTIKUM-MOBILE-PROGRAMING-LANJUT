import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart'; 
import '../../domain/product_service.dart';
import '../../domain/product_model.dart';

class DetailPage extends StatelessWidget {
  final String productId;
  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        backgroundColor: const Color(0xFF4CAF50), // Warna Hijau
        foregroundColor: Colors.white,
        centerTitle: true,
        // Ikon menu (leading) dan filter (actions) sudah dihapus
      ),
      body: FutureBuilder<Product?>(
        future: locator<ProductService>().fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Gagal memuat detail produk"));
          }

          final p = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container Gambar Produk
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.network(p.image, height: 200, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Judul dan ID Produk
                Center(
                  child: Column(
                    children: [
                      Text(
                        p.name, 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), 
                        textAlign: TextAlign.center
                      ),
                      Text("ID: ${p.id}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Kategori
                Text.rich(TextSpan(children: [
                  const TextSpan(text: "Category: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: p.category),
                ])),
                const Divider(),
                
                // Deskripsi
                const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(p.description),
                const Divider(),
                
                // Harga
                Text(
                  "Price: \$${p.price}", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
                const SizedBox(height: 40),
                
                // Tombol Aksi
                _buildButton("Beli Sekarang"),
                const SizedBox(height: 10),
                _buildButton("Tambah ke Keranjang"),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget untuk tombol agar konsisten
  Widget _buildButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}