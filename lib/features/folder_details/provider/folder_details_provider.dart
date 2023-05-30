// meta state
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folder_details/model/folder_details_response_model.dart';
import 'package:grese/features/folder_details/repository/folder_details_repository.dart';
import 'package:grese/features/lists/model/list_response_model.dart';

final folderDetailsStateNotifierProvider = StateNotifierProvider<FolderDetailsNotifier, AsyncValue<List<ListModel>>>((ref) {
  FolderDetailsRepository repository = ref.watch(folderDetailsRepositoryProvider);
  FolderDetailResponseMeta meta = ref.watch(folderDetailsMetaStateProvider);

  return FolderDetailsNotifier(ref, repository, meta);
});

class FolderDetailsNotifier extends StateNotifier<AsyncValue<List<ListModel>>> {
  FolderDetailsNotifier(this._ref, this._repository, this._meta) : super(AsyncData(List<ListModel>.empty(growable: true)));

  late final Ref _ref;
  late final FolderDetailsRepository _repository;
  late final FolderDetailResponseMeta _meta;
  final List<ListModel> _items = [];
  String? folderId;
  FolderResponseModel? folderData;

  Future<void> getListItems({String query = '', String folderId = "0"}) async {
    // set the loading
    state = const AsyncValue.loading();
    folderId = folderId;

    try {
      // set default query value
      _meta.page = 1;
      _meta.orderBy = 'desc';
      _meta.query = query;
      _ref.read(folderDetailsMetaHasMoreStateProvider.notifier).state = true;

      var response = await _repository.index(
        folderId,
        _meta,
      );
      if (kDebugMode) {
        print('response model');
        // var d = response.data as Map<String, dynamic>;
        // print(d);
        // var m = d['lists'] as List;
        // print(m.isEmpty);
        // print('response model');
      }

      SingleFolderResponseModel responseModel = SingleFolderResponseModel.fromJson(response.data);

      if (kDebugMode) {
        print('response model');
        print(responseModel.lists);
      }

      folderData = responseModel.folder;
      clearData();
      updateData(responseModel.lists);

      // check if this is the end of list
      if (_meta.perPage >= responseModel.lists.length) {
        _ref.read(folderDetailsMetaHasMoreStateProvider.notifier).state = false;
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
      } else {
        if (kDebugMode) {
          print(error);
        }
      }
    }
  }

  Future<void> getNextPageItems() async {
    try {
      if (_ref.read(folderDetailsMetaHasMoreStateProvider.notifier).state == false) {
        return;
      }
      // set the next page
      _meta.page++;
      var response = await _repository.index(folderId ?? "0", _meta);

      SingleFolderResponseModel responseModel = SingleFolderResponseModel.fromJson(response.data);

      if (kDebugMode) {
        print('response model');
        print(response.data);
        print(responseModel);
      }

      // check if this is the end of list
      if (responseModel.lists.isEmpty) {
        _ref.read(folderDetailsMetaHasMoreStateProvider.notifier).state = false;
      } else {
        _ref.read(folderDetailsMetaHasMoreStateProvider.notifier).state = true;
        updateData(responseModel.lists);
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

final folderDetailsMetaStateProvider = StateProvider<FolderDetailResponseMeta>((ref) {
  return FolderDetailResponseMeta(
    id: 0,
    orderBy: 'desc',
    page: 1,
    perPage: 5,
    query: '',
    userId: 0,
    folderId: 0,
    total: 0,
  );
});

final folderDetailsMetaInitStateProvider = StateProvider<bool>((ref) {
  return false;
});

final folderDetailsMetaHasMoreStateProvider = StateProvider<bool>((ref) {
  return true;
});
