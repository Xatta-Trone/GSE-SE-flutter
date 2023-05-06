import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final _googleSignIn = GoogleSignIn(
    // clientId:
    //     '930702663805-fjg34sc31u9pv6d99lqmr4aigrfaprrj.apps.googleusercontent.com',
    // serverClientId:
    //     '930702663805-fjg34sc31u9pv6d99lqmr4aigrfaprrj.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'profile',
      'openid',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future logout() => _googleSignIn.disconnect();
  static GoogleSignInAccount? currentUser() => _googleSignIn.currentUser;
}
