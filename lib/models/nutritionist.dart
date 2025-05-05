// To parse this JSON data, do
//
//     final nutritionist = nutritionistFromJson(jsonString);

import 'dart:convert';

Nutritionist nutritionistFromJson(String str) =>
    Nutritionist.fromJson(json.decode(str));

String nutritionistToJson(Nutritionist data) => json.encode(data.toJson());

class Nutritionist {
  int id;
  String name;
  String gender;
  String image;
  String telp;
  String specialist;

  Nutritionist({
    required this.id,
    required this.name,
    required this.gender,
    required this.image,
    required this.telp,
    required this.specialist,
  });

  factory Nutritionist.fromJson(Map<String, dynamic> json) => Nutritionist(
    id: json["id"],
    name: json["name"],
    gender: json["gender"],
    image: json["image"],
    telp: json["telp"],
    specialist: json["specialist"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "gender": gender,
    "image": image,
    "telp": telp,
    "specialist": specialist,
  };
}
