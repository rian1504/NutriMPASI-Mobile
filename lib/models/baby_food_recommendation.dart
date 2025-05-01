// To parse this JSON data, do
//
//     final babyFoodRecommendation = babyFoodRecommendationFromJson(jsonString);

import 'dart:convert';

BabyFoodRecommendation babyFoodRecommendationFromJson(String str) =>
    BabyFoodRecommendation.fromJson(json.decode(str));

String babyFoodRecommendationToJson(BabyFoodRecommendation data) =>
    json.encode(data.toJson());

class BabyFoodRecommendation {
  int id;
  int babyId;
  int foodId;
  String reason;
  Food food;

  BabyFoodRecommendation({
    required this.id,
    required this.babyId,
    required this.foodId,
    required this.reason,
    required this.food,
  });

  factory BabyFoodRecommendation.fromJson(Map<String, dynamic> json) =>
      BabyFoodRecommendation(
        id: json["id"],
        babyId: json["baby_id"],
        foodId: json["food_id"],
        reason: json["reason"],
        food: Food.fromJson(json["food"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "baby_id": babyId,
    "food_id": foodId,
    "reason": reason,
    "food": food.toJson(),
  };
}

class Food {
  int id;
  String name;
  String? source;
  String image;
  String description;

  Food({
    required this.id,
    required this.name,
    this.source,
    required this.image,
    required this.description,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    name: json["name"],
    source: json["source"] as String?,
    image: json["image"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "source": source,
    "image": image,
    "description": description,
  };
}
