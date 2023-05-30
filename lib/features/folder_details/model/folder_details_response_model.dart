// To parse this JSON data, do
//
//     final singleFolderResponseModel = singleFolderResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:grese/features/lists/model/list_response_model.dart';

class SingleFolderResponseModel {
  FolderResponseModel folder;
  List<ListModel> lists;
  FolderDetailResponseMeta meta;

  SingleFolderResponseModel({
    required this.folder,
    required this.lists,
    required this.meta,
  });

  factory SingleFolderResponseModel.fromRawJson(String str) => SingleFolderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleFolderResponseModel.fromJson(Map<String, dynamic> json) => SingleFolderResponseModel(
        folder: FolderResponseModel.fromJson(json["folder"]),
        lists: (json["lists"] as List).isNotEmpty
            ? List<ListModel>.from(json["lists"].map((x) => ListModel.fromJson(x)))
            : List<ListModel>.empty(growable: true),
        meta: FolderDetailResponseMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "folder": folder.toJson(),
        "lists": List<dynamic>.from(lists.map((x) => x!.toJson())),
        "meta": meta.toJson(),
      };
}

class FolderResponseModel {
  int id;
  int userId;
  int? listMetaId;
  String name;
  String slug;
  int visibility;
  int status;
  DateTime cratedAt;
  DateTime updatedAt;

  FolderResponseModel({
    required this.id,
    required this.userId,
    required this.listMetaId,
    required this.name,
    required this.slug,
    required this.visibility,
    required this.status,
    required this.cratedAt,
    required this.updatedAt,
  });

  factory FolderResponseModel.fromRawJson(String str) => FolderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FolderResponseModel.fromJson(Map<String, dynamic> json) => FolderResponseModel(
        id: json["id"],
        userId: json["user_id"],
        listMetaId: json["list_meta_id"],
        name: json["name"],
        slug: json["slug"],
        visibility: json["visibility"],
        status: json["status"],
        cratedAt: DateTime.parse(json["crated_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "list_meta_id": listMetaId,
        "name": name,
        "slug": slug,
        "visibility": visibility,
        "status": status,
        "crated_at": cratedAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class FolderDetailResponseMeta {
  int id;
  String query;
  String orderBy;
  int page;
  int perPage;
  int total;
  int userId;
  int folderId;

  FolderDetailResponseMeta({
    required this.id,
    required this.query,
    required this.orderBy,
    required this.page,
    required this.perPage,
    required this.total,
    required this.userId,
    required this.folderId,
  });

  factory FolderDetailResponseMeta.fromRawJson(String str) => FolderDetailResponseMeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FolderDetailResponseMeta.fromJson(Map<String, dynamic> json) => FolderDetailResponseMeta(
        id: json["id"],
        query: json["query"],
        orderBy: json["order_by"],
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        userId: json["user_id"],
        folderId: json["folder_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "query": query,
        "order_by": orderBy,
        "page": page,
        "per_page": perPage,
        "total": total,
        "user_id": userId,
        "folder_id": folderId,
      };
}
