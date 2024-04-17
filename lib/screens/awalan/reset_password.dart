import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/scheduler.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;
DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("users");

class ResetPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Reset(), routes: {
      'homepage': (context) => const MasukScreen(),
      'login': (context) => const MasukScreen(),
    });
  }
}

class Reset extends StatefulWidget {
  @override
  ResetPage createState() => ResetPage();
}

class ResetPage extends State<Reset> {
  static bool visible = false;

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
          backgroundColor: const Color(0xFFF1F8FF),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
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
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Text(
                    'Ubah Kata Sandi',
                    style: TextStyle(
                      fontFamily: 'fonts/Inter-Black.ttf',
                      color: Color(0xFF1284EE),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
                  Container(
                    padding: const EdgeInsets.only(top: 150.0, bottom: 30),
                    child: (Text(
                      ' Reset Password ',
                      style: GoogleFonts.workSans(
                        fontSize: 30,
                        color: Color(0xFF1284EE),
                      ),
                    )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(),
                    child: (Text(
                      'Please enter your email below to receive your password reset instructions',
                      style: GoogleFonts.workSans(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20, bottom: 0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          labelStyle: GoogleFonts.workSans(
                            fontSize: 16,
                            color: Colors.grey,
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
                          hintText: ''),
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
                          backgroundColor: Colors.white,
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
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
                          displaySnackBar(context, 'Enter a valid Email');
                        } else {
                          setState(() {
                            load();
                          });
                          resetPwd(context);
                        }
                      },
                      child: Text(
                        'Register',
                        style: GoogleFonts.workSans(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black45,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        backgroundColor: Colors.blue.shade400,
                        foregroundColor: Colors.white,
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
      await auth.sendPasswordResetEmail(email: _emailController.text.trim());
      displaySnackBar(context, 'Email has been sent to the given id');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const MasukScreen()));
      });
    } catch (e) {
      String errorMessage = 'An error occurred';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'An error occurred';
      }
      displaySnackBar(context, errorMessage);
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
