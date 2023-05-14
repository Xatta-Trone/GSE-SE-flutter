import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/auth/providers/auth_provider.dart';

class GlobalListScreen extends ConsumerWidget {
  const GlobalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUser = ref.watch(currentUserProvider);

    return currentUser.when(error: (Object error, StackTrace stackTrace) {
      return Center(
        child: Text(
          error.toString(),
        ),
      );
    }, data: (User? currentUser) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentUser?.displayName ?? 'Not logged in'),
          Text(currentUser?.email ?? 'email'),
          Text(currentUser?.uid ?? 'email'),
        ],
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

  }
}
