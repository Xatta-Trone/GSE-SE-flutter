import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folders-create/model/folder_create_model.dart';
import 'package:grese/features/folders-create/providers/create_folder_provider.dart';
import 'package:grese/mixins/debounce_mixin.dart';

class CreateFolderScreen extends ConsumerStatefulWidget {
  const CreateFolderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends ConsumerState<CreateFolderScreen> with DebounceMixin {
  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var folderCreateStateNotifier = ref.watch(createFolderStateNotifierProvider);

    // handle error and success state
    folderCreateStateNotifier.whenOrNull(
      // handle success state
      data: (FolderCreateResponse? data) {
        if (kDebugMode) {
          print('data print');
          print(data);
        }
        if (data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Success'),
                    content: Text(data.message.toString()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          Navigator.pop(context, 'OK');
                          ref.read(createFolderStateNotifierProvider.notifier).setNullData();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                });
          });
        }
      },
      // handle error state
      error: (error, _) {
        if (kDebugMode) {
          print(error);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        });
      },
    );

    // loading state
    bool isLoading = folderCreateStateNotifier is AsyncLoading;

    // screen
    return Scaffold(
      appBar: AppBar(title: const Text('Create folder')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "My folder name",
                          labelText: "Folder name",
                          border: UnderlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => handleDebounce(
                          () => ref.read(createFolderStateNotifierProvider.notifier).validateFormName(value),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // trigger change
                            ref.read(createFolderStateNotifierProvider.notifier).validateFormName(value);
                          }
                          return ref.watch(createFolderFormStateProvider).name.errorMsg;
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: "Visible to",
                          ),
                          items: <DropdownMenuItem>[
                            DropdownMenuItem(
                              value: FolderVisibilityEnum.public.value,
                              child: const Text('Everyone'),
                            ),
                            DropdownMenuItem(
                              value: FolderVisibilityEnum.private.value,
                              child: const Text('Only me'),
                            )
                          ],
                          value: ref.watch(createFolderFormStateProvider).visibility.value,
                          onChanged: (value) {
                            if (kDebugMode) {
                              print(value);
                            }
                            ref.read(createFolderStateNotifierProvider.notifier).setVisibility(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() == true) {
                                    ref.read(createFolderStateNotifierProvider.notifier).submit(_formKey);
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Create folder'),
                              if (isLoading) ...[
                                const SizedBox(
                                  width: 20.0,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                  width: 15.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
