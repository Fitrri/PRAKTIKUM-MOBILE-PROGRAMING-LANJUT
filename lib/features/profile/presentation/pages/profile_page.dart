import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Foto Profil Lingkaran
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF4CAF50),
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            
            // Nama dan NIM
            const Text(
              "Fitri Anisa",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text(
              "NIM: 20123020",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            
            const SizedBox(height: 30),
            const Divider(thickness: 1, indent: 30, endIndent: 30),
            
            // Detail Informasi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email_outlined, color: Color(0xFF4CAF50)),
                    title: Text("Email"),
                    subtitle: Text("fitri.anisa@student.utd.ac.id"),
                  ),
                  ListTile(
                    leading: Icon(Icons.school_outlined, color: Color(0xFF4CAF50)),
                    title: Text("Program Studi"),
                    subtitle: Text("S1 Informatika"),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on_outlined, color: Color(0xFF4CAF50)),
                    title: Text("Kampus"),
                    subtitle: Text("Universitas Teknologi Digital"),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Logout atau Edit (Opsional)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Kembali"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}