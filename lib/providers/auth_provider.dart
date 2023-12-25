import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signInWithApple() async {
    bool isSuccessful = false;

    try {
      final authResult =
          await _firebaseAuth.signInWithProvider(AppleAuthProvider());
      final firebaseUser = authResult.user;
      isSuccessful = firebaseUser != null;
    } catch (e) {
      print(e);
      isSuccessful = false;
    }
    return isSuccessful;
  }

  Future<bool> signInWithGoogle() async {
    bool isSuccessful = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      isSuccessful = user != null;
    } catch (e) {
      print(e);
      isSuccessful = false;
    }
    return isSuccessful;
  }
}
