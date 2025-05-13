// To parse this JSON data, do
//
//     final foodSuggestion = foodSuggestionFromJson(jsonString);

import 'dart:convert';

FoodSuggestion foodSuggestionFromJson(String str) =>
    FoodSuggestion.fromJson(json.decode(str));

String foodSuggestionToJson(FoodSuggestion data) => json.encode(data.toJson());

class FoodSuggestion {
  int? id;
  int? foodCategoryId;
  String name;
  String image;
  String age;
  double energy;
  double protein;
  double fat;
  int portion;
  List<String> recipe;
  List<String>? fruit;
  List<String> step;
  String description;
  int? favoriteCount;
  FoodCategory? foodCategory;

  FoodSuggestion({
    this.id,
    this.foodCategoryId,
    required this.name,
    required this.image,
    required this.age,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.portion,
    this.fruit,
    required this.recipe,
    required this.step,
    required this.description,
    this.favoriteCount,
    this.foodCategory,
  });

  factory FoodSuggestion.fromJson(Map<String, dynamic> json) => FoodSuggestion(
    id: json["id"] as int?,
    foodCategoryId: json["food_category_id"] as int?,
    name: json["name"],
    image: json["image"],
    age: json["age"],
    energy: json["energy"]?.toDouble(),
    protein: json["protein"]?.toDouble(),
    fat: json["fat"]?.toDouble(),
    portion: json["portion"],
    fruit:
        json["fruit"] != null
            ? List<String>.from(json["fruit"].map((x) => x))
            : null,
    recipe: List<String>.from(json["recipe"].map((x) => x)),
    step: List<String>.from(json["step"].map((x) => x)),
    description: json["description"],
    favoriteCount: json["favorite_count"] as int?,
    foodCategory:
        json["food_category"] != null
            ? FoodCategory.fromJson(json["food_category"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "food_category_id": foodCategoryId,
    "name": name,
    "image": image,
    "age": age,
    "energy": energy,
    "protein": protein,
    "fat": fat,
    "portion": portion,
    "fruit": fruit != null ? List<dynamic>.from(fruit!.map((x) => x)) : null,
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
