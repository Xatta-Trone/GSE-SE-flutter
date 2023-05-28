import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/features/saved-lists/provider/saved_lists_provider.dart';
import 'package:grese/mixins/debounce_mixin.dart';
import 'package:grese/screens/global_lists/global_list_screen.dart';

class SavedListsScreen extends ConsumerStatefulWidget {
  const SavedListsScreen({super.key});

  @override
  ConsumerState<SavedListsScreen> createState() => _SavedListsScreenState();
}

class _SavedListsScreenState extends ConsumerState<SavedListsScreen> with DebounceMixin {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (ref.read(savedListMetaInitStateProvider.notifier).state == false) {
      if (kDebugMode) {
        print('init state called');
      }
      Future(() {
        ref.read(savedListsStateNotifierProvider.notifier).getListItems();
        ref.read(savedListMetaInitStateProvider.notifier).state = true;
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
        ref.read(savedListsStateNotifierProvider.notifier).getNextPageItems();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var listItems = ref.watch(savedListsStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () {
              return Future(() => ref.read(savedListsStateNotifierProvider.notifier).getListItems());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Search lists....",
                          ),
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (kDebugMode) {
                                print(value);
                              }
                              handleDebounce(() => ref.read(savedListsStateNotifierProvider.notifier).getListItems(query: value));
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                            icon: const Icon(Icons.filter_list),
                            alignment: AlignmentDirectional.center,
                            value: ref.watch(savedListMetaStateProvider).filter,
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                value: SavedListsFilterQueryEnum.all.value,
                                child: const Text('all'),
                              ),
                              DropdownMenuItem(
                                value: SavedListsFilterQueryEnum.created.value,
                                child: const Text('created'),
                              ),
                              DropdownMenuItem(
                                value: SavedListsFilterQueryEnum.saved.value,
                                child: const Text('saved'),
                              ),
                            ],
                            onChanged: (value) {
                              if (kDebugMode) {
                                print(value);
                              }
                              if (value != ref.watch(savedListMetaStateProvider).filter) {
                                ref.read(savedListMetaStateProvider).filter = value;
                                ref.read(savedListsStateNotifierProvider.notifier).getListItems(query: '');
                              }
                            }),
                      ),
                    ],
                  ),
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
                            if (ref.watch(savedListMetaHasMoreStateProvider) == true) {
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
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
