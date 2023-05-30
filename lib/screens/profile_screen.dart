import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/auth/model/LoginResponse.dart';
import 'package:grese/features/auth/providers/auth_provider.dart';
import 'package:grese/features/auth/providers/token_provider.dart';

// final counterProvider = StateProvider((ref) => 0);

final counterProvider = StateProvider<int>((ref) {
  return 0;
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUser = ref.watch(currentUserProvider);
    var token = ref.watch(tokenProvider);

    return SafeArea(
      child: currentUser.when(error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(
            error.toString(),
          ),
        );
      }, data: (UserModel? currentUser) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.brown.shade800,
              radius: 50.0,
              backgroundImage: const NetworkImage('https://api.dicebear.com/6.x/fun-emoji/png?seed=Buddy'),
            ),
            const SizedBox(
              height: 30.0,
            ),
            if (currentUser != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentUser.username,
                    textScaleFactor: 1.3,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
              const ListTile(
                title: Text('Logout'),
                trailing: Icon(Icons.chevron_right),
                
              )
            ],

            



            if (currentUser != null) ...[
              Text(currentUser.name),
              Text(currentUser.email),
              Text(currentUser.username),
              Text(currentUser.createdAt.toIso8601String()),
              Text(token ?? 'token'),
            ],
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
            ),
            ElevatedButton(
              onPressed: () async {
                // await ref.read(authRepositoryProvider).logout();
                await ref.read(currentUserProvider.notifier).me();
                // ref.read(currentUserProvider.notifier).update((state) => null);
              },
              child: const Text('Me'),
            )
          ],
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );

  }
}
