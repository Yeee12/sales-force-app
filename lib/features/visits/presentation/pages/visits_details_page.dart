import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/visit.dart';
import '../controllers/visits_controller.dart';

class VisitDetailsPage extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    final Visit visit = Get.arguments as Visit;
    final customerName = controller.getCustomerName(visit.customerId);
    final activities = controller.getActivityDescriptions(visit.activitiesDone);

    return Scaffold(
      appBar: AppBar(title: const Text('Visit Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.business, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Customer',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    customerName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Visit Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Visit Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow(
                    'Date',
                    DateFormat('MMM dd, yyyy').format(visit.visitDate),
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoRow(
                    'Status',
                    visit.status,
                    Icons.flag,
                    statusColor: _getStatusColor(visit.status),
                  ),
                  const SizedBox(height: 12),

                  _buildInfoRow('Location', visit.location, Icons.location_on),

                  if (visit.isLocal) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Sync Status',
                      'Stored locally - will sync when online',
                      Icons.sync_problem,
                      statusColor: Colors.orange,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Notes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.note, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    visit.notes.isNotEmpty ? visit.notes : 'No notes added',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          // Activities
          if (activities.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.checklist, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Activities Completed',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...activities.map(
                      (activity) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                activity,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: statusColor ?? Colors.black87,
              fontWeight:
                  statusColor != null ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'planned':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
