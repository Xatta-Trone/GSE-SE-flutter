import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folders/model/folder_response_model.dart';
import 'package:grese/features/folders/repository/public_folder_repository.dart';
import 'package:grese/features/lists/model/list_response_model.dart';

final publicFolderProvider = StateNotifierProvider<PublicFolderNotifier, AsyncValue<List<PublicFolderModel>>>((ref) {
  PublicFoldersRepository publicFolderRepositoryProvider = ref.watch(publicFoldersRepositoryProvider);
  PublicFolderResponseMetaModel publicFolderMetaModel = ref.watch(publicFolderMetaStateProvider);

  return PublicFolderNotifier(ref, publicFolderRepositoryProvider, publicFolderMetaModel);
});

class PublicFolderNotifier extends StateNotifier<AsyncValue<List<PublicFolderModel>>> {
  PublicFolderNotifier(this._ref, this._publicFolderRepository, this._publicFolderMetaModel)
      : super(AsyncData(List<PublicFolderModel>.empty(growable: true)));

  late final Ref _ref;
  late final PublicFoldersRepository _publicFolderRepository;
  late final PublicFolderResponseMetaModel _publicFolderMetaModel;
  final List<PublicFolderModel> _items = [];

  void getListItems({String query = ''}) {
    // set the loading
    state = const AsyncValue.loading();

    try {
      // set default query value
      _publicFolderMetaModel.page = 1;
      _publicFolderMetaModel.order = 'asc';
      _publicFolderMetaModel.query = query;
      _ref.read(publicFoldersHasMoreStateProvider.notifier).state = true;
      _publicFolderRepository.getLists(_publicFolderMetaModel).then((PublicFoldersResponse response) {
        clearData();
        updateData(response.data);
        // check if this is the end of list
        if (response.data.length < _publicFolderMetaModel.perPage) {
          _ref.read(publicFoldersHasMoreStateProvider.notifier).state = false;
        }
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void getNextPageItems() {
    try {
      if (_ref.read(publicFoldersHasMoreStateProvider.notifier).state == false) {
        return;
      }
      // set the next page
      _publicFolderMetaModel.page++;
      _publicFolderRepository.getLists(_publicFolderMetaModel).then((PublicFoldersResponse response) {
        if (response.data.isEmpty) {
          _ref.read(publicFoldersHasMoreStateProvider.notifier).state = false;
        } else {
          _ref.read(publicFoldersHasMoreStateProvider.notifier).state = true;
          updateData(response.data);
        }
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
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

final publicFolderMetaStateProvider = StateProvider<PublicFolderResponseMetaModel>((ref) {
  return PublicFolderResponseMetaModel(count: 0, id: 0, query: "", orderBy: "id", order: "asc", page: 1, perPage: 5);
});

final publicFolderInitStateProvider = StateProvider<bool>((ref) {
  return false;
});

final publicFoldersHasMoreStateProvider = StateProvider<bool>((ref) {
  return true;
});
