import 'package:get/get.dart';
import 'package:sales_force_automation/features/visits/presentation/bindings/visits_binding.dart';
import 'package:sales_force_automation/features/visits/presentation/pages/add_visit_page.dart';
import 'package:sales_force_automation/features/visits/presentation/pages/visit_statistics_page.dart';
import 'package:sales_force_automation/features/visits/presentation/pages/visits_details_page.dart';
import 'package:sales_force_automation/features/visits/presentation/pages/visits_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.VISITS,
      page: () => VisitsPage(),
      binding: VisitsBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_VISIT,
      page: () => AddVisitPage(),
      binding: VisitsBinding(),
    ),
    GetPage(
      name: AppRoutes.VISIT_DETAILS,
      page: () => VisitDetailsPage(),
      binding: VisitsBinding(),
    ),
    GetPage(
      name: AppRoutes.VISIT_STATISTICS,
      page: () => VisitStatisticsPage(),
      binding: VisitsBinding(),
    ),
  ];
}
