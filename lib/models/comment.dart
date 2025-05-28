// To parse this JSON data, do
//
//     final threadDetail = threadDetailFromJson(jsonString);

import 'dart:convert';

ThreadDetail threadDetailFromJson(String str) =>
    ThreadDetail.fromJson(json.decode(str));

String threadDetailToJson(ThreadDetail data) => json.encode(data.toJson());

class ThreadDetail {
  int id;
  String title;
  String content;
  DateTime createdAt;
  int commentsCount;
  int likesCount;
  bool isLike;
  User user;
  List<Comment> comments;

  ThreadDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.commentsCount,
    required this.likesCount,
    required this.isLike,
    required this.user,
    required this.comments,
  });

  ThreadDetail copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    int? commentsCount,
    int? likesCount,
    bool? isLike,
    User? user,
    List<Comment>? comments,
  }) => ThreadDetail(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    commentsCount: commentsCount ?? this.commentsCount,
    likesCount: likesCount ?? this.likesCount,
    isLike: isLike ?? this.isLike,
    user: user ?? this.user,
    comments: comments ?? this.comments,
  );

  factory ThreadDetail.fromJson(Map<String, dynamic> json) => ThreadDetail(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    createdAt: DateTime.parse(json["created_at"]),
    commentsCount: json["comments_count"],
    likesCount: json["likes_count"],
    isLike: json["is_like"],
    user: User.fromJson(json["user"]),
    comments: List<Comment>.from(
      json["comments"].map((x) => Comment.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "created_at": createdAt.toIso8601String(),
    "comments_count": commentsCount,
    "likes_count": likesCount,
    "is_like": isLike,
    "user": user.toJson(),
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}

class Comment {
  int id;
  int threadId;
  int userId;
  String content;
  DateTime createdAt;
  User user;

  Comment({
    required this.id,
    required this.threadId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  Comment copyWith({
    int? id,
    int? threadId,
    int? userId,
    String? content,
    DateTime? createdAt,
    User? user,
  }) => Comment(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    userId: userId ?? this.userId,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    user: user ?? this.user,
  );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    threadId: json["thread_id"],
    userId: json["user_id"],
    content: json["content"],
    createdAt: DateTime.parse(json["created_at"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thread_id": threadId,
    "user_id": userId,
    "content": content,
    "created_at": createdAt.toIso8601String(),
    "user": user.toJson(),
  };
}

class User {
  int id;
  String name;
  String? avatar;

  User({required this.id, required this.name, required this.avatar});

  User copyWith({int? id, String? name, String? avatar}) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
  );

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"], avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "avatar": avatar};
}
