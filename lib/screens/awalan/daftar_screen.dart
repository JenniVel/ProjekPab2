import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek/global/toast.dart';
import 'package:projek/provider/auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class DaftarScreen extends StatefulWidget {
  const DaftarScreen({super.key});
  @override
  State<DaftarScreen> createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namapenggunaController = TextEditingController();
  final TextEditingController _kataSandiController = TextEditingController();
  final TextEditingController _konfirmasiSandiController =
      TextEditingController();

  String _errorText = '';
  bool _obscurePassword = true;
  bool isAgreed = false;
  bool isSigningUp = false;

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text.trim();
    String password = _kataSandiController.text.trim();
    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorText =
            'Minimal 8 karakter, kombinasi [A-Z], [a-z], [!@#%^&*(),.?":{}|<>]';
      });
      return;
    }

    if (_konfirmasiSandiController.text != _kataSandiController.text) {
      setState(() {
        _errorText = 'Kata sandi tidak sama';
      });
      return;
    }

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "Akun Pengguna berhasil di buat");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Terjadinya Error");
    }
  }

  void saveAdditionalUserInfo(User user) {
    String namaLengkap = _namaLengkapController.text.trim();
    String namaPengguna = _namapenggunaController.text.trim();

    // Mendapatkan UID (identifier unik) dari pengguna
    String? uid = user.uid;

    // Simpan data tambahan ke dalam database
    _database.child('users/$uid').set({
      'namaLengkap': namaLengkap,
      'namaPengguna': namaPengguna,
    }).then((_) {
      // Berhasil menyimpan data tambahan
    }).catchError((error) {
      // Gagal menyimpan data tambahan, tangani kesalahan
    });
  }

  // TODO: 2. Membuat fungsi dispose
  @override
  void dispose() {
    // TODO: Implement dispose
    _namaLengkapController.dispose();
    _emailController.dispose();
    _namapenggunaController.dispose();
    _kataSandiController.dispose();
    _konfirmasiSandiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: ClipRRect(
              child: Image.asset(
                'images/ic_latar.png',
                width: 500,
                height: 850,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF49A2F4),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          // Tempat Form
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
              child: Container(
                width: 337,
                height: 720,
                decoration: BoxDecoration(
                  color: const Color(0xFFBADBFA),
                  borderRadius: BorderRadius.circular(41),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Form(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 80, 8, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nama Lengkap',
                                style: TextStyle(
                                  fontFamily: 'fonts/Inter-Black.ttf',
                                  color: Color(0xFF1284EE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _namaLengkapController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Nama Lengkap",
                                  labelStyle: const TextStyle(
                                    fontFamily: 'fonts/Inter-Bold.ttf',
                                    color: Color(0xFF4583DF),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4583DF),
                                      width: 10,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontFamily: 'fonts/Inter-Black.ttf',
                                  color: Color(0xFF1284EE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  labelStyle: const TextStyle(
                                    fontFamily: 'fonts/Inter-Bold.ttf',
                                    color: Color(0xFF4583DF),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4583DF),
                                      width: 10,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Nama Pengguna',
                                style: TextStyle(
                                  fontFamily: 'fonts/Inter-Black.ttf',
                                  color: Color(0xFF1284EE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _namapenggunaController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Nama Pengguna",
                                  labelStyle: const TextStyle(
                                    fontFamily: 'fonts/Inter-Bold.ttf',
                                    color: Color(0xFF4583DF),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4583DF),
                                      width: 10,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Kata Sandi',
                                style: TextStyle(
                                  fontFamily: 'fonts/Inter-Black.ttf',
                                  color: Color(0xFF1284EE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _kataSandiController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Kata Sandi",
                                  errorText:
                                      _errorText.isNotEmpty ? _errorText : null,
                                  labelStyle: const TextStyle(
                                    fontFamily: 'fonts/Inter-Bold.ttf',
                                    color: Color(0xFF4583DF),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4583DF),
                                      width: 10,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                obscureText: _obscurePassword,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Konfirmasi Kata Sandi',
                                style: TextStyle(
                                  fontFamily: 'fonts/Inter-Black.ttf',
                                  color: Color(0xFF1284EE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _konfirmasiSandiController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Konfirmasi Kata Sandi",
                                  errorText:
                                      _errorText.isNotEmpty ? _errorText : null,
                                  labelStyle: const TextStyle(
                                    fontFamily: 'fonts/Inter-Bold.ttf',
                                    color: Color(0xFF4583DF),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4583DF),
                                      width: 10,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                obscureText: _obscurePassword,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isAgreed,
                                    onChanged: (value) {
                                      setState(() {
                                        isAgreed = !isAgreed;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Saya setuju dengan syarat dan ketentuan',
                                    style: TextStyle(
                                        color: Color(0xFF0360A3),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 10),
                                child: ElevatedButton(
                                  onPressed: 
                                  _signUp,
                                  style: ElevatedButton.styleFrom(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              100, 0, 100, 0),
                                      fixedSize: const Size(360, 60),
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'fonts/Inter-Bold.ttf',
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue.shade400,
                                      shape: const StadiumBorder()),
                                  child: const Text("DAFTAR"),
                                ),
                              ),
                              Center(
                                child: RichText(
                                    text: TextSpan(
                                        text: 'Sudah punya akun? ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        children: [
                                      TextSpan(
                                        text: 'Masuk',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                                context, '/masuk');
                                          },
                                      ),
                                    ])),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Bagian tag
          Align(
            alignment: const AlignmentDirectional(0.99, -0.94),
            child: Container(
              width: 256,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF49A2F4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(41),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(41),
                  topRight: Radius.circular(0),
                ),
              ),
              child: const Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Text(
                  'DAFTAR',
                  style: TextStyle(
                    fontFamily: 'fonts/Inter-Black.ttf',
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
