import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSetScreen extends ConsumerStatefulWidget {
  const CreateSetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends ConsumerState<CreateSetScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();
  late bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
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
                            value: _switchValue,
                            onChanged: (value) {
                              setState(() {
                                _switchValue = !_switchValue;
                              });
                              if (kDebugMode) {
                                print(value);
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Import from quizlet.com/vocabulary.com/memrise.com \nJust paste the set/folder URL, we will do the heavy works.',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red),
                      ),
                      if (_switchValue == false) ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "My set name",
                            labelText: "Set name",
                            border: UnderlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter set name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "banal,analogy, ambiguity",
                            labelText: "Words (comma separated or in new line)",
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 20,
                          minLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter set name.';
                            }
                            if (kDebugMode) {
                              print(value.split("\n"));
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                      if (_switchValue) ...[
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: "https://quizlet.com/saint1729/folders/gregmat/sets", labelText: "Set/Folder URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the url.';
                            }
                            if (Uri.parse(value).isAbsolute == false) {
                              return 'Please enter a valid URL.';
                            }

                            return null;
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
                            value: 1,
                            onChanged: (value) {
                              if (kDebugMode) {
                                print(value);
                              }
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
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          },
                          child: const Text('Submit'),
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
