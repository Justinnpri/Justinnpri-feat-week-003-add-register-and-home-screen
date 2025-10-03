import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // 🔹 LOGO (ganti sesuai kebutuhan)
              Image.asset("assets/images/logo.png", height: 80),
              SizedBox(height: 20),

              Text("Masuk ke Akunmu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email Aktif"),
              ),
              SizedBox(height: 12),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48)),
                child: Text("Masuk"),
              ),
              SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text("Belum punya akun? Daftar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
