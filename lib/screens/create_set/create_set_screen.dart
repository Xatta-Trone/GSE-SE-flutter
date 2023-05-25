import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grese/features/lists-create/providers/create_list_provider.dart';
import 'package:grese/mixins/debonce_mixin.dart';
import 'package:grese/routes/route_const.dart';

class CreateSetScreen extends ConsumerStatefulWidget {
  const CreateSetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends ConsumerState<CreateSetScreen> with DebounceMixin {
  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var listNotifier = ref.watch(createListNotifierProvider);

    listNotifier.whenOrNull(
      data: (String? data) {
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
                    content: Text(data.toString()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          Navigator.pop(context, 'OK');
                          ref.read(createListNotifierProvider.notifier).setNullData();
                          context.goNamed(dashBoardScreenKey);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                });
          });
        }
      },
      error: (Object error, _) {
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
    bool isLoading = listNotifier is AsyncLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new set'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("Import from URL ?"),
                          const Spacer(),
                          Switch(
                            value: ref.watch(createListFormStateProvider).isImport.value,
                            onChanged: (value) {
                              if (kDebugMode) {
                                print(value);
                              }
                              // empty setState to rebuild the widget tree
                              setState(() {});
                              // update the form
                              ref.read(createListNotifierProvider.notifier).toggleIsImportUrl();
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Import from quizlet.com/vocabulary.com/memrise.com \nJust paste the set/folder URL, we will do the heavy works.',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red),
                      ),
                      if (ref.watch(createListFormStateProvider).isImport.value == false) ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "My set name",
                            labelText: "Set name",
                            border: UnderlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) => handleDebounce(
                            () => ref.read(createListNotifierProvider.notifier).validateSetName(value),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              // trigger change
                              ref.read(createListNotifierProvider.notifier).validateSetName(value);
                            }
                            if (kDebugMode) {
                              print(ref.watch(createListFormStateProvider).name.errorMsg);
                            }
                            return ref.watch(createListFormStateProvider).name.errorMsg;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "banal,analogy, ambiguity",
                            labelText: "Words (at least 5 words)",
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 20,
                          minLines: 5,
                          onChanged: (value) => handleDebounce(
                            () => ref.read(createListNotifierProvider.notifier).validateWords(value),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              // trigger change
                              ref.read(createListNotifierProvider.notifier).validateWords(value);
                            }
                            if (kDebugMode) {
                              print(ref.watch(createListFormStateProvider).words.errorMsg);
                            }
                            return ref.watch(createListFormStateProvider).words.errorMsg;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                      if (ref.watch(createListFormStateProvider).isImport.value == true) ...[
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: "https://quizlet.com/saint1729/folders/gregmat/sets", labelText: "Set/Folder URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => handleDebounce(
                            () => ref.read(createListNotifierProvider.notifier).validateURL(value),
                          ),
                          onFieldSubmitted: (value) => handleDebounce(
                            () => ref.read(createListNotifierProvider.notifier).validateURL(value),
                          ),
                          validator: (value) {
                            if (kDebugMode) {
                              print('inside validator');
                              print(value);
                            }
                            if (value == null || value.isEmpty) {
                              // trigger change
                              ref.read(createListNotifierProvider.notifier).validateURL(value);
                            }
                            if (kDebugMode) {
                              print(ref.watch(createListFormStateProvider).url.errorMsg);
                            }
                            return ref.watch(createListFormStateProvider).url.errorMsg;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: "Visible to",
                            ),
                            items: const <DropdownMenuItem>[
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Everyone'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Only me'),
                              )
                            ],
                            value: ref.watch(createListFormStateProvider).visibility.value,
                            onChanged: (value) {
                              if (kDebugMode) {
                                print(value);
                              }
                              ref.read(createListNotifierProvider.notifier).setVisibility(value);
                            }),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() == true) {
                                    ref.read(createListNotifierProvider.notifier).submitForm(_formKey);
                                  }
                                  
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Submit'),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
