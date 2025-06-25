import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/controllers/schedule_controller.dart';
import 'package:nutrimpasi/models/schedule.dart';

// Generate mock class for Dio
@GenerateMocks([Dio])
import 'schedule_controller_test.mocks.dart';

void main() {
  late ScheduleController controller;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    controller = ScheduleController();
    controller.dio = mockDio;
  });

  group('ScheduleController Tests', () {
    test('getSchedule should return list of schedules', () async {
      // Arrange
      final responseData = {
        'data': [
          {
            'id': 1,
            'food_id': 101,
            'baby_id': [1, 2],
            'date': '2023-05-15',
            'created_at': '2023-05-01',
            'updated_at': '2023-05-01',
            'food': {
              'id': 101,
              'name': 'Banana Porridge',
              'image': 'banana.jpg',
            },
            'baby': [
              {'id': 1, 'name': 'Baby 1'},
              {'id': 2, 'name': 'Baby 2'},
            ],
          },
          {
            'id': 2,
            'food_id': 102,
            'baby_id': [3],
            'date': '2023-05-16',
            'created_at': '2023-05-02',
            'updated_at': '2023-05-02',
            'food': {'id': 102, 'name': 'Apple Puree', 'image': 'apple.jpg'},
            'baby': [
              {'id': 3, 'name': 'Baby 3'},
            ],
          },
        ],
      };

      when(mockDio.get(ApiEndpoints.schedule)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.schedule),
        ),
      );

      // Act
      final result = await controller.getSchedule();

      // Assert
      expect(result, isA<List<Schedule>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].foodId, 101);
      expect(result[1].id, 2);
      expect(result[1].foodId, 102);
      verify(mockDio.get(ApiEndpoints.schedule)).called(1);
    });

    test('storeSchedule should send correct data to API', () async {
      // Arrange
      final foodId = 101;
      final babyIds = ['1', '2'];
      final date = DateTime(2023, 5, 15);

      // Mock successful response
      when(
        mockDio.post(
          '${ApiEndpoints.schedule}/$foodId',
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'message': 'Schedule created successfully'},
          statusCode: 201,
          requestOptions: RequestOptions(
            path: '${ApiEndpoints.schedule}/$foodId',
          ),
        ),
      );

      // Act
      await controller.storeSchedule(
        foodId: foodId,
        babyId: babyIds,
        date: date,
      );

      // Verify that post was called with the correct path
      verify(
        mockDio.post(
          '${ApiEndpoints.schedule}/$foodId',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('updateSchedule should send correct data to API', () async {
      // Arrange
      final scheduleId = 1;
      final babyIds = ['1', '2', '3'];
      final date = DateTime(2023, 6, 20);

      // Mock successful response
      when(
        mockDio.post(
          '${ApiEndpoints.schedule}/$scheduleId/update',
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'message': 'Schedule updated successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '${ApiEndpoints.schedule}/$scheduleId/update',
          ),
        ),
      );

      // Act
      await controller.updateSchedule(
        scheduleId: scheduleId,
        babyId: babyIds,
        date: date,
      );

      // Assert
      verify(
        mockDio.post(
          '${ApiEndpoints.schedule}/$scheduleId/update',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('deleteSchedule should call API with correct schedule ID', () async {
      // Arrange
      final scheduleId = 1;

      when(mockDio.delete('${ApiEndpoints.schedule}/$scheduleId')).thenAnswer(
        (_) async => Response(
          data: {'message': 'Schedule deleted successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '${ApiEndpoints.schedule}/$scheduleId',
          ),
        ),
      );

      // Act
      await controller.deleteSchedule(scheduleId: scheduleId);

      // Assert
      verify(mockDio.delete('${ApiEndpoints.schedule}/$scheduleId')).called(1);
    });
  });
}
