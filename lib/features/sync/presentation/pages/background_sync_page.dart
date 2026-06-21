import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart'; // Sesuaikan path ke main.dart untuk ambil syncTask

class BackgroundSyncPage extends StatefulWidget {
  const BackgroundSyncPage({super.key});

  @override
  State<BackgroundSyncPage> createState() => _BackgroundSyncPageState();
}

class _BackgroundSyncPageState extends State<BackgroundSyncPage> {
  String _lastSyncInfo = "Belum ada data sync";

  @override
  void initState() {
    super.initState();
    _loadSyncStatus();
  }

  Future<void> _loadSyncStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSyncInfo = prefs.getString("last_sync_time") ?? "Belum pernah sinkronisasi";
    });
  }

  void _startPeriodicTask() {
    Workmanager().registerPeriodicTask(
      "unique_id_sync_01",
      syncTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Periodic Task Diaktifkan!")),
    );
  }

  void _startOneOffTask() {
    // Post-test: Jalan satu kali setelah delay 10 detik
    Workmanager().registerOneOffTask(
      "one_off_01",
      syncTask,
      initialDelay: const Duration(seconds: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Satu Tugas Dijadwalkan (10 detik lagi)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background Sync Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sync, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            Text(_lastSyncInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startPeriodicTask,
              child: const Text('Mulai Periodic Sync (15 Menit)'),
            ),
            ElevatedButton(
              onPressed: _startOneOffTask,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
              child: const Text('Jalankan One-Off Task (Delay 10 Detik)'),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _loadSyncStatus,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Tampilan Data'),
            )
          ],
        ),
      ),
    );
  }
}