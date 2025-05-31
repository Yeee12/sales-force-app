import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_force_automation/core/route/app_routes.dart';
import 'package:sales_force_automation/features/visits/presentation/widgets/activities_selector.dart';
import 'package:sales_force_automation/features/visits/presentation/widgets/search_filter_bar.dart';
import '../controllers/visits_controller.dart';

class VisitsPage extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => Get.toNamed(AppRoutes.VISIT_STATISTICS),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          SearchFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.visits.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredVisits.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_center_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.visits.isEmpty
                            ? 'No visits yet'
                            : 'No visits match your filters',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      if (controller.visits.isEmpty)
                        Text(
                          'Tap the + button to create your first visit',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.builder(
                  itemCount: controller.filteredVisits.length,
                  itemBuilder: (context, index) {
                    final visit = controller.filteredVisits[index];
                    return VisitCard(
                      visit: visit,
                      customerName: controller.getCustomerName(
                        visit.customerId,
                      ),
                      activities: controller.getActivityDescriptions(
                        List<String>.from(visit.activitiesDone),
                      ),
                      onTap:
                          () => Get.toNamed(
                            AppRoutes.VISIT_DETAILS,
                            arguments: visit,
                          ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_VISIT),
        child: const Icon(Icons.add),
      ),
    );
  }
}
