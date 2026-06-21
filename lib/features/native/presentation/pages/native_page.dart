import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  static const platform = MethodChannel('com.utd.advanced_app/battery');
  String _batteryStatusText = 'Belum dicek';
  int _batteryLevel = 0; 

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevel = result;
        _batteryStatusText = '$result%';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryStatusText = "Gagal";
        _batteryLevel = 0;
      });
    }
  }

  Future<void> _showNativeToast() async {
    try {
      await platform.invokeMethod('showToast', {"pesan": "Fitri Anisa - 20123020"});
    } on PlatformException catch (e) {
      debugPrint("Error: ${e.message}");
    }
  }

  // LOGIKA IKON DINAMIS
  IconData _getBatteryIcon(int level) {
    if (level >= 90) return Icons.battery_full_rounded;
    if (level >= 70) return Icons.battery_6_bar_rounded;
    if (level >= 50) return Icons.battery_4_bar_rounded;
    if (level >= 30) return Icons.battery_2_bar_rounded;
    if (level > 0) return Icons.battery_1_bar_rounded;
    return Icons.battery_unknown_rounded; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitur Native OS"),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Baterai Dinamis
            Icon(
              _getBatteryIcon(_batteryLevel),
              size: 100, // Ukuran ikon proporsional
              color: _batteryLevel <= 20 ? Colors.red : const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 15),
            
            const Text(
              "Daya Baterai:",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            
            // Ukuran teks harga sudah dikecilkan
            Text(
              _batteryStatusText,
              style: const TextStyle(
                fontSize: 28, // Ukuran lebih proporsional
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Utama
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _getBatteryLevel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Update Baterai", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 10),

            // Tombol Sekunder
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showNativeToast,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueGrey,
                  side: const BorderSide(color: Colors.blueGrey),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Munculkan Toast"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}