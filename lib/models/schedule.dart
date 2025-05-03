// To parse this JSON data, do
//
//     final schedule = scheduleFromJson(jsonString);

import 'dart:convert';

Schedule scheduleFromJson(String str) => Schedule.fromJson(json.decode(str));

String scheduleToJson(Schedule data) => json.encode(data.toJson());

class Schedule {
  int id;
  DateTime date;
  int? foodId;
  Food? food;
  List<Baby> babies;

  Schedule({
    required this.id,
    required this.date,
    this.foodId,
    this.food,
    required this.babies,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    foodId: json["food_id"],
    food: json["food"] != null ? Food.fromJson(json["food"]) : null,
    babies: List<Baby>.from(json["babies"]?.map((x) => Baby.fromJson(x)) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "food_id": foodId,
    "food": food?.toJson(),
    "babies": List<dynamic>.from(babies.map((x) => x.toJson())),
  };
}

class Baby {
  int id;
  String name;

  Baby({required this.id, required this.name});

  factory Baby.fromJson(Map<String, dynamic> json) =>
      Baby(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Food {
  int id;
  String name;
  String image;

  Food({required this.id, required this.name, required this.image});

  factory Food.fromJson(Map<String, dynamic> json) =>
      Food(id: json["id"], name: json["name"], image: json["image"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image": image};
}
