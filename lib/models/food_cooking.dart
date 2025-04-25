// To parse this JSON data, do
//
//     final foodCooking = foodCookingFromJson(jsonString);

import 'dart:convert';

FoodCooking foodCookingFromJson(String str) =>
    FoodCooking.fromJson(json.decode(str));

String foodCookingToJson(FoodCooking data) => json.encode(data.toJson());

class FoodCooking {
  FoodCookingGuide foodCookingGuide;
  Request request;

  FoodCooking({required this.foodCookingGuide, required this.request});

  factory FoodCooking.fromJson(Map<String, dynamic> json) => FoodCooking(
    foodCookingGuide: FoodCookingGuide.fromJson(json["food"]),
    request: Request.fromJson(json["request"]),
  );

  Map<String, dynamic> toJson() => {
    "foodCookingGuide": foodCookingGuide.toJson(),
    "request": request.toJson(),
  };
}

class FoodCookingGuide {
  int id;
  String name;
  String image;
  int portion;
  List<String> recipe;
  List<String> fruit;
  List<String> step;
  int foodRecordCount;

  FoodCookingGuide({
    required this.id,
    required this.name,
    required this.image,
    required this.portion,
    required this.recipe,
    required this.fruit,
    required this.step,
    required this.foodRecordCount,
  });

  factory FoodCookingGuide.fromJson(Map<String, dynamic> json) =>
      FoodCookingGuide(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        portion: json["portion"],
        recipe: List<String>.from(json["recipe"].map((x) => x)),
        fruit: List<String>.from(json["fruit"].map((x) => x)),
        step: List<String>.from(json["step"].map((x) => x)),
        foodRecordCount: json["food_record_count"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "portion": portion,
    "recipe": List<dynamic>.from(recipe.map((x) => x)),
    "fruit": List<dynamic>.from(fruit.map((x) => x)),
    "step": List<dynamic>.from(step.map((x) => x)),
    "food_record_count": foodRecordCount,
  };
}

class Request {
  List<String> babyId;

  Request({required this.babyId});

  factory Request.fromJson(Map<String, dynamic> json) =>
      Request(babyId: List<String>.from(json["baby_id"].map((x) => x)));

  Map<String, dynamic> toJson() => {
    "baby_id": List<dynamic>.from(babyId.map((x) => x)),
  };
}
