// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  int id;
  String category;
  int? threadId;
  int? commentId;
  String title;
  String? content;
  bool isRead;
  DateTime createdAt;

  Notification({
    required this.id,
    required this.category,
    this.threadId,
    this.commentId,
    required this.title,
    this.content,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    category: json["category"],
    threadId: json["thread_id"],
    commentId: json["comment_id"],
    title: json["title"],
    content: json["content"],
    isRead: json["is_read"] == 1,
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "thread_id": threadId,
    "comment_id": commentId,
    "title": title,
    "content": content,
    "is_read": isRead ? 1 : 0,
    "created_at": createdAt.toIso8601String(),
  };
}
