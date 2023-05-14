import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/auth/model/LoginResponse.dart';
import 'package:grese/features/auth/providers/auth_provider.dart';
import 'package:grese/features/auth/providers/token_provider.dart';

class GlobalListScreen extends ConsumerWidget {
  const GlobalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUser = ref.watch(currentUserProvider);
    var token = ref.watch(tokenProvider);

    return currentUser.when(error: (Object error, StackTrace stackTrace) {
      return Center(
        child: Text(
          error.toString(),
        ),
      );
    }, data: (UserModel? currentUser) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentUser?.name ?? 'Not logged in'),
          Text(currentUser?.email ?? 'email'),
          Text(currentUser?.username ?? 'email'),
          Text(currentUser?.createdAt.toIso8601String() ?? 'email'),
          Text(token ?? 'token'),
        ],
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

  }
}
