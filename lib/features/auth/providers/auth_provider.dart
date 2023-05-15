import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grese/features/auth/model/LoginResponse.dart';
import 'package:grese/features/auth/model/profile_response.dart';
import 'package:grese/features/auth/providers/token_provider.dart';
import 'package:grese/features/auth/repository/auth_repository.dart';
import 'package:grese/providers/dio/dio_provider.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserModel?>>((ref) {
  Dio dio = ref.read(dioProvider);
  AuthRepository authRepository = ref.read(authRepositoryProvider);
  return CurrentUserNotifier(ref, dio, authRepository);
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  CurrentUserNotifier(this.ref, this._dio, this._authRepository)
      : super(const AsyncData(null));
  late Ref ref;
  late final Dio _dio;
  late final AuthRepository _authRepository;

  static final _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  Future<void> login() async {
    state = const AsyncValue.loading();
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    var userAuth = await user?.authentication;

    // Create a new credential
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: userAuth?.accessToken,
    //   idToken: userAuth?.idToken,
    // );

    try {
      // Once signed in, return the UserCredential
      // throw Exception("custom exception");
      // state = AsyncValue.data(FirebaseAuth.instance.currentUser);
      // await FirebaseAuth.instance.signInWithCredential(credential);

      var res = await _dio.post("/login", data: {
        'token': userAuth?.idToken,
        'email': user?.email,
        'name': user?.displayName
      });
      LoginResponse loginResponse = LoginResponse.fromJson(res.data);

      state = AsyncValue.data(loginResponse.user);

      // save the data
      _authRepository.saveLoginResponse(loginResponse);
      ref.read(tokenProvider.notifier).updateToken(loginResponse.token);

      if (kDebugMode) {
        print(LoginResponse.fromJson(res.data).toJson());
        print(res.data);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      state = AsyncValue.error(err, StackTrace.current);
    }
  }

  Future me() async {
    try {
      var res = await _dio.get("/me");

      if (kDebugMode) {
        print(res.data);
        print(ProfileResponse.fromJson(res.data));
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  void initLoginData() {
    const AsyncValue.loading();
    try {
      LoginResponse? loginResponse = _authRepository.initUserData();

      if (loginResponse != null) {
        ref.read(tokenProvider.notifier).updateToken(loginResponse.token);
        state = AsyncValue.data(loginResponse.user);
      }

    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      ref.read(tokenProvider.notifier).updateToken(null);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    ref.read(tokenProvider.notifier).updateToken(null);
    _authRepository.deleteLoginResponse();
    state = const AsyncValue.data(null);
  }
}
