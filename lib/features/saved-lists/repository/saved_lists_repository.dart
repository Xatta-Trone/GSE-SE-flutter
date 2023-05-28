import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/saved-lists/model/saved_lists_reponse_model.dart';
import 'package:grese/providers/dio/dio_provider.dart';

abstract class SavedListsRepositoryInterface {
  Future index(SavedListResponseMeta meta);
}

final savedListsRepositoryProvider = Provider<SavedListsRepository>((ref) {
  Dio dio = ref.read(dioProvider);

  return SavedListsRepository(dio);
});

class SavedListsRepository implements SavedListsRepositoryInterface {
  SavedListsRepository(this.dio) : super();

  late final Dio dio;

  @override
  Future index(SavedListResponseMeta meta) async {
    try {
      var res = await dio.get('/lists', queryParameters: meta.toJson());
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('error in Index');
        print(e.runtimeType);
      }
      rethrow;
    }
  }
}
