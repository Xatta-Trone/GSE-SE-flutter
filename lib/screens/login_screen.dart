import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/auth/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            // final user = await ref.read(authRepositoryProvider).login();
            await ref.read(currentUserProvider.notifier).login();

            // ref.read(currentUserProvider.notifier).update((state) => user);
          },
          child: const Text('Login'),
        ),
      ],
    ));
  }
}
