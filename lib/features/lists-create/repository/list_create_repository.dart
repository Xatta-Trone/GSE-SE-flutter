import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/lists-create/model/list_create_response_model.dart';
import 'package:grese/providers/dio/dio_provider.dart';

abstract class ListCreateRepositoryInterface {
  Future createList(Map<String, dynamic> listCreateData);
}

final listCreateRepositoryProvider = Provider<ListCreateRepository>((ref) {
  Dio dio = ref.read(dioProvider);

  return ListCreateRepository(dio);
});

class ListCreateRepository implements ListCreateRepositoryInterface {
  ListCreateRepository(this.dio) : super();

  late final Dio dio;

  @override
  Future createList(Map<String, dynamic> listCreateData) async {
    try {
      var res = await dio.post('/lists', data: listCreateData);
      // if (kDebugMode) {
      //   print(res.data);
      // }
      // ListCreatedResponseModel responseModel = ListCreatedResponseModel.fromJson(res.data);
      // return responseModel;
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('error in dio');
        print(e.runtimeType);
      }
      rethrow;
    }
  }
}
