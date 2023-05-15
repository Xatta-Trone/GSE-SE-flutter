import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/features/lists/repository/public_lists_repository.dart';

final publicListProvider = StateNotifierProvider<PublicListNotifier, AsyncValue<List<ListModel>>>((ref) {
  PublicListsRepository listRepositoryProvider = ref.watch(PublicListsRepositoryProvider);
  ListMetaModel listMetaModel = ref.watch(listMetaStateProvider);

  return PublicListNotifier(ref, listRepositoryProvider, listMetaModel);
});

class PublicListNotifier extends StateNotifier<AsyncValue<List<ListModel>>> {
  PublicListNotifier(this._ref, this._publicListsRepository, this._listMetaModel)
      : super(AsyncData(List<ListModel>.empty(growable: true)));

  late Ref _ref;
  late final PublicListsRepository _publicListsRepository;
  late final ListMetaModel _listMetaModel;
  final List<ListModel> _items = [];

  void getListItems() {
    // set the loading
    state = const AsyncValue.loading();

    try {
      _publicListsRepository.getLists(_listMetaModel).then((ListsResponse response) {
        updateDate(response.data);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void getNextPageItems() {
    try {
      // set the next page
      _listMetaModel.page++;
      _publicListsRepository.getLists(_listMetaModel).then((ListsResponse response) {
        updateDate(response.data);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void updateDate(List<ListModel> items) {
    if (items.isEmpty) {
      state = AsyncValue.data(_items);
    } else {
      state = AsyncValue.data(_items..addAll(items));
    }
  }
}

final listMetaStateProvider = StateProvider<ListMetaModel>((ref) {
  return ListMetaModel(count: 0, id: 0, query: "", orderBy: "id", order: "asc", page: 1, perPage: 2);
});
