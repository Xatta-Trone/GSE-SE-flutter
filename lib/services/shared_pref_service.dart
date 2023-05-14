import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/constants/keys.dart';
import 'package:grese/providers/shared_pref_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provide for this class

final sharedPrefServiceProvider = StateProvider<SharePrefService>((ref) {
  final sharedPrefProvider = ref.watch(sharedPreferencesProvider);
  return SharePrefService(sharedPrefProvider);
});

final isDarkProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(ref);
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier(this.ref) : super(false);

  final Ref ref;

  bool isDarkModeEnabled() {
    var sp = ref.watch(sharedPreferencesProvider);
    return sp.getBool(darkModeKey) ?? false;
  }

  void toggleDarkMode({required bool isDark}) {
    var sp = ref.watch(sharedPreferencesProvider);
    sp.setBool(darkModeKey, isDark);
    state = isDark;
  }
}

// class implementation
class SharePrefService {
  late final SharedPreferences sharedPreferences;
  SharePrefService(this.sharedPreferences);
}
