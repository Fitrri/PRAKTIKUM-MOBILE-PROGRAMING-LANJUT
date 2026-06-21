import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/pages/crypto_page.dart';
import '../../features/todo/presentation/pages/todo_page.dart';
import '../../features/native/presentation/pages/native_page.dart';
// 1. TAMBAHKAN IMPORT PROFILE DISINI
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/sync/presentation/pages/background_sync_page.dart';
import '../../features/sync/presentation/pages/background_sync_page.dart'; // Import filenya
import '../../features/animation/presentation/pages/animation_page.dart'; // [cite: 224]
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // MODUL 4 & DETAIL
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductPage(),
        routes: [
          GoRoute(
            path: 'detail/:id',
            builder: (context, state) => DetailPage(productId: state.pathParameters['id']!),
          ),
        ],
      ),

      // 2. TAMBAHKAN RUTE PROFILE DISINI
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // MODUL 5: CRYPTO
      GoRoute(
        path: '/crypto',
        builder: (context, state) => const CryptoPage(),
      ),

      // MODUL 6: TODO (ISAR)
      GoRoute(
        path: '/todo',
        builder: (context, state) => const TodoPage(),
      ),

      // MODUL 7: NATIVE (BATTERY)
      GoRoute(
        path: '/native',
        builder: (context, state) => const NativePage(),
      ),
      GoRoute(
      path: '/sync',
      builder: (context, state) => const BackgroundSyncPage(),
    ),
    GoRoute(
      path: '/sync',
      builder: (context, state) => const BackgroundSyncPage(),
    ),
    GoRoute(
  path: '/animation', // [cite: 228]
  builder: (context, state) => const AnimationPage(), // [cite: 229]
),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text("Halaman tidak ditemukan!")),
    ),
  );
}