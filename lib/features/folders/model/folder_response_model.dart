// To parse this JSON data, do
//
//     final foldersResponse = foldersResponseFromJson(jsonString);

import 'dart:convert';

PublicFoldersResponse foldersResponseFromJson(String str) => PublicFoldersResponse.fromJson(json.decode(str));

String foldersResponseToJson(PublicFoldersResponse data) => json.encode(data.toJson());

class PublicFoldersResponse {
  List<PublicFolderModel> data;
  PublicFolderResponseMetaModel meta;

  PublicFoldersResponse({
    required this.data,
    required this.meta,
  });

  factory PublicFoldersResponse.fromJson(Map<String, dynamic> json) => PublicFoldersResponse(
        data: List<PublicFolderModel>.from(json["data"].map((x) => PublicFolderModel.fromJson(x))),
        meta: PublicFolderResponseMetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class PublicFolderModel {
  int id;
  int userId;
  int listMetaId;
  String name;
  String slug;
  int visibility;
  int status;
  DateTime cratedAt;
  DateTime updatedAt;
  PublicFolderUserModel user;
  int listCount;

  PublicFolderModel({
    required this.id,
    required this.userId,
    required this.listMetaId,
    required this.name,
    required this.slug,
    required this.visibility,
    required this.status,
    required this.cratedAt,
    required this.updatedAt,
    required this.user,
    required this.listCount,
  });

  factory PublicFolderModel.fromJson(Map<String, dynamic> json) => PublicFolderModel(
        id: json["id"],
        userId: json["user_id"],
        listMetaId: json["list_meta_id"],
        name: json["name"],
        slug: json["slug"],
        visibility: json["visibility"],
        status: json["status"],
        cratedAt: DateTime.parse(json["crated_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: PublicFolderUserModel.fromJson(json["user"]),
        listCount: json["lists_count"],
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
        "user": user.toJson(),
        "lists_count": listCount,
      };
}

class PublicFolderUserModel {
  int id;
  String username;

  PublicFolderUserModel({
    required this.id,
    required this.username,
  });

  factory PublicFolderUserModel.fromJson(Map<String, dynamic> json) => PublicFolderUserModel(
        id: json["id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}

class PublicFolderResponseMetaModel {
  int id;
  String? query;
  String orderBy;
  String order;
  int page;
  int perPage;
  int count;

  PublicFolderResponseMetaModel({
    required this.id,
    required this.query,
    required this.orderBy,
    required this.order,
    required this.page,
    required this.perPage,
    required this.count,
  });

  factory PublicFolderResponseMetaModel.fromJson(Map<String, dynamic> json) => PublicFolderResponseMetaModel(
        id: json["id"],
        query: json["query"],
        orderBy: json["order_by"],
        order: json["order"],
        page: json["page"],
        perPage: json["per_page"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "query": query,
        "order_by": orderBy,
        "order": order,
        "page": page,
        "per_page": perPage,
        "count": count,
      };
}
