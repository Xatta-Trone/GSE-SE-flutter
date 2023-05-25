// To parse this JSON data, do
//
//     final listCreateError422 = listCreateError422FromJson(jsonString);

import 'dart:convert';

ListCreateError422 listCreateError422FromJson(String str) => ListCreateError422.fromJson(json.decode(str));

String listCreateError422ToJson(ListCreateError422 data) => json.encode(data.toJson());

class ListCreateError422 {
  ErrorData errors;

  ListCreateError422({
    required this.errors,
  });

  ListCreateError422 copyWith({
    ErrorData? errors,
  }) =>
      ListCreateError422(
        errors: errors ?? this.errors,
      );

  factory ListCreateError422.fromJson(Map<String, dynamic> json) => ListCreateError422(
        errors: ErrorData.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "errors": errors.toJson(),
      };
}

class ErrorData {
  String? name;
  String? url;
  String? words;

  ErrorData({
    required this.name,
    required this.url,
    required this.words,
  });

  ErrorData copyWith({
    String? name,
    String? url,
    String? words,
  }) =>
      ErrorData(
        name: name ?? this.name,
        url: url ?? this.url,
        words: words ?? this.words,
      );

  factory ErrorData.fromJson(Map<String, dynamic> json) => ErrorData(
        name: json["name"],
        url: json["url"],
        words: json["words"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "words": words,
      };
}
