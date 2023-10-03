import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInViewModel extends ChangeNotifier {

  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(
    hostedDomain: hostedDomain,
    scopes: [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/drive.readonly",
    ],
  );

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future<void> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception(errorUserNotFound);
      }

      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('accessToken', googleAuth.accessToken!);

      if (googleUser.email.endsWith('@$hostedDomain')) {
        await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw Exception(errorSignInRestricted);
      }
    } catch (e) {
      debugPrint('$errorSigningIn $e');
    }

    notifyListeners();
  }

  Future<GoogleSignInAccount?> signInSilently() {
    return _googleSignIn.signInSilently();
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    notifyListeners();
  }
}
