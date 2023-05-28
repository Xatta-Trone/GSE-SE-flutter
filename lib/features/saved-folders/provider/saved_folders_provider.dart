import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folders/model/folder_response_model.dart';
import 'package:grese/features/saved-folders/model/saved_folder_response_model.dart';
import 'package:grese/features/saved-folders/repository/saved_folder_repository.dart';

enum SavedFoldersFilterQueryEnum {
  all("all"),
  saved("saved"),
  created("created");

  const SavedFoldersFilterQueryEnum(this.value);
  final String value;
}

final savedFoldersStateNotifierProvider = StateNotifierProvider<SavedFolderNotifier, AsyncValue<List<PublicFolderModel>>>((ref) {
  SavedFoldersRepository repository = ref.watch(savedFoldersRepositoryProvider);
  SavedFolderResponseMeta meta = ref.watch(savedFolderMetaStateProvider);

  return SavedFolderNotifier(ref, repository, meta);
});

// create the change notifier state
class SavedFolderNotifier extends StateNotifier<AsyncValue<List<PublicFolderModel>>> {
  SavedFolderNotifier(this._ref, this._repository, this._meta) : super(AsyncData(List<PublicFolderModel>.empty(growable: true)));

  late final Ref _ref;
  late final SavedFoldersRepository _repository;
  late final SavedFolderResponseMeta _meta;
  final List<PublicFolderModel> _items = [];

  Future<void> getListItems({String query = ''}) async {
    // set the loading
    state = const AsyncValue.loading();

    try {
      // set default query value
      _meta.page = 1;
      _meta.order = 'desc';
      _meta.query = query;
      _ref.read(savedFolderMetaHasMoreStateProvider.notifier).state = true;

      var response = await _repository.index(_meta);

      SavedFoldersResponseModel responseModel = SavedFoldersResponseModel.fromJson(response.data);

      if (kDebugMode) {
        print('response model');
        print(response.data);
        print(responseModel.toJson());
      }

      clearData();
      updateData(responseModel.data);

      // check if this is the end of list
      if (_meta.perPage >= responseModel.data.length) {
        _ref.read(savedFolderMetaHasMoreStateProvider.notifier).state = false;
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);

      if (error is DioError) {
        if (kDebugMode) {
          print("inside dio error");
        }
        var err = error.response?.data['errors'] as String;
        var errStatusCode = error.response?.statusCode;
        state = AsyncValue.error("$errStatusCode | $err", StackTrace.current);
      }
    }
  }

  Future<void> getNextPageItems() async {
    try {
      if (_ref.read(savedFolderMetaHasMoreStateProvider.notifier).state == false) {
        return;
      }
      // set the next page
      _meta.page++;
      var response = await _repository.index(_meta);

      SavedFoldersResponseModel responseModel = SavedFoldersResponseModel.fromJson(response.data);

      if (kDebugMode) {
        print('response model');
        print(response.data);
        print(responseModel);
      }

      // check if this is the end of list
      if (responseModel.data.isEmpty) {
        _ref.read(savedFolderMetaHasMoreStateProvider.notifier).state = false;
      } else {
        _ref.read(savedFolderMetaHasMoreStateProvider.notifier).state = true;
        updateData(responseModel.data);
      }
    } catch (error) {
      if (error is DioError) {
        if (kDebugMode) {
          print("inside dio error");
        }
        var err = error.response?.data['errors'] as String;
        var errStatusCode = error.response?.statusCode;
        state = AsyncValue.error("$errStatusCode | $err", StackTrace.current);
      }
    }
  }

  void updateData(List<PublicFolderModel> items) {
    if (items.isEmpty) {
      state = AsyncValue.data(_items);
    } else {
      state = AsyncValue.data(_items..addAll(items));
    }
  }

  void clearData() {
    _items.clear();
    state = AsyncValue.data(_items);
  }
}

// meta state
final savedFolderMetaStateProvider = StateProvider<SavedFolderResponseMeta>((ref) {
  return SavedFolderResponseMeta(
    count: 0,
    id: 0,
    filter: SavedFoldersFilterQueryEnum.all.value,
    order: 'desc',
    orderBy: 'id',
    page: 1,
    perPage: 5,
    query: '',
    userId: 0,
  );
});

final savedFolderMetaInitStateProvider = StateProvider<bool>((ref) {
  return false;
});

final savedFolderMetaHasMoreStateProvider = StateProvider<bool>((ref) {
  return true;
});
