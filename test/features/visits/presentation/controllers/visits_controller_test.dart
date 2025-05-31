import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:sales_force_automation/core/models/visit.dart';
import 'package:sales_force_automation/core/models/customer_model.dart';
import 'package:sales_force_automation/core/models/activity.dart';
import 'package:sales_force_automation/features/visits/data/repositories/visits_repository.dart';
import 'package:sales_force_automation/features/visits/presentation/controllers/visits_controller.dart';

import '../../mocks/visits_repository_mock.mocks.dart';

void main() {
  late VisitsController controller;
  late MockVisitsRepository mockRepo;

  setUp(() async {
    mockRepo = MockVisitsRepository();
    Get.reset();

    Get.put<VisitsRepository>(mockRepo);

    // Defer controller initialization
    await Get.putAsync<VisitsController>(() async {
      // Set up mock stubs first
      when(mockRepo.getVisits()).thenAnswer((_) async => []);
      when(mockRepo.getCustomers()).thenAnswer((_) async => []);
      when(mockRepo.getActivities()).thenAnswer((_) async => []);
      when(mockRepo.syncLocalVisits()).thenAnswer((_) async => null);

      return VisitsController();
    });

    controller = Get.find<VisitsController>();
  });


  test('loadData loads visits, customers, activities', () async {
    final visits = [
      Visit(
        customerId: 1,
        location: 'A',
        notes: 'Note',
        visitDate: DateTime(2024, 1, 1),
        status: 'Pending',
        activitiesDone: [],
      )
    ];

    final customers = [
      Customer(
        id: 1,
        name: 'Test Customer',
        createdAt: DateTime(2024, 1, 1),
      )
    ];

    final activities = [
      Activity(
        id: 1,
        description: 'Demo Activity',
        createdAt: DateTime(2024, 1, 1),
      )
    ];

    when(mockRepo.getVisits()).thenAnswer((_) async => visits);
    when(mockRepo.getCustomers()).thenAnswer((_) async => customers);
    when(mockRepo.getActivities()).thenAnswer((_) async => activities);
    when(mockRepo.syncLocalVisits()).thenAnswer((_) async => null);

    await controller.loadData();


    expect(controller.visits.length, 1);
    expect(controller.visits.first.location, 'A');

    expect(controller.customers.length, 1);
    expect(controller.customers.first.name, 'Test Customer');

    expect(controller.activities.length, 1);
    expect(controller.activities.first.description, 'Demo Activity');
    });
}