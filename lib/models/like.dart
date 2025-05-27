// To parse this JSON data, do
//
//     final like = likeFromJson(jsonString);

import 'dart:convert';

Like likeFromJson(String str) => Like.fromJson(json.decode(str));

String likeToJson(Like data) => json.encode(data.toJson());

class Like {
  int threadId;
  Thread thread;

  Like({required this.threadId, required this.thread});

  Like copyWith({int? threadId, Thread? thread}) =>
      Like(threadId: threadId ?? this.threadId, thread: thread ?? this.thread);

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    threadId: json["thread_id"],
    thread: Thread.fromJson(json["thread"]),
  );

  Map<String, dynamic> toJson() => {
    "thread_id": threadId,
    "thread": thread.toJson(),
  };
}

class Thread {
  int id;
  int userId;
  String title;
  String content;
  DateTime createdAt;
  int likesCount;
  int commentsCount;
  User user;

  Thread({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
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
    User? user,
  }) => Thread(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    likesCount: likesCount ?? this.likesCount,
    commentsCount: commentsCount ?? this.commentsCount,
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
