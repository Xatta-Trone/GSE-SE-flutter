import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/auth/providers/auth_provider.dart';
import 'package:grese/features/auth/repository/auth_repository.dart';
import 'package:grese/services/shared_pref_service.dart';

class MyListsScreen extends ConsumerWidget {
  const MyListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDark = ref.watch(isDarkProvider);
    // var currentUser = ref.watch(currentUserProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(isDark.toString()),
        ElevatedButton(
          onPressed: () {
            ref.read(isDarkProvider.notifier).toggleDarkMode(isDark: !isDark);
          },
          child: const Text('Change state'),
        ),
        // Text(currentUser?.uid ?? 'asdf'),
        ElevatedButton(
          onPressed: () async {
            // final user = await ref.read(authRepositoryProvider).login();
            await ref.read(currentUserProvider.notifier).login();

            // ref.read(currentUserProvider.notifier).update((state) => user);
          },
          child: const Text('Login'),
        ),
        ElevatedButton(
          onPressed: () async {
            // await ref.read(authRepositoryProvider).logout();
            await ref.read(currentUserProvider.notifier).logout();
            // ref.read(currentUserProvider.notifier).update((state) => null);
          },
          child: const Text('Logout'),
        )
      ],
    );
  }
}
