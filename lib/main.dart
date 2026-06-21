import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/config/env_config.dart'; 
import 'package:utd_advanced_app/features/product/presentation/cubit/product_cubit.dart';

// --- BAGIAN WORKMANAGER (MODUL 9) ---
const String syncTask = "tugas_sinkronisasi_rutin";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == syncTask) {
      try {
        final prefs = await SharedPreferences.getInstance();
        String currentTime = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now());
        
        // Simpan data ke SharedPreferences
        await prefs.setString("last_sync_time", "Sync sukses pada: $currentTime");
        
        debugPrint("WorkManager: Sinkronisasi Berhasil di Latar Belakang!");
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi WorkManager (Modul 9)
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  // Inisialisasi Dependency Injection (Modul 10)
  setupLocator();
  
  runApp(const MainApp());
}

// --- BAGIAN KELAS MAINAPP (SUDAH DIKEMBALIKAN KE ROUTER ASLI) ---
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus aplikasi dengan Bloc/Cubit Provider agar State Management aktif kembali
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => locator<ProductCubit>(),
        ),
      ],
      // Mengembalikan MaterialApp menggunakan .router agar perpindahan halaman aktif
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router, // Gerbang rute utama aplikasi Anda
        theme: ThemeData(
          useMaterial3: true, 
          colorSchemeSeed: Colors.blueGrey,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
    );
  }
}