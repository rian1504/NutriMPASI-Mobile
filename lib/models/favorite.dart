// To parse this JSON data, do
//
//     final favorite = favoriteFromJson(jsonString);

import 'dart:convert';

Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));

String favoriteToJson(Favorite data) => json.encode(data.toJson());

class Favorite {
  int foodId;
  Food food;

  Favorite({required this.foodId, required this.food});

  Favorite copyWith({int? foodId, Food? food}) =>
      Favorite(foodId: foodId ?? this.foodId, food: food ?? this.food);

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      Favorite(foodId: json["food_id"], food: Food.fromJson(json["food"]));

  Map<String, dynamic> toJson() => {"food_id": foodId, "food": food.toJson()};
}

class Food {
  int id;
  String name;
  String image;
  String description;

  Food({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  Food copyWith({int? id, String? name, String? image, String? description}) =>
      Food(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        description: description ?? this.description,
      );

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "description": description,
  };
}
