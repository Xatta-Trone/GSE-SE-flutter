// To parse this JSON data, do
//
//     final listCreateError = listCreateErrorFromJson(jsonString);

import 'dart:convert';

ListCreateError listCreateErrorFromJson(String str) => ListCreateError.fromJson(json.decode(str));

String listCreateErrorToJson(ListCreateError data) => json.encode(data.toJson());

class ListCreateError {
  String errors;

  ListCreateError({
    required this.errors,
  });

  ListCreateError copyWith({
    String? errors,
  }) =>
      ListCreateError(
        errors: errors ?? this.errors,
      );

  factory ListCreateError.fromJson(Map<String, dynamic> json) => ListCreateError(
        errors: json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "errors": errors,
      };
}
