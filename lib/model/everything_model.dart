// To parse this JSON data, do
//
//     final everythingModel = everythingModelFromJson(jsonString);

import 'dart:convert';

EverythingModel everythingModelFromJson(String str) =>
    EverythingModel.fromJson(json.decode(str));

String everythingModelToJson(EverythingModel data) =>
    json.encode(data.toJson());

class EverythingModel {
  String? status;
  int? totalResults;
  List<Article>? articles;

  EverythingModel({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory EverythingModel.fromJson(Map<String, dynamic> json) =>
      EverythingModel(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: json["articles"] == null
            ? []
            : List<Article>.from(
                json["articles"]!.map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles == null
            ? []
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
      };
}

class Article {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: json["source"] == null ? null : Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source?.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt?.toIso8601String(),
        "content": content,
      };
}

class Source {
  Id? id;
  Name? name;

  Source({
    this.id,
    this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: idValues.map[json["id"]] ?? Id.NOT_FOUND,
        name: nameValues.map[json["name"]] ?? Name.NOT_FOUND,
      );

  Map<String, dynamic> toJson() => {
        "id": idValues.reverse[id],
        "name": nameValues.reverse[name],
      };
}

enum Id { THE_VERGE, WIRED, NOT_FOUND }

final idValues = EnumValues(
    {"the-verge": Id.THE_VERGE, "wired": Id.WIRED, "not-found": Id.NOT_FOUND});

enum Name {
  GIZMODO_COM,
  MAC_RUMORS,
  REMOVED,
  THE_VERGE,
  WIRED,
  YAHOO_ENTERTAINMENT,
  NOT_FOUND
}

final nameValues = EnumValues({
  "Gizmodo.com": Name.GIZMODO_COM,
  "MacRumors": Name.MAC_RUMORS,
  "[Removed]": Name.REMOVED,
  "The Verge": Name.THE_VERGE,
  "Wired": Name.WIRED,
  "Yahoo Entertainment": Name.YAHOO_ENTERTAINMENT,
  "null": Name.NOT_FOUND
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
