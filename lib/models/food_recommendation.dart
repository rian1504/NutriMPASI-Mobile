// To parse this JSON data, do
//
//     final foodRecommendation = foodRecommendationFromJson(jsonString);

import 'dart:convert';

FoodRecommendation foodRecommendationFromJson(String str) =>
    FoodRecommendation.fromJson(json.decode(str));

String foodRecommendationToJson(FoodRecommendation data) =>
    json.encode(data.toJson());

class FoodRecommendation {
  int id;
  int? foodCategoryId;
  int userId;
  String name;
  String image;
  String age;
  int energy;
  double protein;
  int fat;
  int portion;
  List<String> recipe;
  List<String> fruit;
  List<String> step;
  String description;
  int favoriteCount;
  FoodCategory? foodCategory;

  FoodRecommendation({
    required this.id,
    this.foodCategoryId,
    required this.userId,
    required this.name,
    required this.image,
    required this.age,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.portion,
    required this.fruit,
    required this.recipe,
    required this.step,
    required this.description,
    required this.favoriteCount,
    this.foodCategory,
  });

  factory FoodRecommendation.fromJson(Map<String, dynamic> json) =>
      FoodRecommendation(
        id: json["id"],
        foodCategoryId: json["food_category_id"] as int?,
        userId: json["user_id"],
        name: json["name"],
        image: json["image"],
        age: json["age"],
        energy: json["energy"],
        protein: json["protein"]?.toDouble(),
        fat: json["fat"],
        portion: json["portion"],
        fruit: List<String>.from(json["fruit"].map((x) => x)),
        recipe: List<String>.from(json["recipe"].map((x) => x)),
        step: List<String>.from(json["step"].map((x) => x)),
        description: json["description"],
        favoriteCount: json["favorite_count"],
        foodCategory:
            json["food_category"] != null
                ? FoodCategory.fromJson(json["food_category"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "food_category_id": foodCategoryId,
    "user_id": userId,
    "name": name,
    "image": image,
    "age": age,
    "energy": energy,
    "protein": protein,
    "fat": fat,
    "portion": portion,
    "fruit": List<dynamic>.from(fruit.map((x) => x)),
    "recipe": List<dynamic>.from(recipe.map((x) => x)),
    "step": List<dynamic>.from(step.map((x) => x)),
    "description": description,
    "favorite_count": favoriteCount,
    "food_category": foodCategory?.toJson(),
  };
}

class FoodCategory {
  int id;
  String name;

  FoodCategory({required this.id, required this.name});

  factory FoodCategory.fromJson(Map<String, dynamic> json) =>
      FoodCategory(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
