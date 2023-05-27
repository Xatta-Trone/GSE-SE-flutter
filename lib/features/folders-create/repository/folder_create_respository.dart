import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/providers/dio/dio_provider.dart';

abstract class FolderCreateRepositoryInterface {
  Future createFolder(Map<String, dynamic> listCreateData);
}

final folderCreateRepositoryProvider = Provider<FolderCreateRepository>((ref) {
  Dio dio = ref.read(dioProvider);

  return FolderCreateRepository(dio);
});

class FolderCreateRepository implements FolderCreateRepositoryInterface {
  FolderCreateRepository(this.dio) : super();

  late final Dio dio;

  @override
  Future createFolder(Map<String, dynamic> listCreateData) async {
    try {
      var res = await dio.post('/folders', data: listCreateData);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('error in createFolder');
        print(e.runtimeType);
      }
      rethrow;
    }
  }
}
