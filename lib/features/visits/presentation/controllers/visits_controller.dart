import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sales_force_automation/core/enums/visit_status.dart';
import 'package:sales_force_automation/core/models/activity.dart';
import 'package:sales_force_automation/core/models/customer_model.dart';
import 'package:sales_force_automation/core/models/visit.dart';
import 'package:sales_force_automation/features/visits/data/repositories/visits_repository.dart';


class VisitsController extends GetxController {
  final VisitsRepository _repository = Get.put(VisitsRepository());

  final RxList<Visit> _visits = <Visit>[].obs;
  final RxList<Visit> _filteredVisits = <Visit>[].obs;
  final RxList<Customer> _customers = <Customer>[].obs;
  final RxList<Activity> _activities = <Activity>[].obs;

  final RxBool _isLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  final RxString _searchQuery = ''.obs;
  final Rx<VisitStatus?> _statusFilter = Rx<VisitStatus?>(null);

  final formKey = GlobalKey<FormState>();
  final customerController = TextEditingController();
  final locationController = TextEditingController();
  final notesController = TextEditingController();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<VisitStatus> selectedStatus = VisitStatus.pending.obs;
  final RxList<String> selectedActivities = <String>[].obs;

  final Rx<int?> selectedCustomerId = Rx<int?>(null);

  List<Visit> get visits => _visits.toList();
  List<Visit> get filteredVisits => _filteredVisits.toList();
  List<Customer> get customers => _customers.toList();
  List<Activity> get activities => _activities.toList();
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String get searchQuery => _searchQuery.value;
  VisitStatus? get statusFilter => _statusFilter.value;

  @override
  void onInit() {
    super.onInit();
    loadData();

    debounce(_searchQuery, (_) => _filterVisits(), time: const Duration(milliseconds: 300));
    ever(_statusFilter, (_) => _filterVisits());
  }

  @override
  void onClose() {
    customerController.dispose();
    locationController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    try {
      _isLoading.value = true;

      final results = await Future.wait([
        _repository.getVisits(),
        _repository.getCustomers(),
        _repository.getActivities(),
      ]);

      final visits = results[0] as List<Visit>;
      final customers = results[1] as List<Customer>;
      final activities = results[2] as List<Activity>;


      _visits.assignAll(visits);
      _customers.assignAll(customers);
      _activities.assignAll(activities);

      _filterVisits();
      await _repository.syncLocalVisits();
    } catch (e) {
      print('Load data error: $e');
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }


  Future<void> refreshData() async {
    try {
      _isRefreshing.value = true;
      await loadData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isRefreshing.value = false;
    }
  }

  Future<void> createVisit() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCustomerId.value == null) {
      Get.snackbar(
        'Error',
        'Please select a customer.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      _isLoading.value = true;

      final selectedCustomer = _customers.firstWhereOrNull(
            (customer) => customer.id == selectedCustomerId.value,
      );

      if (selectedCustomer == null) {
        Get.snackbar(
          'Error',
          'Selected customer not found.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final List<String> activitiesList = selectedActivities.toList();

      final visit = Visit(
        customerId: selectedCustomer.id,
        visitDate: selectedDate.value,
        status: selectedStatus.value.value,
        location: locationController.text.trim(),
        notes: notesController.text.trim(),
        activitiesDone: activitiesList,
      );



      final createdVisit = await _repository.createVisit(visit);
      _visits.add(createdVisit);
      _filterVisits();

      _resetForm();

      Get.back();
      Get.snackbar(
        'Success',
        'Visit created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create visit: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void updateStatusFilter(VisitStatus? status) {
    _statusFilter.value = status;
  }

  void clearFilters() {
    _searchQuery.value = '';
    _statusFilter.value = null;
  }

  void _filterVisits() {
    List<Visit> filtered = List<Visit>.from(_visits);

    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered = filtered.where((visit) {
        final customer = _customers.firstWhereOrNull((c) => c.id == visit.customerId);
        final customerName = customer?.name.toLowerCase() ?? '';
        final location = visit.location.toLowerCase();
        final notes = visit.notes.toLowerCase();
        return customerName.contains(query) ||
            location.contains(query) ||
            notes.contains(query);
      }).toList();
    }

    if (_statusFilter.value != null) {
      filtered = filtered.where((visit) {
        return visit.status == _statusFilter.value!.value;
      }).toList();
    }

    filtered.sort((a, b) => b.visitDate.compareTo(a.visitDate));

    _filteredVisits.assignAll(filtered);
  }

  void _resetForm() {
    customerController.clear();
    locationController.clear();
    notesController.clear();
    selectedDate.value = DateTime.now();
    selectedStatus.value = VisitStatus.pending;
    selectedActivities.clear();
    selectedCustomerId.value = null;
  }

  String getCustomerName(int customerId) {
    final customer = _customers.firstWhereOrNull((c) => c.id == customerId);
    return customer?.name ?? 'Unknown Customer';
  }

  List<String> getActivityDescriptions(List<String> activityIds) {
    return activityIds.map((id) {
      final activity = _activities.firstWhereOrNull(
            (a) => a.id.toString() == id,
      );
      return activity?.description ?? 'Unknown Activity';
    }).toList();
  }


  int get totalVisits => _visits.length;
  int get completedVisits => _visits.where((v) => v.status == 'Completed').length;
  int get pendingVisits => _visits.where((v) => v.status == 'Pending').length;
  int get cancelledVisits => _visits.where((v) => v.status == 'Cancelled').length;

  double get completionRate => totalVisits > 0 ? (completedVisits / totalVisits) * 100 : 0;
}
