// lib/core/bindings/app_binding.dart
import 'package:get/get.dart';
import 'package:sales_force_automation/core/services/api_service.dart';
import 'package:sales_force_automation/core/services/database_service.dart';
import 'package:sales_force_automation/core/services/connectivity_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<DatabaseService>(() => DatabaseService());
    Get.lazyPut<ConnectivityService>(() => ConnectivityService());
  }
}
