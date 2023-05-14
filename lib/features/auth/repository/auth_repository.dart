import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepositoryInterface {
  Future<User?> login();
  Future<GoogleSignInAccount?> logout();
  User? currentUser();
}

class AuthRepository implements AuthRepositoryInterface {
  static final _googleSignIn = GoogleSignIn(
    // clientId:
    //     '930702663805-fjg34sc31u9pv6d99lqmr4aigrfaprrj.apps.googleusercontent.com',
    // serverClientId:
    //     '930702663805-fjg34sc31u9pv6d99lqmr4aigrfaprrj.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'profile',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  User? signedUser;

  @override
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Future<User?> login() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    var userAuth = await user?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: userAuth?.accessToken,
      idToken: userAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    signedUser = FirebaseAuth.instance.currentUser;

    if (kDebugMode) {
      print(signedUser.toString());
    }

    return signedUser;
  }

  @override
  Future<GoogleSignInAccount?> logout() {
    FirebaseAuth.instance.signOut();
    signedUser = null;
    return _googleSignIn.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
