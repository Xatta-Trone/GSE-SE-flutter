import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final counterProvider = StateProvider((ref) => 0);

final counterProvider = StateProvider<int>((ref) {
  return 0;
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('data'),
        Consumer(builder: (context, ref, _) {
          var data = ref.watch(counterProvider);

          return Text(data.toString());
        }),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: const Text('increment'),
        )
      ],
    ));
  }
}
