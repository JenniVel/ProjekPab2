import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Reset extends StatefulWidget {
  @override
  ResetPage createState() => ResetPage();
}

class ResetPage extends State<Reset> {
  static bool visible = false;

  @override
  void initState() {
    super.initState();
    visible = false;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: Container(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 25, 0, 0),
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
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
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 150.0, bottom: 30),
                    child: Text(
                      ' Ubah Kata Sandi ',
                      style: GoogleFonts.workSans(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(),
                    child: Text(
                      'Masukkan email untuk menerima link verifikasi ganti kata sandi',
                      style: GoogleFonts.workSans(
                        fontSize: 15,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20, bottom: 0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        labelStyle: GoogleFonts.workSans(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintStyle: const TextStyle(color: Colors.white54),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        labelText: 'Email',
                        hintText: '',
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: visible,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 290,
                        margin: const EdgeInsets.only(top: 10),
                        child: LinearProgressIndicator(
                          minHeight: 2,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          displaySnackBar(context, 'Masukkan email yang benar');
                        } else {
                          setState(() {
                            load();
                          });
                          resetPwd(context);
                        }
                      },
                      child: Text(
                        'Kirim Link Verifikasi',
                        style: GoogleFonts.workSans(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black45,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Theme.of(context).backgroundColor,
                            width: 2,
                          ),
                        ),
                        foregroundColor: Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor,
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPwd(BuildContext context) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_emailController.text.trim())
          .get();

      if (!userSnapshot.exists) {
        displaySnackBar(context, 'Email belum terdaftar');
        setState(() {
          load();
        });
        return;
      }

      await auth.sendPasswordResetEmail(email: _emailController.text.trim());
      displaySnackBar(context, 'Link sudah dikirim di email, cek email anda');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MasukScreen()));
      });
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Terjadi kesalahan';
      }
      displaySnackBar(context, errorMessage);
    } finally {
      setState(() {
        load();
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void load() {
    visible = !visible;
  }

  void displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.black45,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
