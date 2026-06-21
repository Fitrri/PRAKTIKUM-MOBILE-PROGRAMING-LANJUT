import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utd_advanced_app/features/auth/presentation/pages/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Login Form UTD Advanced App', (WidgetTester tester) async {
    // 1. Render halaman login
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // PAKSA TUNGGU 3 DETIK (Jangan pakai pumpAndSettle lagi!)
    await tester.pump(const Duration(seconds: 3));

    // 2. Ketik Email
    final emailField = find.byKey(const Key('emailFieldKey')); // Sesuaikan Key Anda
    await tester.enterText(emailField, 'admin@utd.id');
    await tester.pump(const Duration(seconds: 1)); // Tunggu 1 detik setelah mengetik

    // 3. Ketik Password
    final passwordField = find.byKey(const Key('passwordFieldKey')); // Sesuaikan Key Anda
    await tester.enterText(passwordField, 'password123');
    await tester.pump(const Duration(seconds: 1));

    // 4. Klik Tombol Login
    final loginButton = find.byKey(const Key('loginButtonKey')); // Sesuaikan Key Anda
    await tester.tap(loginButton);
    
    // Tunggu proses animasi login selesai
    await tester.pump(const Duration(seconds: 3));
  });
}