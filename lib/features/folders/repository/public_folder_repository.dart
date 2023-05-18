import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/folders/model/folder_response_model.dart';
import 'package:grese/providers/dio/dio_provider.dart';

abstract class PublicListsRepositoryInterface {
  Future<PublicFoldersResponse> getLists(PublicFolderResponseMetaModel metaModel);
}

// ignore: non_constant_identifier_names
final publicFoldersRepositoryProvider = Provider<PublicFoldersRepository>((ref) {
  Dio dio = ref.read(dioProvider);

  return PublicFoldersRepository(dio);
});

class PublicFoldersRepository implements PublicListsRepositoryInterface {
  PublicFoldersRepository(this.dio) : super();

  late final Dio dio;

  @override
  Future<PublicFoldersResponse> getLists(PublicFolderResponseMetaModel metaModel) async {
    try {
      var res = await dio.get('/public-folders', queryParameters: metaModel.toJson());
      if (kDebugMode) {
        print(res.data);
      }
      PublicFoldersResponse listsResponse = PublicFoldersResponse.fromJson(res.data);
      return listsResponse;
    } catch (e) {
      rethrow;
    }
  }
}
