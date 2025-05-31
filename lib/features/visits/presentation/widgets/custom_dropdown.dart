import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/visits_controller.dart';

class CustomerDropdown extends GetView<VisitsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.customers.isEmpty) {
        return const Text('No customers available');
      }

      return DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          labelText: 'Select Customer',
          hintText: 'Choose a customer for this visit',
        ),
        value: controller.selectedCustomerId.value,
        isExpanded: true,
        items:
            controller.customers.map((customer) {
              return DropdownMenuItem<int>(
                value: customer.id,
                child: Text(customer.name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
        onChanged: (int? value) {
          controller.selectedCustomerId.value = value;
          if (value != null) {
            final selectedCustomer = controller.customers.firstWhereOrNull(
              (c) => c.id == value,
            );
            if (selectedCustomer != null) {
              controller.customerController.text = selectedCustomer.name;
            }
          } else {
            controller.customerController.clear();
          }
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a customer';
          }
          return null;
        },
      );
    });
  }
}
