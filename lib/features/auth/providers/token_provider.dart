import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/constants/keys.dart';
import 'package:grese/providers/shared_pref_provider.dart';

// final isDarkProvider = StateNotifierProvider<TokenNotifier, String?>((ref) {
//   return TokenNotifier(ref);
// });

// class TokenNotifier extends StateNotifier<String> {
//   TokenNotifier(this.ref) : super(false);

//   final Ref ref;

//   bool isDarkModeEnabled() {
//     var sp = ref.watch(sharedPreferencesProvider);
//     return sp.getString(userTokenKey) ?? null;
//   }

//   void toggleDarkMode({required bool isDark}) {
//     var sp = ref.watch(sharedPreferencesProvider);
//     sp.setBool(darkModeKey, isDark);
//     state = isDark;
//   }
// }

final tokenProvider = StateNotifierProvider<TokenNotifier, String?>((ref) {
  return TokenNotifier(ref);
});

class TokenNotifier extends StateNotifier<String?> {
  TokenNotifier(this.ref) : super(null);

  final Ref ref;

  void updateToken(String? token) {
    state = token;
  }
}
