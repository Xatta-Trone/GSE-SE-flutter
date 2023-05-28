// To parse this JSON data, do
//
//     final savedFoldersResponseModel = savedFoldersResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:grese/features/folders/model/folder_response_model.dart';

class SavedFoldersResponseModel {
  List<PublicFolderModel> data;
  SavedFolderResponseMeta meta;

  SavedFoldersResponseModel({
    required this.data,
    required this.meta,
  });

  factory SavedFoldersResponseModel.fromRawJson(String str) => SavedFoldersResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SavedFoldersResponseModel.fromJson(Map<String, dynamic> json) => SavedFoldersResponseModel(
        data: List<PublicFolderModel>.from(json["data"].map((x) => PublicFolderModel.fromJson(x))),
        meta: SavedFolderResponseMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class SavedFolderResponseMeta {
  int id;
  String query;
  String orderBy;
  String order;
  int page;
  int perPage;
  String filter;
  int userId;
  int count;

  SavedFolderResponseMeta({
    required this.id,
    required this.query,
    required this.orderBy,
    required this.order,
    required this.page,
    required this.perPage,
    required this.filter,
    required this.userId,
    required this.count,
  });

  factory SavedFolderResponseMeta.fromRawJson(String str) => SavedFolderResponseMeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SavedFolderResponseMeta.fromJson(Map<String, dynamic> json) => SavedFolderResponseMeta(
        id: json["id"],
        query: json["query"],
        orderBy: json["order_by"],
        order: json["order"],
        page: json["page"],
        perPage: json["per_page"],
        filter: json["filter"],
        userId: json["user_id"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "query": query,
        "order_by": orderBy,
        "order": order,
        "page": page,
        "per_page": perPage,
        "filter": filter,
        "user_id": userId,
        "count": count,
      };
}
