import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/controllers/food_suggestion_controller.dart';
import 'package:nutrimpasi/models/food_suggestion.dart';

@GenerateMocks([Dio])
import 'food_suggestion_controller_test.mocks.dart';

void main() {
  late FoodSuggestionController controller;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    controller = FoodSuggestionController();
    controller.dio = mockDio;
  });

  group('FoodSuggestionController Tests', () {
    test('getFoodSuggestion should return list of food suggestion', () async {
      // Arrange
      final responseData = {
        'data': [
          {
            'id': 1,
            'name': 'Breakfast',
            'created_at': '2023-01-01',
            'updated_at': '2023-01-01',
          },
          {
            'id': 2,
            'name': 'Lunch',
            'created_at': '2023-01-01',
            'updated_at': '2023-01-01',
          },
        ],
      };

      when(mockDio.get(ApiEndpoints.foodCategory)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.foodCategory),
        ),
      );

      // Act
      final result = await controller.getFoodCategory();

      // Assert
      expect(result, isA<List<FoodCategory>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].name, 'Breakfast');
      expect(result[1].id, 2);
      expect(result[1].name, 'Lunch');
      verify(mockDio.get(ApiEndpoints.foodCategory)).called(1);
    });

    test('showFoodSuggestion should return food suggestion details', () async {
      // Arrange
      final foodId = 1;
      final responseData = {
        'data': {
          'id': foodId,
          'food_category_id': 1,
          'name': 'Banana Porridge',
          'image': 'image_url.jpg',
          'age': '6-8',
          'energy': 120.5,
          'protein': 3.5,
          'fat': 2.0,
          'portion': 100,
          'recipe': ['banana', 'milk', 'rice'],
          'fruit': ['banana', 'apple'],
          'step': ['step1', 'step2', 'step3'],
          'description': 'Delicious baby food',
          'created_at': '2023-01-01',
          'updated_at': '2023-01-01',
        },
      };

      when(mockDio.get('${ApiEndpoints.foodSuggestion}/$foodId')).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '${ApiEndpoints.foodSuggestion}/$foodId',
          ),
        ),
      );

      // Act
      final result = await controller.showFood(foodId: foodId);

      // Assert
      expect(result, isA<FoodSuggestion>());
      expect(result.id, foodId);
      expect(result.name, 'Banana Porridge');
      expect(result.energy, 120.5);
      expect(result.protein, 3.5);
      expect(result.fat, 2.0);
      expect(result.portion, 100);
      // Update assertions to match the expected format from the model
      expect(result.recipe.length, 3);
      expect(result.recipe, contains('banana'));
      expect(result.recipe, contains('milk'));
      expect(result.recipe, contains('rice'));
      verify(mockDio.get('${ApiEndpoints.foodSuggestion}/$foodId')).called(1);
    });

    test('storeFoodSuggestion should send correct data to API', () async {
      // Create a temporary file for testing
      final file = File('test/test.png');

      // Mock parameters
      final foodCategoryId = 1;
      final name = 'Test Food';
      final age = '6-8';
      final energy = 100.0;
      final protein = 5.0;
      final fat = 3.0;
      final portion = 150;
      final recipe = ['ingredient1', 'ingredient2'];
      final fruit = ['fruit1', 'fruit2'];
      final step = ['step1', 'step2'];
      final description = 'Test description';

      // Mock successful response
      when(
        mockDio.post(ApiEndpoints.foodSuggestion, data: anyNamed('data')),
      ).thenAnswer(
        (_) async => Response(
          data: {'message': 'Food created successfully'},
          statusCode: 201,
          requestOptions: RequestOptions(path: ApiEndpoints.foodSuggestion),
        ),
      );

      // Act
      await controller.storeFood(
        foodCategoryId: foodCategoryId,
        name: name,
        image: file,
        age: age,
        energy: energy,
        protein: protein,
        fat: fat,
        portion: portion,
        recipe: recipe,
        fruit: fruit,
        step: step,
        description: description,
      );

      // Assert
      verify(
        mockDio.post(ApiEndpoints.foodSuggestion, data: anyNamed('data')),
      ).called(1);
    });

    test('updateFoodSuggestion should send correct data to API', () async {
      // Mock parameters
      final foodId = 1;
      final foodCategoryId = 1;
      final name = 'Updated Food';
      final age = '6-8';
      final energy = 120.0;
      final protein = 6.0;
      final fat = 3.5;
      final portion = 175;
      final recipe = ['ingredient1', 'ingredient2'];
      final fruit = ['fruit1', 'fruit2'];
      final step = ['step1', 'step2'];
      final description = 'Updated description';

      // Mock successful response
      when(
        mockDio.post(
          '${ApiEndpoints.foodSuggestion}/$foodId',
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'message': 'Food updated successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '${ApiEndpoints.foodSuggestion}/$foodId',
          ),
        ),
      );

      // Act
      await controller.updateFood(
        foodId: foodId,
        foodCategoryId: foodCategoryId,
        name: name,
        age: age,
        energy: energy,
        protein: protein,
        fat: fat,
        portion: portion,
        recipe: recipe,
        fruit: fruit,
        step: step,
        description: description,
      );

      // Assert
      verify(
        mockDio.post(
          '${ApiEndpoints.foodSuggestion}/$foodId',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('deleteFoodSuggestion should call API with correct food ID', () async {
      // Arrange
      final foodId = 1;

      when(mockDio.delete('${ApiEndpoints.foodSuggestion}/$foodId')).thenAnswer(
        (_) async => Response(
          data: {'message': 'Food deleted successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '${ApiEndpoints.foodSuggestion}/$foodId',
          ),
        ),
      );

      // Act
      await controller.deleteFood(foodId: foodId);

      // Assert
      verify(
        mockDio.delete('${ApiEndpoints.foodSuggestion}/$foodId'),
      ).called(1);
    });
  });
}
