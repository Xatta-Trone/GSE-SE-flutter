// To parse this JSON data, do
//
//     final listsResponse = listsResponseFromJson(jsonString);

import 'dart:convert';

ListsResponse listsResponseFromJson(String str) => ListsResponse.fromJson(json.decode(str));

String listsResponseToJson(ListsResponse data) => json.encode(data.toJson());

class ListsResponse {
  List<ListModel> data;
  ListMetaModel meta;

  ListsResponse({
    required this.data,
    required this.meta,
  });

  factory ListsResponse.fromJson(Map<String, dynamic> json) => ListsResponse(
        data: List<ListModel>.from(json["data"].map((x) => ListModel.fromJson(x))),
        meta: ListMetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class ListModel {
  int id;
  int userId;
  int listMetaId;
  String name;
  String slug;
  int visibility;
  int status;
  DateTime cratedAt;
  DateTime updatedAt;
  ListUserModel user;
  int wordCount;

  ListModel({
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
    required this.wordCount,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
        id: json["id"],
        userId: json["user_id"],
        listMetaId: json["list_meta_id"],
        name: json["name"],
        slug: json["slug"],
        visibility: json["visibility"],
        status: json["status"],
        cratedAt: DateTime.parse(json["crated_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: ListUserModel.fromJson(json["user"]),
        wordCount: json["word_count"],
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
        "word_count": wordCount,
      };
}

class ListUserModel {
  int id;
  String username;

  ListUserModel({
    required this.id,
    required this.username,
  });

  factory ListUserModel.fromJson(Map<String, dynamic> json) => ListUserModel(
        id: json["id"],
        username: json["username"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}

class ListMetaModel {
  int id;
  String? query;
  String orderBy;
  String order;
  int page;
  int perPage;
  int count;

  ListMetaModel({
    required this.id,
    required this.query,
    required this.orderBy,
    required this.order,
    required this.page,
    required this.perPage,
    required this.count,
  });

  factory ListMetaModel.fromJson(Map<String, dynamic> json) => ListMetaModel(
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
