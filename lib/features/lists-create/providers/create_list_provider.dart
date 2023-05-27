import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists-create/model/list_create_response_model.dart';
import 'package:grese/features/lists-create/repository/list_create_repository.dart';

class FieldModel {
  dynamic value;
  String? errorMsg;
  FieldModel({required this.value});
}

// enums for visibility
enum ListVisibilityEnum {
  public(1),
  private(2);

  const ListVisibilityEnum(this.value);
  final int value;
}

// form state
class CreateListFormState {
  FieldModel name;
  FieldModel words;
  FieldModel url;
  FieldModel visibility;
  FieldModel isImport;

  CreateListFormState({
    required this.name,
    required this.words,
    required this.url,
    required this.visibility,
    required this.isImport,
  });

  factory CreateListFormState.emptyModel() => CreateListFormState(
        name: FieldModel(value: null),
        words: FieldModel(value: null),
        url: FieldModel(value: null),
        visibility: FieldModel(value: ListVisibilityEnum.public.value),
        isImport: FieldModel(value: false),
      );
}

final createListFormStateProvider = StateProvider<CreateListFormState>((ref) {
  return CreateListFormState(
    name: FieldModel(value: null),
    words: FieldModel(value: null),
    url: FieldModel(value: null),
    visibility: FieldModel(value: ListVisibilityEnum.public.value),
    isImport: FieldModel(value: false),
  );
});

final createListNotifierProvider = StateNotifierProvider<CreateListNotifier, AsyncValue<String?>>((ref) {
  CreateListFormState listCreateForm = ref.watch(createListFormStateProvider);
  ListCreateRepository listCreateRepository = ref.watch(listCreateRepositoryProvider);
  return CreateListNotifier(ref, listCreateForm, listCreateRepository);
});

class CreateListNotifier extends StateNotifier<AsyncValue<String?>> {
  CreateListNotifier(this._ref, this.form, this.listsRepository) : super(const AsyncData(null));
  CreateListFormState form;
  late final Ref _ref;
  late final ListCreateRepository listsRepository;
  // submit form

  Future<void> submitForm(GlobalKey<FormState> formKey) async {
    if (kDebugMode) {
      print("name ${form.name.value}");
      print("words ${form.words.value}");
      print("url ${form.url.value}");
      print("visibility ${form.visibility.value}");
      print("isImport ${form.isImport.value}");
    }
    // map data
    Map<String, dynamic> data = <String, dynamic>{
      "name": form.name.value,
      "visibility": form.visibility.value,
      "scope": "user",
    };

    if (form.isImport.value == true) {
      data.addAll(<String, dynamic>{
        "url": form.url.value,
        "name": "Import from url",
      });
    } else {
      data.addAll(<String, dynamic>{
        "words": form.words.value,
      });
    }

    if (kDebugMode) {
      // print(data.toString());
    }

    // set loading state
    state = const AsyncValue.data(null);
    state = const AsyncValue.loading();
    // state = const AsyncValue.data('Data');

    try {
      var res = await listsRepository.createList(data);

      var responseModel = ListCreatedResponseModel.fromJson(res.data);
      if (kDebugMode) {
        print('response model');
        print(res.data);
        print(responseModel);
      }
      state = AsyncValue.data(responseModel.message);
      resetFormData();
      if (kDebugMode) {
        print(res);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      if (error is DioError) {
        if (error.response?.statusCode == 422) {
          state = const AsyncValue.data(null);
          var errors = error.response?.data['errors'] as Map<String, dynamic>;

          // check each key exists, if yes then add the values
          if (errors.containsKey('url')) {
            form.url.errorMsg = errors['url'];
          }

          if (errors.containsKey('name')) {
            form.name.errorMsg = errors['name'];
          }

          if (errors.containsKey('words')) {
            form.words.errorMsg = errors['words'];
          }

          formKey.currentState?.validate();
          if (kDebugMode) {
            print("dio error");
            print(error.response?.data);
          }
        } else {
          if (kDebugMode) {
            print("inside normal error");
          }
          var err = error.response?.data['errors'] as String;
          state = AsyncValue.error(err, StackTrace.empty);
        }
      }
    }
  }

// validation
  void validateSetName(String? value) {
    if (kDebugMode) {
      print(value);
    }
    form.name.value = value;
    if (value == null || value.isEmpty) {
      form.name.errorMsg = 'Please enter set name.';
    } else {
      form.name.errorMsg = null;
    }
  }

  void validateURL(String? value) {
    if (kDebugMode) {
      print('validate url');
      print(value);
    }
    if (value == null || value.isEmpty) {
      form.url.errorMsg = 'Please enter the url.';
      return;
    }
    if (Uri.parse(value).isAbsolute == false) {
      form.url.errorMsg = 'Please enter a valid URL.';
    } else {
      form.url.errorMsg = null;
    }
    form.url.value = value;
  }

  void validateWords(String? value) {
    form.words.errorMsg = null;
    if (kDebugMode) {
      print("inside validateWords");
      print(value);
    }

    if (value == null || value.isEmpty) {
      form.words.errorMsg = 'Please enter at least 5 words.';
      return;
    }

    // count total words
    int total = 0;
    var splitByComma = value.split(",");
    for (var element in splitByComma) {
      for (var el in element.split("\n")) {
        total += el.trim().isNotEmpty ? 1 : 0;
      }
    }

    if (total < 5) {
      form.words.errorMsg = 'Please enter at least 5 words.';
      return;
    }

    // if comes here then set as null
    form.words.errorMsg = null;
    form.words.value = value;
  }

  void toggleIsImportUrl() {
    if (kDebugMode) {
      print(form.isImport.value);
    }
    form.isImport.value = !form.isImport.value;
  }

  void setVisibility(int value) {
    if (kDebugMode) {
      print("setVisibility");
      print(value);
    }
    form.visibility.value = value;
  }

  void setNullData() {
    state = const AsyncValue.data(null);
    // form = CreateListFormState.emptyModel();
  }

  void resetFormData() {
    form.name = FieldModel(value: null);
    form.words = FieldModel(value: null);
    form.url = FieldModel(value: null);
    form.visibility = FieldModel(value: ListVisibilityEnum.public.value);
    form.isImport = FieldModel(value: false);
    // form = CreateListFormState.emptyModel();
  }
}
