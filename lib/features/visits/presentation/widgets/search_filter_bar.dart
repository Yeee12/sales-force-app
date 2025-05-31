import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/visit_status.dart';
import '../controllers/visits_controller.dart';

class SearchFilterBar extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search visits...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Obx(
                () =>
                    controller.searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.updateSearchQuery(''),
                        )
                        : const SizedBox.shrink(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: controller.updateSearchQuery,
          ),

          const SizedBox(height: 12),

          // Filter Row
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<VisitStatus?>(
                    value: controller.statusFilter,
                    decoration: InputDecoration(
                      labelText: 'Filter by Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<VisitStatus?>(
                        value: null,
                        child: Text('All Statuses'),
                      ),
                      ...VisitStatus.values.map((status) {
                        return DropdownMenuItem<VisitStatus?>(
                          value: status,
                          child: Text(status.value),
                        );
                      }),
                    ],
                    onChanged: controller.updateStatusFilter,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Obx(
                () =>
                    controller.searchQuery.isNotEmpty ||
                            controller.statusFilter != null
                        ? ElevatedButton.icon(
                          onPressed: controller.clearFilters,
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
