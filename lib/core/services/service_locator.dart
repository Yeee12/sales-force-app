import 'package:get/get.dart';
import 'api_service.dart';
import 'database_service.dart';
import 'connectivity_service.dart';

class ServiceLocator {
  static Future<void> init() async {
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<DatabaseService>(DatabaseService(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
  }
}
