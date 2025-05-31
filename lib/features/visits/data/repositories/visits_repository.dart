import 'package:get/get.dart';
import 'package:sales_force_automation/core/models/customer_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/models/visit.dart';
import '../../../../core/models/activity.dart';

class VisitsRepository implements IVisitsRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

  Future<List<Visit>> getVisits() async {
    if (_connectivityService.isConnected) {
      try {
        try {
          await syncLocalVisits();
        } catch (syncError) {}

        final apiVisits = await _apiService.getVisits();
        final localVisits = await _databaseService.getLocalVisits();
        final allVisits = <Visit>[];
        allVisits.addAll(apiVisits);

        for (final localVisit in localVisits) {
          if (localVisit.isLocal &&
              !apiVisits.any((apiVisit) => apiVisit.id == localVisit.id)) {
            allVisits.add(localVisit);
          }
        }

        return allVisits;
      } catch (e) {
        return await _databaseService.getLocalVisits();
      }
    } else {
      return await _databaseService.getLocalVisits();
    }
  }

  Future<Visit> createVisit(Visit visit) async {
    if (_connectivityService.isConnected) {
      try {
        final createdVisit = await _apiService.createVisit(visit);
        return createdVisit;
      } catch (e) {
        final localVisit = visit.copyWith(isLocal: true);
        await _databaseService.insertVisit(localVisit);
        return localVisit;
      }
    } else {
      final localVisit = visit.copyWith(isLocal: true);
      await _databaseService.insertVisit(localVisit);
      return localVisit;
    }
  }

  Future<Visit> updateVisit(Visit visit) async {
    if (_connectivityService.isConnected && !visit.isLocal) {
      try {
        return await _apiService.updateVisit(visit);
      } catch (e) {
        throw Exception('Failed to update visit: $e');
      }
    } else {
      throw Exception('Cannot update local visits');
    }
  }

  Future<void> syncLocalVisits() async {
    if (!_connectivityService.isConnected) {
      return;
    }

    final unsyncedVisits = await _databaseService.getUnsyncedVisits();

    for (int i = 0; i < unsyncedVisits.length; i++) {
      final visit = unsyncedVisits[i];
      try {
        List<String> newActivities = <String>[];
        for (String activity in visit.activitiesDone) {
          newActivities.add(activity.toString());
        }

        final visitForApi = Visit(
          customerId: visit.customerId,
          visitDate: visit.visitDate,
          status: visit.status,
          location: visit.location,
          notes: visit.notes,
          activitiesDone: newActivities,
          createdAt: visit.createdAt,
          isLocal: false,
        );

        final apiJson = visitForApi.toApiJson();

        final syncedVisit = await _apiService.createVisit(visitForApi);

        if (visit.id != null) {
          await _databaseService.markVisitAsSynced(visit.id!);
        }
      } catch (e, stackTrace) {
        continue;
      }
    }
  }

  Future<List<Customer>> getCustomers() async {
    if (_connectivityService.isConnected) {
      try {
        final customers = await _apiService.getCustomers();
        await _databaseService.insertCustomers(customers);
        return customers;
      } catch (e) {
        final localCustomers = await _databaseService.getLocalCustomers();
        return localCustomers;
      }
    } else {
      final localCustomers = await _databaseService.getLocalCustomers();
      return localCustomers;
    }
  }

  Future<List<Activity>> getActivities() async {
    if (_connectivityService.isConnected) {
      try {
        final activities = await _apiService.getActivities();
        await _databaseService.insertActivities(activities);
        return activities;
      } catch (e) {
        return await _databaseService.getLocalActivities();
      }
    } else {
      return await _databaseService.getLocalActivities();
    }
  }

  Future<bool> forceSyncAll() async {
    if (!_connectivityService.isConnected) {
      return false;
    }

    try {
      await syncLocalVisits();
      return true;
    } catch (e, stackTrace) {
      return false;
    }
  }

  Future<void> testSyncOnly() async {
    try {
      await syncLocalVisits();
    } catch (e, stackTrace) {}
  }
}

class IVisitsRepository {}
