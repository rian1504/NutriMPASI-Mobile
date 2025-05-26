// To parse this JSON data, do
//
//     final foodRecord = foodRecordFromJson(jsonString);

import 'dart:convert';

FoodRecord foodRecordFromJson(String str) =>
    FoodRecord.fromJson(json.decode(str));

String foodRecordToJson(FoodRecord data) => json.encode(data.toJson());

class FoodRecord {
  int id;
  int babyId;
  int? foodId;
  String name;
  String? source;
  String image;
  int portion;
  double energy;
  double protein;
  double fat;
  DateTime date;

  FoodRecord({
    required this.id,
    required this.babyId,
    this.foodId,
    required this.name,
    this.source,
    required this.image,
    required this.portion,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.date,
  });

  factory FoodRecord.fromJson(Map<String, dynamic> json) => FoodRecord(
    id: json["id"],
    babyId: json["baby_id"],
    foodId: json["food_id"],
    name: json["name"],
    source: json["source"],
    image: json["image"],
    portion: json["portion"],
    energy: json["energy"]?.toDouble(),
    protein: json["protein"]?.toDouble(),
    fat: json["fat"]?.toDouble(),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "baby_id": babyId,
    "food_id": foodId,
    "name": name,
    "source": source,
    "image": image,
    "portion": portion,
    "energy": energy,
    "protein": protein,
    "fat": fat,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
