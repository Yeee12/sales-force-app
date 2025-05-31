import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_force_automation/features/visits/presentation/controllers/visits_controller.dart';

class StatusChart extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visit Status Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatusBar(
              context,
              'Completed',
              controller.completedVisits,
              controller.totalVisits,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildStatusBar(
              context,
              'Pending',
              controller.pendingVisits,
              controller.totalVisits,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildStatusBar(
              context,
              'Cancelled',
              controller.cancelledVisits,
              controller.totalVisits,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(
      BuildContext context,
      String status,
      int count,
      int total,
      Color color,
      ) {
    final percentage = total > 0 ? (count / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count (${(percentage * 100).toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }
}