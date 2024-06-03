import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:projek/global/showmessage.dart';
import 'package:projek/services/auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class DaftarScreen extends StatefulWidget {
  const DaftarScreen({super.key});
  @override
  State<DaftarScreen> createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  // final FirebaseAuthService _auth = FirebaseAuthService();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController _namapenggunaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _kataSandiController = TextEditingController();
  final TextEditingController _konfirmasiSandiController =
      TextEditingController();

  String _errorText = '';
  bool _obscureKataSandi = true;
  bool _obscureKonfirmasi = true;
  bool isAgreed = false;
  bool isSigningUp = false;

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text.trim();
    String password = _kataSandiController.text.trim();
    String namaPengguna = _namapenggunaController.text.trim();

    String error;

    if (password.length < 8) {
      error = 'Minimal 8 karakter';
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      error = 'Mengandung kombinasi [A-Z]';
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      error = 'Mengandung kombinasi [a-z]';
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      error = 'Mengandung kombinasi [0-9]';
    } else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      error = 'Menggunakan [!@#%\$^&*(),.?":{}|<>]';
    } else {
      // Password is valid, no errors
      error = "";
    }

    if (error == null) {
      setState(() {
        _errorText = ""; // Clear error text if no errors
      });
    } else {
      setState(() {
        _errorText = error; // Display the first error
      });
    }

    if (_konfirmasiSandiController.text != _kataSandiController.text) {
      setState(() {
        _errorText = 'Kata sandi tidak sama';
      });
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        showMessage(context, "Email verifikasi telah dikirim ke ${user.email}");
        // User? user = await FirebaseAuthService()
        //     .signUpWithEmailAndPassword(context, email, password);
        // if (user != null) {
        //   showMessage(context, "Akun Pengguna berhasil di buat");
        //   String? email = user.email;
        CollectionReference usersRef =
            FirebaseFirestore.instance.collection('Users');
        DocumentReference userDocRef = usersRef.doc(email);

        Map<String, dynamic> userData = {
          'username': namaPengguna,
          'email': email,
          'image_url': "",
          'namalengkap': "",
        };

        await userDocRef.set(userData).then((_) {
          print('Berhasil menyimpan data pengguna: $userData');
          Navigator.pushNamed(context, '/masuk');
        }).catchError((error) {
          print('Gagal menyimpan data pengguna: ${error.toString()}');
        });
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Terjadi kesalahan';
      }
      showMessage(context, errorMessage);
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }

  // TODO: 2. Membuat fungsi dispose
  @override
  void dispose() {
    // TODO: Implement dispose
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
          child: Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            // color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  // color: Color(0xFF49A2F4),
                  color: Theme.of(context).iconTheme.color),
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
            child: SingleChildScrollView(
              physics: FixedExtentScrollPhysics(),
              child: Container(
                width: 337,
                height: 720,
                decoration: BoxDecoration(
                  // color: const Color(0xFFBADBFA),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(41),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 80, 8, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Pengguna',
                                  style: TextStyle(
                                    fontFamily: 'fonts/Inter-Black.ttf',
                                    color: Theme.of(context).primaryColor,
                                    // color: Color(0xFF1284EE),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _namapenggunaController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Nama Pengguna",
                                    labelStyle: TextStyle(
                                      fontFamily: 'fonts/Inter-Bold.ttf',
                                      color: Theme.of(context).primaryColor,
                                      //  color: Theme.of(context).primaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF4583DF),
                                        width: 10,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontFamily: 'fonts/Inter-Black.ttf',
                                    // color: Color(0xFF1284EE),
                                    color: Theme.of(context).primaryColor,
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
                                    labelStyle: TextStyle(
                                      fontFamily: 'fonts/Inter-Bold.ttf',
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF4583DF),
                                        width: 10,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Kata Sandi',
                                  style: TextStyle(
                                    fontFamily: 'fonts/Inter-Black.ttf',
                                    color: Theme.of(context).primaryColor,
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
                                    errorText: _errorText.isNotEmpty
                                        ? _errorText
                                        : null,
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
                                          _obscureKataSandi =
                                              !_obscureKataSandi;
                                        });
                                      },
                                      icon: Icon(_obscureKataSandi
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                  ),
                                  obscureText: _obscureKataSandi,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Konfirmasi Kata Sandi',
                                  style: TextStyle(
                                    fontFamily: 'fonts/Inter-Black.ttf',
                                    color: Theme.of(context).primaryColor,
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
                                    errorText: _errorText.isNotEmpty
                                        ? _errorText
                                        : null,
                                    labelStyle: TextStyle(
                                      fontFamily: 'fonts/Inter-Bold.ttf',
                                      color: Theme.of(context).primaryColor,
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
                                          _obscureKonfirmasi =
                                              !_obscureKonfirmasi;
                                        });
                                      },
                                      icon: Icon(_obscureKonfirmasi
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                    // fillColor: Theme.of(context).backgroundColor,
                                  ),
                                  obscureText: _obscureKonfirmasi,
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
                                    Text(
                                      'Saya setuju dengan syarat dan ketentuan',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 10),
                                  child: ElevatedButton(
                                      onPressed: _signUp,
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(100, 0, 100, 0),
                                          fixedSize: const Size(360, 60),
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'fonts/Inter-Bold.ttf',
                                          ),
                                          foregroundColor: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                          // backgroundColor: Colors.blue.shade400,
                                          backgroundColor: Theme.of(context)
                                              .floatingActionButtonTheme
                                              .backgroundColor,
                                          shape: const StadiumBorder()),
                                      child: Text(
                                        "DAFTAR",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )),
                                ),
                                Center(
                                  child: RichText(
                                      text: TextSpan(
                                          text: 'Sudah punya akun? ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          children: [
                                        TextSpan(
                                          text: 'Masuk',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            decoration:
                                                TextDecoration.underline,
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
                    ),
                  ],
                ),
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
            decoration: BoxDecoration(
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(41),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(41),
                topRight: Radius.circular(0),
              ),
            ),
            child: Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Text(
                'DAFTAR',
                style: TextStyle(
                  fontFamily: 'fonts/Inter-Black.ttf',
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
