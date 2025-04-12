class Baby {
  final String id;
  final String name;
  final String? avatarUrl;
  final int? ageInMonths;
  final double? weight;
  final double? height;
  final bool isProfileComplete;
  final String? gender;
  final String? allergy;

  Baby({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.ageInMonths,
    this.weight,
    this.height,
    this.isProfileComplete = false,
    this.gender,
    this.allergy,
  });

  // Data dummy untuk bayi
  static List<Baby> dummyBabies = [
    Baby(id: '1', name: 'Bayi 1', avatarUrl: null, isProfileComplete: false),
    Baby(
      id: '2',
      name: 'Abay Cekut',
      avatarUrl: null,
      ageInMonths: 6,
      weight: 7.5,
      height: 68.0,
      isProfileComplete: true,
      gender: 'Laki-Laki',
      allergy: 'Cow Milk',
    ),
    Baby(
      id: '3',
      name: 'Naystar Cikut',
      avatarUrl: null,
      ageInMonths: 12,
      weight: 9.2,
      height: 74.5,
      isProfileComplete: true,
      gender: 'Perempuan',
      allergy: 'Breast Milk',
    ),
  ];
}
