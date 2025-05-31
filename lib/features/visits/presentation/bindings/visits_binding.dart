import 'package:get/get.dart';
import 'package:sales_force_automation/features/visits/data/repositories/visits_repository.dart';
import 'package:sales_force_automation/features/visits/presentation/controllers/visits_controller.dart';

class VisitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitsRepository>(() => VisitsRepository());
    Get.lazyPut<VisitsController>(() => VisitsController());
  }
}
