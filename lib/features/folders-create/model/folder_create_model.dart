// To parse this JSON data, do
//
//     final folderCreateResponse = folderCreateResponseFromJson(jsonString);

import 'dart:convert';

class FolderCreateResponse {
  FolderModel data;
  String message;

  FolderCreateResponse({
    required this.data,
    required this.message,
  });

  factory FolderCreateResponse.fromRawJson(String str) => FolderCreateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FolderCreateResponse.fromJson(Map<String, dynamic> json) => FolderCreateResponse(
        data: FolderModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
      };
}

class FolderModel {
  int id;
  int userId;
  int? listMetaId;
  String name;
  String slug;
  int visibility;
  int status;
  DateTime cratedAt;
  DateTime updatedAt;

  FolderModel({
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

  factory FolderModel.fromRawJson(String str) => FolderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FolderModel.fromJson(Map<String, dynamic> json) => FolderModel(
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
