import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists/model/list_response_model.dart';
import 'package:grese/providers/dio/dio_provider.dart';

abstract class PublicListsRepositoryInterface {
  Future<ListsResponse> getLists(ListMetaModel listMetaModel);
}

// ignore: non_constant_identifier_names
final PublicListsRepositoryProvider = Provider<PublicListsRepository>((ref) {
  Dio dio = ref.read(dioProvider);

  return PublicListsRepository(dio);
});

class PublicListsRepository implements PublicListsRepositoryInterface {
  PublicListsRepository(this.dio) : super();

  late final Dio dio;

  @override
  Future<ListsResponse> getLists(ListMetaModel listMetaModel) async {
    try {
      var res = await dio.get('/public-lists', queryParameters: listMetaModel.toJson());
      if (kDebugMode) {
        print(res.data);
      }
      ListsResponse listsResponse = ListsResponse.fromJson(res.data);
      return listsResponse;
    } catch (e) {
      rethrow;
    }
  }
}
