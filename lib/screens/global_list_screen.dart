import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/features/lists/providers/public_lists_provider.dart';
import 'package:intl/intl.dart';

class GlobalListScreen extends ConsumerStatefulWidget {
  const GlobalListScreen({super.key});

  @override
  ConsumerState<GlobalListScreen> createState() => _GlobalListScreenState();
}

class _GlobalListScreenState extends ConsumerState<GlobalListScreen> {
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    if (ref.read(initStateProvider.notifier).state == false) {
      if (kDebugMode) {
        print('init state called');
      }
      Future(() {
        ref.read(publicListProvider.notifier).getListItems();
        ref.read(initStateProvider.notifier).state = true;
      });
    }
    if (kDebugMode) {
      print('init state inside');
    }
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

        return RefreshIndicator(
          onRefresh: () {
            return Future(() => ref.read(publicListProvider.notifier).getListItems());
          },
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 0.1,
                          blurRadius: 1,
                          offset: const Offset(0, 0.9),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(3.0),
                      ),
                      color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  margin: const EdgeInsets.only(bottom: 8.0, left: 5.0, right: 5.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.view_day_outlined,
                            color: Colors.grey.shade700,
                          ),
                          const Spacer(),
                          Text(
                            "${data[i].wordCount} terms",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "${data[i].name} asdf ${data[i].name} very long text",
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(
                            width: 2.0,
                          ),
                          Expanded(
                            child: Text(
                              "${data[i].user.username} asdf very long user name asdf asdf asdf",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('MMMM yyyy').format(data[i].cratedAt),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }),
        );
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
