import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_force_automation/features/visits/presentation/widgets/statistics_card.dart';
import 'package:sales_force_automation/features/visits/presentation/widgets/status_chart.dart';
import '../controllers/visits_controller.dart';

class VisitStatisticsPage extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Visit Statistics'),
        ),
        body: Obx(() {
          if (controller.isLoading && controller.visits.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: StatisticsCard(
                      title: 'Total Visits',
                      value: controller.totalVisits.toString(),
                      icon: Icons.business_center,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCard(
                      title: 'Completed',
                      value: controller.completedVisits.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: StatisticsCard(
                      title: 'Pending',
                      value: controller.pendingVisits.toString(),
                      icon: Icons.hourglass_empty,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCard(
                      title: 'Cancelled',
                      value: controller.cancelledVisits.toString(),
                      icon: Icons.schedule,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Completion Rate
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completion Rate',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: controller.completionRate / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                controller.completionRate >= 80
                                    ? Colors.green
                                    : controller.completionRate >= 60
                                    ? Colors.orange
                                    : Colors.red,
                              ),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${controller.completionRate.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (controller.totalVisits > 0)
                StatusChart(),
            ],
          );
        }),
        );
    }
}