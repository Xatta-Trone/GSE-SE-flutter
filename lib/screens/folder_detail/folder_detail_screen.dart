import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folder_details/provider/folder_details_provider.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/screens/global_lists/global_list_screen.dart';

// ignore: must_be_immutable
class FolderDetailsScreen extends ConsumerStatefulWidget {
  String? folderId;
  FolderDetailsScreen({super.key, required this.folderId});

  @override
  ConsumerState<FolderDetailsScreen> createState() => _FolderDetailsScreenState();
}

class _FolderDetailsScreenState extends ConsumerState<FolderDetailsScreen> {
  @override
  void initState() {
    if (kDebugMode) {
      print(widget.folderId.toString());
    }

    // if (ref.read(folderDetailsMetaInitStateProvider.notifier).state == false) {
    //   if (kDebugMode) {
    //     print('init state called');
    //   }

    // }
    Future(() {
      ref.read(folderDetailsStateNotifierProvider.notifier).getListItems(folderId: widget.folderId ?? "0");
      // ref.read(folderDetailsMetaInitStateProvider.notifier).state = true;
    });
    if (kDebugMode) {
      print('init state inside');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listItems = ref.watch(folderDetailsStateNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(widget.folderId.toString()),
            Expanded(
              child: listItems.when(data: (List<ListModel> data) {
                // check no data
                if (data.isEmpty) {
                  return const Center(
                    child: Text("No data found"),
                  );
                }

                return ListView.builder(
                    // controller: scrollController,
                    itemCount: data.length + 1,
                    itemBuilder: (context, i) {
                      if (i == data.length) {
                        if (ref.watch(folderDetailsMetaHasMoreStateProvider) == true) {
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
                      // return const ListTile();
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
    );
  }
}
