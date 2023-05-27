import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folders-create/model/folder_create_model.dart';
import 'package:grese/features/folders-create/repository/folder_create_respository.dart';
import 'package:grese/features/lists-create/providers/create_list_provider.dart';

// create form state with the fields
class CreateFolderFormState {
  FieldModel name;
  FieldModel visibility;

  CreateFolderFormState({
    required this.name,
    required this.visibility,
  });
}

// enums for visibility
enum FolderVisibilityEnum {
  public(1),
  private(2);

  const FolderVisibilityEnum(this.value);
  final num value;
}

// Form State Provider
final createFolderFormStateProvider = StateProvider<CreateFolderFormState>((ref) {
  return CreateFolderFormState(
    name: FieldModel(value: null),
    visibility: FieldModel(value: FolderVisibilityEnum.public.value),
  );
});

// stateNotifier for the actions
final createFolderStateNotifierProvider = StateNotifierProvider<CreateFolderStateNotifier, AsyncValue<FolderCreateResponse?>>((ref) {
  CreateFolderFormState formState = ref.watch(createFolderFormStateProvider);
  FolderCreateRepository repository = ref.watch(folderCreateRepositoryProvider);

  return CreateFolderStateNotifier(ref, formState, repository);
});

class CreateFolderStateNotifier extends StateNotifier<AsyncValue<FolderCreateResponse?>> {
  CreateFolderStateNotifier(
    this._ref,
    this.form,
    this.repository,
  ) : super(
          const AsyncData(null),
        );

  // states
  final Ref _ref;
  CreateFolderFormState form;
  FolderCreateRepository repository;

  // submit form
  Future<void> submit(GlobalKey<FormState> formKey) async {
    // debug
    if (kDebugMode) {
      print("name ${form.name.value}");
      print("visibility ${form.visibility.value}");
    }

    // map the data
    Map<String, dynamic> data = <String, dynamic>{
      "name": form.name.value,
      "visibility": form.visibility.value,
    };

    // set the state to loading
    state = const AsyncValue.loading();

    try {
      var response = await repository.createFolder(data);
      FolderCreateResponse responseModel = FolderCreateResponse.fromJson(response.data);

      if (kDebugMode) {
        print('response model');
        print(response.data);
        print(responseModel);
      }

      state = AsyncValue.data(responseModel);
      resetFormData();
    } catch (error) {
      if (error is DioError) {
        if (kDebugMode) {
          print("inside dio error");
        }
        if (error.response?.statusCode == 422) {
          var errors = error.response?.data['errors'] as Map<String, dynamic>;

          // check each key exists, if yes then add the values
          if (errors.containsKey('name')) {
            form.name.errorMsg = errors['name'];
          }

          if (errors.containsKey('visibility')) {
            form.visibility.errorMsg = errors['visibility'];
          }

          // force update the form state
          formKey.currentState?.validate();
        } else {
          if (kDebugMode) {
            print("inside normal error");
          }
          var err = error.response?.data['errors'] as String;
          var errStatusCode = error.response?.statusCode;
          state = AsyncValue.error("$errStatusCode | $err", StackTrace.current);
        }
      }
    }
  }

  // validation
  void validateFormName(String? value) {
    if (kDebugMode) {
      print(value);
    }
    form.name.value = value;
    if (value == null || value.isEmpty) {
      form.name.errorMsg = 'Please enter folder name.';
    } else {
      form.name.errorMsg = null;
    }
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
  }

  void resetFormData() {
    form.name = FieldModel(value: null);
    form.visibility = FieldModel(value: FolderVisibilityEnum.public.value);
  }
}
