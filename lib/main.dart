import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/GoogleSignInService.dart';
import 'package:grese/features/auth/model/LoginResponse.dart';
import 'package:grese/features/auth/providers/auth_provider.dart';
import 'package:grese/features/auth/providers/token_provider.dart';
import 'package:grese/providers/firebase_app_provider.dart';
import 'package:grese/providers/shared_pref_provider.dart';
import 'package:grese/routes/routes.dart';
import 'package:grese/screens/dashboard_screen.dart';
import 'package:grese/screens/login_screen.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseApp = await Firebase.initializeApp();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) {
    return runApp(ProviderScope(
      overrides: [
        firebaseAppProvider.overrideWithValue(firebaseApp),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(theme: theme),
    ));
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.theme});
  final ThemeData theme;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
// try to auto-login user data
  @override
  void initState() {
    super.initState();
    Future(() => ref.read(currentUserProvider.notifier).initLoginData());
  }

  @override
  Widget build(BuildContext context) {
    /// WORKS on every screen EXCEPT the screen in which appBar is used
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.orangeAccent, // You can use this as well
    //     statusBarIconBrightness:
    //         Brightness.dark, // OR Vice Versa for ThemeMode.dark
    //     statusBarBrightness:
    //         Brightness.light, // OR Vice Versa for ThemeMode.dark
    //   ),
    // );

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: widget.theme,
      routerConfig: router,
      // home: const DeciderScreen(),
    );
  }
}

class DeciderScreen extends ConsumerStatefulWidget {
  const DeciderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeciderScreenState();
}

class _DeciderScreenState extends ConsumerState<DeciderScreen> {
  @override
  void initState() {
    super.initState();
    sleep(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    var token = ref.watch(tokenProvider);
    return token == null ? const LoginScreen() : const DashBoardScreen();
  }
}
