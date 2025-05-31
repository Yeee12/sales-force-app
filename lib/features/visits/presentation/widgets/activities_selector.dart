import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/visit.dart';
import '../controllers/visits_controller.dart';

class ActivitiesSelector extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.activities.isEmpty) {
        return const Center(child: Text('No activities found'));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Activities',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...controller.activities.map((activity) {
            final isSelected = controller.selectedActivities.contains(
              activity.id.toString(),
            );
            return CheckboxListTile(
              title: Text(activity.description),
              value: isSelected,
              onChanged: (bool? value) {
                if (value == true) {
                  controller.selectedActivities.add(activity.id.toString());
                } else {
                  controller.selectedActivities.remove(activity.id.toString());
                }
              },
            );
          }).toList(),
        ],
      );
    });
  }
}

class VisitCard extends StatelessWidget {
  final Visit visit;
  final String customerName;
  final List<String> activities;
  final VoidCallback onTap;

  const VisitCard({
    Key? key,
    required this.visit,
    required this.customerName,
    required this.activities,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      customerName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(visit.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(visit.status),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      visit.status,
                      style: TextStyle(
                        color: _getStatusColor(visit.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(visit.visitDate),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      visit.location,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              if (visit.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  visit.notes,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (activities.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children:
                      activities.take(3).map((activity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            activity,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }).toList(),
                ),
                if (activities.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${activities.length - 3} more',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
              ],
              if (visit.isLocal) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.sync_problem, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      'Stored locally',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
