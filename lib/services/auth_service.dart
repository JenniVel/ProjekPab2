import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  signInWithGoogle() async{
    final GoogleSignInAccount? akunGoogle = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication authGoogle = await akunGoogle!.authentication;
    final Credential = GoogleAuthProvider.credential(
      accessToken: authGoogle.accessToken,
      idToken: authGoogle.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(Credential);
  }
}