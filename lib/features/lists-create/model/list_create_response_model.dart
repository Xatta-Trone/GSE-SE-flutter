// To parse this JSON data, do
//
//     final listCreatedResponseModel = listCreatedResponseModelFromJson(jsonString);

import 'dart:convert';

ListCreatedResponseModel listCreatedResponseModelFromJson(String str) => ListCreatedResponseModel.fromJson(json.decode(str));

String listCreatedResponseModelToJson(ListCreatedResponseModel data) => json.encode(data.toJson());

class ListCreatedResponseModel {
  CreatedListItemModel data;
  String message;

  ListCreatedResponseModel({
    required this.data,
    required this.message,
  });

  factory ListCreatedResponseModel.fromJson(Map<String, dynamic> json) => ListCreatedResponseModel(
        data: CreatedListItemModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
      };
}

class CreatedListItemModel {
  int id;
  int userId;
  String name;
  String? url;
  String? words;
  int visibility;
  int status;
  DateTime cratedAt;
  DateTime updatedAt;

  CreatedListItemModel({
    required this.id,
    required this.userId,
    required this.name,
    this.url,
    required this.words,
    required this.visibility,
    required this.status,
    required this.cratedAt,
    required this.updatedAt,
  });

  factory CreatedListItemModel.fromJson(Map<String, dynamic> json) => CreatedListItemModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        url: json["url"],
        words: json["words"],
        visibility: json["visibility"],
        status: json["status"],
        cratedAt: DateTime.parse(json["crated_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "url": url,
        "words": words,
        "visibility": visibility,
        "status": status,
        "crated_at": cratedAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
