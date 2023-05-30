import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folder_details/model/folder_details_response_model.dart';
import 'package:grese/providers/dio/dio_provider.dart';

abstract class FolderDetailsRepositoryInterface {
  Future index(String folderId, FolderDetailResponseMeta meta);
}

final folderDetailsRepositoryProvider = Provider<FolderDetailsRepository>((ref) {
  Dio dio = ref.read(dioProvider);

  return FolderDetailsRepository(dio);
});

class FolderDetailsRepository implements FolderDetailsRepositoryInterface {
  FolderDetailsRepository(this.dio) : super();

  late final Dio dio;

  @override
  Future index(String folderId, FolderDetailResponseMeta meta) async {
    try {
      var res = await dio.get('/folders/$folderId', queryParameters: meta.toJson());
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
