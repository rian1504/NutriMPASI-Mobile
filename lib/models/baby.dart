// To parse this JSON data, do
//
//     final baby = babyFromJson(jsonString);

import 'dart:convert';

Baby babyFromJson(String str) => Baby.fromJson(json.decode(str));

String babyToJson(Baby data) => json.encode(data.toJson());

class Baby {
  int id;
  String name;
  DateTime? dob;
  String gender;
  double? height;
  double? weight;
  String? condition;
  bool isProfileComplete;

  Baby({
    required this.id,
    required this.name,
    this.dob,
    required this.gender,
    this.height,
    this.weight,
    this.condition,
    required this.isProfileComplete,
  });

  factory Baby.fromJson(Map<String, dynamic> json) => Baby(
    id: json["id"],
    name: json["name"],
    dob: json["dob"] != null ? DateTime.parse(json["dob"]) : null,
    gender: json["gender"],
    height:
        json["height"] != null ? double.parse(json["height"].toString()) : null,
    weight:
        json["weight"] != null ? double.parse(json["weight"].toString()) : null,
    condition: json["condition"],
    isProfileComplete: json["is_profile_complete"] == 1 ? true : false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "dob":
        dob != null
            ? "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
            : null,
    "gender": gender,
    "height": height,
    "weight": weight,
    "condition": condition,
    "is_profile_complete": isProfileComplete,
  };

  // Helper untuk menghitung usia dalam bulan
  String? get ageInMonths {
    if (dob == null) return '- bulan';

    final now = DateTime.now();
    final months = (now.year - dob!.year) * 12 + now.month - dob!.month;

    if (now.day < dob!.day) {
      return '${months - 1} bulan';
    }

    return '$months bulan';
  }
}
