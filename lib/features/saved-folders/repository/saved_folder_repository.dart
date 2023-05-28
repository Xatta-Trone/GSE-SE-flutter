import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/saved-folders/model/saved_folder_response_model.dart';
import 'package:grese/providers/dio/dio_provider.dart';

abstract class SavedFoldersRepositoryInterface {
  Future index(SavedFolderResponseMeta meta);
}

final savedFoldersRepositoryProvider = Provider<SavedFoldersRepository>((ref) {
  Dio dio = ref.read(dioProvider);

  return SavedFoldersRepository(dio);
});

class SavedFoldersRepository implements SavedFoldersRepositoryInterface {
  SavedFoldersRepository(this.dio) : super();

  late final Dio dio;

  @override
  Future index(SavedFolderResponseMeta meta) async {
    try {
      var res = await dio.get('/folders', queryParameters: meta.toJson());
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
