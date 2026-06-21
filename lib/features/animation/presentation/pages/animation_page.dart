import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

/// Menggunakan TickerProviderStateMixin agar halaman ini bisa mendukung 
/// lebih dari 1 AnimationController secara bersamaan tanpa mengalami tabrakan detak.
class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  
  // 1. Deklarasi variabel Mesin Waktu (Controller)
  late AnimationController _spinController;   // Untuk rotasi ikon bintang
  late AnimationController _lottieController; // Untuk mengontrol jalannya animasi Lottie

  @override
  void initState() {
    super.initState();

    // 2. Inisialisasi Kontroller untuk Rotasi Bintang
    _spinController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2), 
    );
    _spinController.repeat(); // Perintahkan mesin rotasi untuk melakukan perulangan terus-menerus

    // 3. Inisialisasi Kontroller untuk Animasi Lottie
    _lottieController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    // WAJIB! Menghancurkan semua controller saat halaman ditutup untuk mencegah Memory Leak.
    _spinController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Animations'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // ============================================================
              // BAGIAN 1: EXPLICIT ANIMATION (ROTASI BINTANG)
              // ============================================================
              const Text(
                "Explicit Animation (Putaran Tanpa Henti):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              AnimatedBuilder(
                animation: _spinController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _spinController.value * 6.2831853, // Konversi linimasa ke putaran Radian penuh (360 derajat)
                    child: child,
                  );
                },
                child: const Icon(Icons.star, size: 100, color: Colors.orange),
              ),
    
              const SizedBox(height: 50),
              const Divider(),
              const SizedBox(height: 50),
    
              // ============================================================
              // BAGIAN 2: INTEGRASI ANIMATION LOTTIE (LINK TERBARU YANG AKTIF)
              // ============================================================
              const Text(
                "Lottie Integration (Animasi Desainer):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              Lottie.network(
                // LINK BARU YANG DIJAMIN AKTIF (Animasi Loading Cloud Resmi dari GitHub Lottie)
                'https://assets10.lottiefiles.com/packages/lf20_x62chJ.json',
                width: 150,
                height: 150,
                controller: _lottieController, // Menghubungkan visual ke pengontrol waktu
                onLoaded: (composition) {
                  // Menyamakan durasi pengendali waktu mengikuti runutan waktu asli dari desainer
                  _lottieController.duration = composition.duration;
                },
              ),
              
              const SizedBox(height: 20),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _lottieController.reset();    // Mengembalikan animasi ke posisi awal (detik 0)
                  _lottieController.forward();  // Menjalankan linimasa animasi ke depan
                },
                child: const Text("Mainkan Animasi Ceklis"),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
} 