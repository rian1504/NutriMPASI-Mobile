class FoodCategory {
  final String id;
  final String name;

  FoodCategory({required this.id, required this.name});

  // Data dummy kategori makanan
  static List<FoodCategory> dummyCategories = [
    FoodCategory(id: '1', name: 'Bubur & Puree'),
    FoodCategory(id: '2', name: 'Sup & Kuah'),
    FoodCategory(id: '3', name: 'Finger Food'),
    FoodCategory(id: '4', name: 'Karbohidrat'),
    FoodCategory(id: '5', name: 'Camilan Sehat'),
  ];
}
