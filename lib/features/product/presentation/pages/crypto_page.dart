import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late WebSocketChannel _channel;
  double? previousPrice;
  Color priceColor = Colors.green;

  @override
  void initState() {
    super.initState();
    // Membuka koneksi WebSocket ke Binance (BTC/USDT)
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Penting: Tutup koneksi agar tidak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Harga Bitcoin'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _channel.stream,
        builder: (context, snapshot) {
          // Hanya tampilkan loading di awal koneksi saja
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Koneksi Terputus! Periksa Internet.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Menunggu data dari bursa...'));
          }

          try {
            final Map<String, dynamic> dataJson = jsonDecode(snapshot.data as String);
            final String priceString = dataJson['p'] ?? '0.00';
            final double currentPrice = double.tryParse(priceString) ?? 0.0;

            // Logika Perubahan Warna (Tugas Mandiri Modul 5)
            if (previousPrice != null) {
              if (currentPrice > previousPrice!) {
                priceColor = Colors.green;
              } else if (currentPrice < previousPrice!) {
                priceColor = Colors.red;
              }
            }
            previousPrice = currentPrice;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.currency_bitcoin, size: 120, color: Colors.orange),
                  const SizedBox(height: 20),
                  const Text('Harga BTC/USDT (Binance):', style: TextStyle(fontSize: 18)),
                  
                  // Tampilan Harga Real-time
                  Text(
                    '\$ ${currentPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: priceColor,
                    ),
                  ),

                  const SizedBox(height: 80),

                  // DEMO TANPA ISOLATE (Macet)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () {
                      // Ini akan menghentikan event loop Flutter sementara
                      int hasil = 0;
                      for (int i = 0; i < 2000000000; i++) { hasil += i; }
                      debugPrint("Perhitungan Main Thread Selesai: $hasil");
                    },
                    child: const Text('Siksa Main Thread (UI Macet)'),
                  ),

                  const SizedBox(height: 10),

                  // DEMO DENGAN ISOLATE (Lancar)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: () async {
                      debugPrint("Menjalankan Isolate...");
                      // Menjalankan fungsi berat di thread terpisah
                      await compute(tugasMenghitungBerat, 2000000000);
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Isolate Selesai! UI tidak macet.")),
                        );
                      }
                    },
                    child: const Text('Gunakan Isolate (UI Lancar)'),
                  ),
                ],
              ),
            );
          } catch (e) {
            return Center(child: Text("Error Data: $e"));
          }
        },
      ),
    );
  }
}

// FUNGSI TOP-LEVEL (Wajib di luar class agar bisa dipakai Isolate)
int tugasMenghitungBerat(int jumlah) {
  int hasil = 0;
  for (int i = 0; i < jumlah; i++) {
    hasil += i;
  }
  return hasil;
}