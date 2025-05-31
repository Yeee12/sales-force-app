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
    print('Checking internet: ${_connectivityService.isConnected}');

    if (_connectivityService.isConnected) {
      try {
        print('Syncing local visits...');
        await syncLocalVisits();

        final apiVisits = await _apiService.getVisits();
        print('API returned: ${apiVisits.length}');

        final localVisits = await _databaseService.getLocalVisits();
        print('Local visits: ${localVisits.length}');

        final allVisits = <Visit>[];
        allVisits.addAll(apiVisits);

        for (final localVisit in localVisits) {
          if (localVisit.isLocal &&
              !apiVisits.any((apiVisit) => apiVisit.id == localVisit.id)) {
            allVisits.add(localVisit);
          }
        }

        print('Total combined visits: ${allVisits.length}');
        return allVisits;
      } catch (e) {
        print('Error occurred: $e');
        return await _databaseService.getLocalVisits();
      }
    } else {
      print('Offline, returning local visits only');
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
    print('Found ${unsyncedVisits.length} unsynced visits');

    for (final visit in unsyncedVisits) {
      try {
        final visitForApi = Visit(
          customerId: visit.customerId,
          visitDate: visit.visitDate,
          status: visit.status,
          location: visit.location,
          notes: visit.notes,
          activitiesDone: List<String>.from(visit.activitiesDone),
          createdAt: visit.createdAt,
          isLocal: false,
        );

        final syncedVisit = await _apiService.createVisit(visitForApi);

        if (syncedVisit.id != null && visit.id != syncedVisit.id) {
          await _databaseService.updateVisitId(visit.id!, syncedVisit.id!);
        }

        if (visit.id != null) {
          await _databaseService.markVisitAsSynced(visit.id!);
        }

        print('Visit synced successfully: ${visit.id}');
      } catch (e, stackTrace) {
        print('Error syncing visit: $e');
        print('Stack trace: $stackTrace');
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
    } catch (e) {
      return false;
    }
  }

  Future<void> testSyncOnly() async {
    try {
      await syncLocalVisits();
    } catch (e) {}
  }
}

class IVisitsRepository {}
