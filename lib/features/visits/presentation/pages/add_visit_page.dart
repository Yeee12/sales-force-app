import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales_force_automation/core/enums/visit_status.dart';
import 'package:sales_force_automation/features/visits/presentation/controllers/visits_controller.dart';
import 'package:sales_force_automation/features/visits/presentation/widgets/activities_selector.dart';
import 'package:sales_force_automation/features/visits/presentation/widgets/custom_dropdown.dart';


class AddVisitPage extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Visit'),
        actions: [
          Obx(() => controller.isLoading
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
              : TextButton(
            onPressed: controller.createVisit,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    CustomerDropdown(),
                  ],
                ),
              ),
            ),

            // Visit Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visit Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    Obx(() => InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Visit Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('MMM dd, yyyy').format(controller.selectedDate.value),
                        ),
                      ),
                    )),

                    const SizedBox(height: 16),

                    Obx(() => DropdownButtonFormField<VisitStatus>(
                      value: controller.selectedStatus.value,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      items: VisitStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.value),
                        );
                      }).toList(),
                      onChanged: (status) {
                        if (status != null) {
                          controller.selectedStatus.value = status;
                        }
                      },
                    )),

                    const SizedBox(height: 16),

                    // Location
                    TextFormField(
                      controller: controller.locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'Enter visit location',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Location is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: controller.notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        hintText: 'Add visit notes...',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Notes are required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Activities
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activities',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ActivitiesSelector(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.selectedDate.value = picked;
    }
    }
}