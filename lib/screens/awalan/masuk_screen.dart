import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projek/global/showmessage.dart';
import 'package:projek/komponen/google.dart';
import 'package:projek/screens/awalan/reset_password.dart';
import 'package:projek/screens/home/home_screen.dart';
import 'package:projek/screens/home/list_screen.dart';
import 'package:projek/services/auth_provider.dart';

class MasukScreen extends StatefulWidget {
  const MasukScreen({super.key});

  @override
  State<MasukScreen> createState() => _MasukScreenState();
}

class _MasukScreenState extends State<MasukScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _kataSandiController = TextEditingController();

  String _errorText = '';
  bool isRemembered = false;
  bool _isSignedIn = false;
  bool _obscurePassword = true;

  Future<void> authenticateWithGoogle({required BuildContext context}) async {
    try {
      await FirebaseAuthService.signInWithGoogle(context);
    } on NoGoogleAccountChosenException {
      return;
    } catch (e) {
      if (!context.mounted) return;
      showMessage(context, "Terjadinya error");
    }
  }

  void _signIn() async {
    if (_emailController.text.isEmpty || _kataSandiController.text.isEmpty) {
      setState(() {
        _errorText = 'Nama Pengguna dan Kata Sandi tidak boleh kosong';
      });
      return;
    }

    try {
      //Data masuk
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _kataSandiController.text,
      );

      User? user = userCredential.user;
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection("Users")
          .doc(user?.email)
          .get();

      if (user != null) {
        // Cek apakah pengguna telah diverifikasi melalui email
        if (user.emailVerified) {
          setState(() {
            _errorText = '';
            _isSignedIn = true;
          });

          Navigator.of(context).popUntil((route) => route.isFirst);

          if (user.email == 'jvelencia01@gmail.com') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DestinationListScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(user: user)),
            );
          }
        } else {
          // Jika pengguna belum diverifikasi
          setState(() {
            _errorText = 'Login gagal Akun belum diverifikasi';
          });
          // Keluar dari sesi masuk
          await FirebaseAuth.instance.signOut();
        }
      } else {
        setState(() {
          _errorText = 'Login gagal User tidak ditemukan';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = 'Login gagal: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorText = 'Terjadinya error: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: ClipRRect(
              child: Align(
                alignment: const AlignmentDirectional(0.00, 0.00),
                child: Container(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
              child: SingleChildScrollView(
                physics: const FixedExtentScrollPhysics(),
                child: Container(
                  width: 337,
                  height: 720,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(41),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.00, 0.00),
                        child: Form(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 150, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontFamily: 'fonts/Inter-Black.ttf',
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    labelStyle: TextStyle(
                                      fontFamily: 'fonts/Inter-Bold.ttf',
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w300,
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
                                const SizedBox(height: 10),
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
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: Icon(_obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                  ),
                                  obscureText: _obscurePassword,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                        RichText(
                                          text: TextSpan(
                                            text: 'Ingat saya',
                                            style: TextStyle(
                                              fontFamily:
                                                  'fonts/Inter-Black.ttf',
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //tambahan ke reset pass
                                    RichText(
                                      text: TextSpan(
                                        text: 'Lupa kata sandi?',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Reset(),
                                              ),
                                            );
                                          },
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
                                        backgroundColor: Theme.of(context)
                                            .floatingActionButtonTheme
                                            .backgroundColor,
                                        shape: const StadiumBorder()),
                                    child: Text(
                                      "MASUK",
                                      style: TextStyle(
                                        fontFamily: 'fonts/Inter-Black.ttf',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          'Or continue with',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tombol(
                                      imagePath: 'images/google.png',
                                      onTap: () => authenticateWithGoogle(
                                          context: context),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Tidak Punya Akun? ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Daftar',
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
                                                  context, '/daftar');
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
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
          ),
          Align(
            alignment: const AlignmentDirectional(0.99, -0.94),
            child: Container(
              width: 256,
              height: 100,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(41),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(41),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0.00, 0.00),
                child: Text(
                  'MASUK',
                  style: TextStyle(
                    fontFamily: 'fonts/Inter-Black.ttf',
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
