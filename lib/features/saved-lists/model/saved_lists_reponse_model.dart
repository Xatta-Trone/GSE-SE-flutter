// To parse this JSON data, do
//
//     final savedListsResponseModel = savedListsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:grese/features/lists/model/list_response_model.dart';

class SavedListsResponseModel {
  List<ListModel> data;
  SavedListResponseMeta meta;

  SavedListsResponseModel({
    required this.data,
    required this.meta,
  });

  factory SavedListsResponseModel.fromRawJson(String str) => SavedListsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SavedListsResponseModel.fromJson(Map<String, dynamic> json) => SavedListsResponseModel(
        data: List<ListModel>.from(json["data"].map((x) => ListModel.fromJson(x))),
        meta: SavedListResponseMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class SavedListResponseMeta {
  int id;
  String query;
  String orderBy;
  String order;
  int page;
  int perPage;
  int userId;
  int count;
  String filter;

  SavedListResponseMeta({
    required this.id,
    required this.query,
    required this.orderBy,
    required this.order,
    required this.page,
    required this.perPage,
    required this.userId,
    required this.count,
    required this.filter,
  });

  factory SavedListResponseMeta.fromRawJson(String str) => SavedListResponseMeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SavedListResponseMeta.fromJson(Map<String, dynamic> json) => SavedListResponseMeta(
        id: json["id"],
        query: json["query"],
        orderBy: json["order_by"],
        order: json["order"],
        page: json["page"],
        perPage: json["per_page"],
        userId: json["user_id"],
        count: json["count"],
        filter: json["filter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "query": query,
        "order_by": orderBy,
        "order": order,
        "page": page,
        "per_page": perPage,
        "user_id": userId,
        "count": count,
        "filter": filter,
      };
}
