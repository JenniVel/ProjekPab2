import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek/global/showmessage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projek/screens/awalan/daftar_screen.dart';
import 'package:projek/screens/home/home_screen.dart';
import 'package:projek/screens/home/home_screen.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showMessage(context, "Email telah digunakan");
      } else {
        showMessage(context, "Terjadi kesalahan: ${e.message}");
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showMessage(context, 'Password atau email salah');
      } else {
        showMessage(context, 'Terjadi kesalahan: ${e.code}');
      }
    }
    return null;
  }

   static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw const NoGoogleAccountChosenException();
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

       Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(user: userCredential.user!),//NewScreen(user: userCredential.user),
        ),
      );
    } catch (e) {
      // Handle error
      print("Gagal Sign in dengan goggle: $e");
      // You can show a snackbar or dialog to inform the user about the failure
    }
  }

}
class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}
