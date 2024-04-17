import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek/global/showmessage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword(BuildContext context,
      String email, String password) async {
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

  Future<User?> signInWithEmailAndPassword(BuildContext context,String email, String password) async {
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

 
}
