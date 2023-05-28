import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/features/lists/providers/public_lists_provider.dart';
import 'package:grese/mixins/debounce_mixin.dart';
import 'package:intl/intl.dart';

class GlobalListScreen extends ConsumerStatefulWidget {
  const GlobalListScreen({super.key});

  @override
  ConsumerState<GlobalListScreen> createState() => _GlobalListScreenState();
}

class _GlobalListScreenState extends ConsumerState<GlobalListScreen> {
  bool isLoaded = false;
  final scrollController = ScrollController();

  //  debounce
  Timer? _debounce;

  void handleDebounce(Function function) {
    if (_debounce != null) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // not call the search method
      if (kDebugMode) {
        function();
      }
    });
  }

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

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        if (kDebugMode) {
          print('reached end');
        }
        ref.read(publicListProvider.notifier).getNextPageItems();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: RefreshIndicator(
          onRefresh: () {
            return Future(() => ref.read(publicListProvider.notifier).getListItems());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Lists",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Barron's 333...",
                ),
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (kDebugMode) {
                      print(value);
                    }
                    handleDebounce(() => ref.read(publicListProvider.notifier).getListItems(query: value));
                  }
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: listItems.when(data: (List<ListModel> data) {
                // check no data
                if (data.isEmpty) {
                  return const Center(
                    child: Text("No data found"),
                  );
                }

                return ListView.builder(
                    controller: scrollController,
                    itemCount: data.length + 1,
                    itemBuilder: (context, i) {
                      if (i == data.length) {
                        if (ref.watch(hasMOreStateProvider) == true) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Text(
                              'End of list',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      }
                      return ListCardWidget(
                        listModel: data[i],
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
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class ListCardWidget extends StatelessWidget {
  const ListCardWidget({super.key, required this.listModel});
  final ListModel listModel;

  @override
  Widget build(BuildContext context) {
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
      margin: const EdgeInsets.only(bottom: 8.0, left: 0.0, right: 0.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.view_day_outlined,
                color: Colors.grey.shade700,
                size: 20.0,
              ),
              const Spacer(),
              Text(
                "${listModel.wordCount} terms",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
              )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            listModel.name,
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
                size: 18.0,
              ),
              const SizedBox(
                width: 2.0,
              ),
              Expanded(
                child: Text(
                  listModel.user.username,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('MMMM yyyy').format(listModel.cratedAt),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
              )
            ],
          ),
        ],
      ),
    );
  }
}
