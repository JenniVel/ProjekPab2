import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projek/komponen/google.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class MasukScreen extends StatefulWidget {
  const MasukScreen({super.key});

  @override
  State<MasukScreen> createState() => _MasukScreenState();
}

class _MasukScreenState extends State<MasukScreen> {
  final TextEditingController _namaPenggunaController = TextEditingController();
  final TextEditingController _kataSandiController = TextEditingController();

  String _errorText = '';
  bool isRemembered = false;
  bool _isSignedIn = false;
  bool _obscurePassword = true;

  Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs(
      SharedPreferences sharedPreferences) async {
    final encryptedUsername = sharedPreferences.getString('username') ?? '';
    final encryptedPassword = sharedPreferences.getString('password') ?? '';
    final keyString = sharedPreferences.getString('key') ?? '';
    final ivString = sharedPreferences.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    // Mengembalikan data terdekripsi
    return {'username': decryptedUsername, 'password': decryptedPassword};
  }

  void _signIn() async {
    try {
      final Future<SharedPreferences> prefsFuture =
          SharedPreferences.getInstance();

      String nama = _namaPenggunaController.text.trim();
      String password = _kataSandiController.text.trim();
      print('Sign in dilakukan');

      if (nama.isNotEmpty && password.isNotEmpty) {
        final SharedPreferences prefs = await prefsFuture;
        final data = await _retrieveAndDecryptDataFromPrefs(prefs);
        if (data.isNotEmpty) {
          final decryptedUsername = data['username'];
          final decryptedPassword = data['password'];
          if (nama == decryptedUsername && password == decryptedPassword) {
            _errorText = '';
            _isSignedIn = true;
            prefs.setBool('isSignedIn', true);
            // Pemanggilan untuk menghapus semua halaman dalam tumpukan navigasi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
            // Sign in berhasil, navigasikan ke layar utama
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
            print('Sign in berhasil');
          } else {
            print('Nama Pengguna atau Kata Sandi Salah');
          }
        } else {
          print('Tidak ditemukan data pengguna');
        }
      } else {
        print('Nama Pengguna dan Kata Sandi tidak boleh kosong');
        // Tambahkan pesan untuk kasus ketika username atau password kosong
      }
    } catch (e) {
      print('Terjadinya error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Align(
        alignment: const AlignmentDirectional(0.00, 0.00),
        child: ClipRRect(
          child: Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: Container(
                color: Colors.blue,
              ),
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
                Align(
                  alignment: AlignmentDirectional(-1.00, 0.00),
                  child: Form(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 120, 8, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Pengguna',
                            style: TextStyle(
                              fontFamily: 'fonts/Inter-Black.ttf',
                              color: Color(0xFF1284EE),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _namaPenggunaController,
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
                          const SizedBox(height: 10),
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
                          Row(
                            children: [
                              Checkbox(
                                value: _isSignedIn,
                                onChanged: (value) {
                                  setState(() {
                                    _isSignedIn = !_isSignedIn;
                                  });
                                },
                              ),
                              const Text(
                                'Ingat saya',
                                style: TextStyle(
                                  fontFamily: 'fonts/Inter-Black.ttf',
                                  color: Color(0xFF1284EE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(360, 60),
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'fonts/Inter-Bold.ttf',
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue.shade400,
                                  shape: const StadiumBorder()),
                              child: const Text("MASUK"),
                            ),
                          ),
                          
              const SizedBox(height: 30),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // google + apple sign in buttons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  // google button
                  Tombol(imagePath: 'lib/images/google.png'),
                ],
              ),

              const SizedBox(height: 50),

                          Center(
                            child: RichText(
                                text: TextSpan(
                                    text: 'Tidak Punya Akun? ',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    children: [
                                  TextSpan(
                                    text: 'Daftar',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, '/daftar');
                                      },
                                  ),
                                ])),
                          ),
                        ],
                      ),
                    ),
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
              'MASUK',
              style: TextStyle(
                fontFamily: 'fonts/Inter-Black.ttf',
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      )
    ]));
  }
}
