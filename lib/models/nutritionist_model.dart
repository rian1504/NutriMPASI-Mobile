class Nutritionist {
  final String name;
  final String image;
  final String telp;
  final String specialization;
  final String gender;

  const Nutritionist({
    required this.name,
    required this.image,
    required this.telp,
    required this.specialization,
    required this.gender,
  });

  bool get hasWhatsapp => telp.isNotEmpty;

  static List<Nutritionist> sampleNutritionists = [
    const Nutritionist(
      name: 'Dr. Boykee Abdullah',
      specialization: 'Spesialis Gizi',
      image: 'assets/images/nutritionist/doctor1.png',
      telp: '+6281234567890',
      gender: 'male',
    ),
    const Nutritionist(
      name: 'Dr. Fadli Aditya S.',
      specialization: 'Spesialis Gizi Anak',
      image: 'assets/images/nutritionist/doctor2.png',
      telp: '+6280987654321',
      gender: 'male',
    ),
    const Nutritionist(
      name: 'Dr. Pipit Lol',
      specialization: 'Konsultan Gizi',
      image: 'assets/images/nutritionist/doctor3.png',
      telp: '',
      gender: 'female',
    ),
  ];
}
