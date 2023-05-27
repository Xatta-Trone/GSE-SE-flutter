import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grese/features/lists-create/providers/create_list_provider.dart';
import 'package:grese/mixins/debounce_mixin.dart';
import 'package:grese/routes/route_const.dart';

class ImportFromUrlScreen extends ConsumerStatefulWidget {
  const ImportFromUrlScreen({super.key});

  @override
  ConsumerState<ImportFromUrlScreen> createState() => _ImportFromUrlScreenState();
}

class _ImportFromUrlScreenState extends ConsumerState<ImportFromUrlScreen> with DebounceMixin {
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
      appBar: AppBar(title: const Text('Import words')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  textScaleFactor: 1.1,
                  text: TextSpan(
                    text: 'You can easily import vocabulary sets or folders from  ',
                    style: Theme.of(context).textTheme.bodySmall,
                    children: <TextSpan>[
                      TextSpan(text: 'quizlet.com', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                      const TextSpan(text: ', '),
                      TextSpan(text: 'vocabulary.com', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                      const TextSpan(text: ', or '),
                      TextSpan(text: 'memrise.com', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                      const TextSpan(
                          text: '. Simply copy and paste the URL of the set or folder you want to import, and we\'ll take care of the rest for you.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "https://quizlet.com/saint1729/folders/gregmat/sets",
                  labelText: "Paste URL",
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => handleDebounce(
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
                  return ref.watch(createListFormStateProvider).url.errorMsg;
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
                      value: ListVisibilityEnum.public.value,
                      child: const Text('Everyone'),
                    ),
                    DropdownMenuItem(
                      value: ListVisibilityEnum.private.value,
                      child: const Text('Only me'),
                    )
                  ],
                  value: ref.watch(createListFormStateProvider).visibility.value,
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value);
                    }
                    ref.read(createListNotifierProvider.notifier).setVisibility(value);
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
                            // set isImport to true
                            ref.read(createListFormStateProvider).isImport.value = true;
                            ref.read(createListNotifierProvider.notifier).submitForm(_formKey);
                          }
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('IMPORT WORDS'),
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
            ]),
          ),
        ),
      ),
    );
  }
}
