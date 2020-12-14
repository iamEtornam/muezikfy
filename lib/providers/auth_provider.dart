import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = FacebookLogin();
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  Future<bool> signInWithApple() async {
    bool isSuccessful = false;

    try {
      if (await appleSignInAvailable) {
        final AuthorizationResult appleResult =
            await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);

        if (appleResult.error != null) {
          isSuccessful = false;
        }

        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);

        switch (result.status) {
          case AuthorizationStatus.authorized:
            final appleIdCredential = result.credential;
            final oAuthProvider = OAuthProvider('apple.com');
            final credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );
            final authResult =
                await _firebaseAuth.signInWithCredential(credential);
            final firebaseUser = authResult.user;
            if (firebaseUser != null) {
              isSuccessful = true;
            } else {
              isSuccessful = false;
            }
            break;
          case AuthorizationStatus.cancelled:
            isSuccessful = false;
            break;
          case AuthorizationStatus.error:
            print(result.error.localizedDescription);
            isSuccessful = false;
            break;
        }
      } else {
        isSuccessful = false;
      }
    } catch (e) {
      print(e);
      isSuccessful = false;
    }
    return isSuccessful;
  }

  Future<bool> signInWithGoogle() async {
    bool isSuccessful = false;
    try {
      UserCredential userCredential;
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential =
          await _firebaseAuth.signInWithCredential(googleAuthCredential);

      final user = userCredential.user;
      if (user != null) {
        isSuccessful = true;
      } else {
        isSuccessful = false;
      }
    } catch (e) {
      print(e);
      isSuccessful = false;
    }
    return isSuccessful;
  }

  Future<bool> signInWithFacebook() async {
    bool isSuccessful = false;

    try {
      final res = await _facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]);

      switch (res.status) {
        case FacebookLoginStatus.Success:
          final FacebookAccessToken accessToken = res.accessToken;
          final AuthCredential credential = FacebookAuthProvider.credential(
            accessToken.token,
          );
          final User user =
              (await _firebaseAuth.signInWithCredential(credential)).user;

          if (user != null) {
            isSuccessful = true;
          } else {
            isSuccessful = false;
          }

          break;
        case FacebookLoginStatus.Cancel:
          isSuccessful = false;
          break;
        case FacebookLoginStatus.Error:
          isSuccessful = false;
          break;
      }
    } catch (e) {
      print(e);
      isSuccessful = false;
    }
    return isSuccessful;
  }
}
