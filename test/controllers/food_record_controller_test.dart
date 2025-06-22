import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/controllers/food_record_controller.dart';
import 'package:nutrimpasi/models/food_record.dart';

// Generate mock class for Dio
@GenerateMocks([Dio])
import 'food_record_controller_test.mocks.dart';

void main() {
  late FoodRecordController controller;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    controller = FoodRecordController();
    controller.dio = mockDio;
  });

  group('FoodRecordController Tests', () {
    test('getFoodRecord should return list of food records', () async {
      // Arrange
      final responseData = {
        'data': [
          {
            'id': 1,
            'baby_id': 1,
            'food_id': 101,
            'name': 'Banana Porridge',
            'source': 'homemade',
            'image': 'banana.jpg',
            'portion': 100,
            'energy': 120.5,
            'protein': 3.5,
            'fat': 2.0,
            'date': '2023-05-15',
          },
          {
            'id': 2,
            'baby_id': 1,
            'food_id': 102,
            'name': 'Apple Puree',
            'source': 'store-bought',
            'image': 'apple.jpg',
            'portion': 75,
            'energy': 80.5,
            'protein': 1.5,
            'fat': 0.5,
            'date': '2023-05-16',
          },
        ],
      };

      when(mockDio.get(ApiEndpoints.foodRecord)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.foodRecord),
        ),
      );

      // Act
      final result = await controller.getFoodRecord();

      // Assert
      expect(result, isA<List<FoodRecord>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].foodId, 101);
      expect(result[0].babyId, 1);
      expect(result[0].name, 'Banana Porridge');
      expect(result[0].source, 'homemade');
      expect(result[0].image, 'banana.jpg');
      expect(result[0].portion, 100);
      expect(result[0].energy, 120.5);
      expect(result[0].protein, 3.5);
      expect(result[0].fat, 2.0);

      expect(result[1].id, 2);
      expect(result[1].foodId, 102);
      expect(result[1].babyId, 1);
      expect(result[1].name, 'Apple Puree');
      expect(result[1].portion, 75);
      verify(mockDio.get(ApiEndpoints.foodRecord)).called(1);
    });
  });
}
