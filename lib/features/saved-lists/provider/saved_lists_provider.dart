// enums for visibility
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/features/saved-lists/model/saved_lists_reponse_model.dart';
import 'package:grese/features/saved-lists/repository/saved_lists_repository.dart';

enum SavedListsFilterQueryEnum {
  all("all"),
  saved("saved"),
  created("created");

  const SavedListsFilterQueryEnum(this.value);
  final dynamic value;
}

final savedListsStateNotifierProvider = StateNotifierProvider<SavedListNotifier, AsyncValue<List<ListModel>>>((ref) {
  SavedListsRepository repository = ref.watch(savedListsRepositoryProvider);
  SavedListResponseMeta meta = ref.watch(savedListMetaStateProvider);

  return SavedListNotifier(ref, repository, meta);
});

// create the change notifier state
class SavedListNotifier extends StateNotifier<AsyncValue<List<ListModel>>> {
  SavedListNotifier(this._ref, this._repository, this._meta) : super(AsyncData(List<ListModel>.empty(growable: true)));

  late final Ref _ref;
  late final SavedListsRepository _repository;
  late final SavedListResponseMeta _meta;
  final List<ListModel> _items = [];

  Future<void> getListItems({String query = ''}) async {
    // set the loading
    state = const AsyncValue.loading();

    try {
      // set default query value
      _meta.page = 1;
      _meta.order = 'desc';
      _meta.query = query;
      _ref.read(savedListMetaHasMoreStateProvider.notifier).state = true;

      var response = await _repository.index(_meta);

      SavedListsResponseModel responseModel = SavedListsResponseModel.fromJson(response.data);

      if (kDebugMode) {
        print('response model');
        print(response.data);
        print(responseModel);
      }

      clearData();
      updateData(responseModel.data);

      // check if this is the end of list
      if (responseModel.data.length < _meta.perPage) {
        _ref.read(savedListMetaHasMoreStateProvider.notifier).state = false;
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
      if (_ref.read(savedListMetaHasMoreStateProvider.notifier).state == false) {
        return;
      }
      // set the next page
      _meta.page++;
      var response = await _repository.index(_meta);

      SavedListsResponseModel responseModel = SavedListsResponseModel.fromJson(response.data);

      if (kDebugMode) {
        print('response model');
        print(response.data);
        print(responseModel);
      }

      // check if this is the end of list
      if (responseModel.data.isEmpty) {
        _ref.read(savedListMetaHasMoreStateProvider.notifier).state = false;
      } else {
        _ref.read(savedListMetaHasMoreStateProvider.notifier).state = true;
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

  void updateData(List<ListModel> items) {
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
final savedListMetaStateProvider = StateProvider<SavedListResponseMeta>((ref) {
  return SavedListResponseMeta(
    count: 0,
    id: 0,
    filter: SavedListsFilterQueryEnum.all.value,
    order: 'desc',
    orderBy: 'id',
    page: 1,
    perPage: 5,
    query: '',
    userId: 0,
  );
});

final savedListMetaInitStateProvider = StateProvider<bool>((ref) {
  return false;
});

final savedListMetaHasMoreStateProvider = StateProvider<bool>((ref) {
  return true;
});
