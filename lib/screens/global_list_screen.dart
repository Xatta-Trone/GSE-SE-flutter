import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/features/lists/providers/public_lists_provider.dart';

class GlobalListScreen extends ConsumerStatefulWidget {
  const GlobalListScreen({super.key});

  @override
  ConsumerState<GlobalListScreen> createState() => _GlobalListScreenState();
}

class _GlobalListScreenState extends ConsumerState<GlobalListScreen> {
  @override
  void initState() {
    super.initState();
    Future(() => ref.read(publicListProvider.notifier).getListItems());
  }

  @override
  Widget build(BuildContext context) {
    var listItems = ref.watch(publicListProvider);

    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () => ref.read(publicListProvider.notifier).getNextPageItems(),
        child: const Text('data'),
      ),
      body: SafeArea(
          child: listItems.when(data: (List<ListModel> data) {
        // check no data
        if (data.isEmpty) {
          return const Center(
            child: Text("No data found"),
          );
        }

        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                margin: const EdgeInsets.only(bottom: 5.0, left: 10.0, right: 10.0, top: 5.0),
                child: Text(
                  data[i].name,
                ),
              );
            });
      }, error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(
            error.toString(),
          ),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      })),
    );
  }
}
