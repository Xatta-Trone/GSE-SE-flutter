import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folders/model/folder_response_model.dart';
import 'package:grese/features/folders/providers/public_folders_provider.dart';
import 'package:intl/intl.dart';

class GlobalFolderScreen extends ConsumerStatefulWidget {
  const GlobalFolderScreen({super.key});

  @override
  ConsumerState<GlobalFolderScreen> createState() => _GlobalFolderScreenState();
}

class _GlobalFolderScreenState extends ConsumerState<GlobalFolderScreen> {
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
    if (ref.read(publicFolderInitStateProvider.notifier).state == false) {
      if (kDebugMode) {
        print('init state called');
      }
      Future(() {
        ref.read(publicFolderProvider.notifier).getListItems();
        ref.read(publicFolderInitStateProvider.notifier).state = true;
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
        ref.read(publicFolderProvider.notifier).getNextPageItems();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var listItems = ref.watch(publicFolderProvider);

    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () => ref.read(publicFolderProvider.notifier).getNextPageItems(),
        child: const Text('data'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: RefreshIndicator(
          onRefresh: () {
            return Future(() => ref.read(publicFolderProvider.notifier).getListItems());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Folders",
                  style: Theme.of(context).textTheme.titleLarge,
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
                    handleDebounce(() => ref.read(publicFolderProvider.notifier).getListItems(query: value));
                  }
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: listItems.when(data: (List<PublicFolderModel> data) {
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
                        if (ref.watch(publicFoldersHasMoreStateProvider) == true) {
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
                      return ListFolderWidget(
                        model: data[i],
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
            ],
          ),
        ),
      )),
    );
  }
}

class ListFolderWidget extends StatelessWidget {
  const ListFolderWidget({super.key, required this.model});
  final PublicFolderModel model;

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
                Icons.folder_outlined,
                color: Colors.grey.shade700,
                size: 20.0,
              ),
              const Spacer(),
              Text(
                "${model.listCount} lists",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
              )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            "${model.name} asdf ${model.name} very long text",
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
                  "${model.user.username} asdf very long user name asdf asdf asdf",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('MMMM yyyy').format(model.cratedAt),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
              )
            ],
          ),
        ],
      ),
    );
  }
}
