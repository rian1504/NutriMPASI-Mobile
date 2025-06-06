// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

Food foodFromJson(String str) => Food.fromJson(json.decode(str));

String foodToJson(Food data) => json.encode(data.toJson());

class Food {
  int id;
  int? foodCategoryId;
  int? userId;
  String name;
  String? source;
  String image;
  String? age;
  double? energy;
  double? protein;
  double? fat;
  int? portion;
  String description;
  DateTime? createdAt;
  int favoritesCount;
  bool isFavorite;
  FoodCategory? foodCategory;
  User? user;

  Food({
    required this.id,
    this.foodCategoryId,
    this.userId,
    required this.name,
    this.source,
    required this.image,
    this.age,
    this.energy,
    this.protein,
    this.fat,
    this.portion,
    required this.description,
    this.createdAt,
    required this.favoritesCount,
    required this.isFavorite,
    this.foodCategory,
    this.user,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"] as int,
    foodCategoryId: json["food_category_id"] as int?,
    userId: json["user_id"] as int?,
    name: json["name"] as String,
    source: json["source"] as String?,
    image: json["image"] as String,
    age: json["age"] as String?,
    energy: (json["energy"] as num?)?.toDouble(),
    protein: (json["protein"] as num?)?.toDouble(),
    fat: (json["fat"] as num?)?.toDouble(),
    portion: json["portion"] as int?,
    description: json["description"] as String,
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    favoritesCount: json["favorites_count"] as int,
    isFavorite: json["is_favorite"] as bool,
    foodCategory:
        json["food_category"] != null
            ? FoodCategory.fromJson(json["food_category"])
            : null,
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "food_category_id": foodCategoryId,
    "user_id": userId,
    "name": name,
    "source": source,
    "image": image,
    "age": age,
    "energy": energy,
    "protein": protein,
    "fat": fat,
    "portion": portion,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "favorites_count": favoritesCount,
    "is_favorite": isFavorite,
    "food_category": foodCategory?.toJson(),
    "user": user?.toJson(),
  };

  Food copyWith({
    int? id,
    int? foodCategoryId,
    int? userId,
    String? name,
    String? source,
    String? image,
    String? age,
    double? energy,
    double? protein,
    double? fat,
    int? portion,
    String? description,
    DateTime? createdAt,
    int? favoritesCount,
    bool? isFavorite,
    FoodCategory? foodCategory,
    User? user,
  }) {
    return Food(
      id: id ?? this.id,
      foodCategoryId: foodCategoryId ?? this.foodCategoryId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      source: source ?? this.source,
      image: image ?? this.image,
      age: age ?? this.age,
      energy: energy ?? this.energy,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      portion: portion ?? this.portion,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      isFavorite: isFavorite ?? this.isFavorite,
      foodCategory: foodCategory ?? this.foodCategory,
      user: user ?? this.user,
    );
  }
}

class FoodCategory {
  int id;
  String name;

  FoodCategory({required this.id, required this.name});

  factory FoodCategory.fromJson(Map<String, dynamic> json) =>
      FoodCategory(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class User {
  int id;
  String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
