import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<User?> {
  CurrentUserNotifier(this.ref) : super(null);
  late Ref ref;

  static final _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  Future<void> login() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    var userAuth = await user?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: userAuth?.accessToken,
      idToken: userAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    state = FirebaseAuth.instance.currentUser;

    if (kDebugMode) {
      print(state);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    state = null;
  }
}
