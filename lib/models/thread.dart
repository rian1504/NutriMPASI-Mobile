// To parse this JSON data, do
//
//     final thread = threadFromJson(jsonString);

import 'dart:convert';

Thread threadFromJson(String str) => Thread.fromJson(json.decode(str));

String threadToJson(Thread data) => json.encode(data.toJson());

class Thread {
  int id;
  int userId;
  String title;
  String content;
  DateTime createdAt;
  int likesCount;
  int commentsCount;
  bool isLike;
  User user;

  Thread({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLike,
    required this.user,
  });

  Thread copyWith({
    int? id,
    int? userId,
    String? title,
    String? content,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isLike,
    User? user,
  }) => Thread(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    likesCount: likesCount ?? this.likesCount,
    commentsCount: commentsCount ?? this.commentsCount,
    isLike: isLike ?? this.isLike,
    user: user ?? this.user,
  );

  factory Thread.fromJson(Map<String, dynamic> json) => Thread(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    content: json["content"],
    createdAt: DateTime.parse(json["created_at"]),
    likesCount: json["likes_count"],
    commentsCount: json["comments_count"],
    isLike: json["is_like"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "content": content,
    "created_at": createdAt.toIso8601String(),
    "likes_count": likesCount,
    "comments_count": commentsCount,
    "is_like": isLike,
    "user": user.toJson(),
  };
}

class User {
  int id;
  String name;
  String? avatar;

  User({required this.id, required this.name, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"], avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "avatar": avatar};
}
