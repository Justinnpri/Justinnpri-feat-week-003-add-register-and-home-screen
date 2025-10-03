import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController(text: "+62"); // default +62
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isRobotChecked = false;

  // 🔹 Rules password
  bool hasMinLength(String pass) => pass.length >= 8;
  bool hasUppercase(String pass) => pass.contains(RegExp(r'[A-Z]'));
  bool hasNumber(String pass) => pass.contains(RegExp(r'[0-9]'));
  bool hasSymbol(String pass) =>
      pass.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  void register() {
    if (_formKey.currentState!.validate() && isRobotChecked) {
      setState(() => isLoading = true);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);

        // 🔹 Muncul pop-up konfirmasi verifikasi email
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Email Verifikasi Sudah Dikirim"),
            content: const Text(
                "Silakan cek email kamu untuk melakukan verifikasi akun. "
                "Jika tidak menerima pesan, cek folder spam atau kirim ulang."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      });
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔹 LOGO
              Image.asset("assets/images/logo.png", height: 80),
              const SizedBox(height: 20),

              Text(
                "Daftarkan Akun Untuk Lanjut Akses ke Luarsekolah",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Satu akun untuk akses Luarsekolah dan BelajarBekerja",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // 🔹 Tombol Google
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                label: const Text("Daftar dengan Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              const Text("atau gunakan email"),
              const SizedBox(height: 16),

              TextFormField(
                controller: nameController,
                decoration: inputStyle("Nama Lengkap"),
                validator: (val) =>
                    val!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: emailController,
                decoration: inputStyle("Email Aktif"),
                validator: (val) =>
                    val!.contains("@") ? null : "Email tidak valid",
              ),
              const SizedBox(height: 12),

              // 🔹 Nomor telepon dengan validasi +62 dan minimal 10 angka
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[+0-9]*$')),
                ],
                decoration: inputStyle("Nomor Whatsapp Aktif"),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Nomor telepon wajib diisi";
                  }
                  if (!val.startsWith("+62")) {
                    return "Nomor harus diawali dengan +62";
                  }
                  final numberOnly = val.replaceAll(RegExp(r'[^0-9]'), "");
                  if (numberOnly.length < 12) { 
                    // +62 (3 digit) + minimal 10 digit nomor = min 13 digit total
                    return "Nomor minimal 10 angka setelah +62";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                decoration: inputStyle("Password"),
                validator: (val) => hasMinLength(val ?? "")
                    ? null
                    : "Password minimal 8 karakter",
              ),
              const SizedBox(height: 12),

              // 🔹 Password rules checklist
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRule("Minimal 8 karakter",
                      hasMinLength(passwordController.text)),
                  buildRule("Terdapat 1 huruf kapital",
                      hasUppercase(passwordController.text)),
                  buildRule("Terdapat 1 angka",
                      hasNumber(passwordController.text)),
                  buildRule("Terdapat 1 karakter simbol",
                      hasSymbol(passwordController.text)),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Checkbox dummy "I'm not a robot"
              Row(
                children: [
                  Checkbox(
                    value: isRobotChecked,
                    onChanged: (val) {
                      setState(() => isRobotChecked = val!);
                    },
                  ),
                  const Text("I'm not a robot"),
                ],
              ),
              const SizedBox(height: 20),

              isLoading
                  ? ElevatedButton.icon(
                      onPressed: null,
                      icon: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      ),
                      label: const Text("Mendaftarkan Akun..."),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48)),
                    )
                  : ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Daftarkan Akun"),
                    ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Sudah punya akun? Masuk ke akunmu"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRule(String text, bool passed) {
    return Row(
      children: [
        Icon(passed ? Icons.check_circle : Icons.cancel,
            size: 16, color: passed ? Colors.green : Colors.red),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
