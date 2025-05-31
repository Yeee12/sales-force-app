import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_force_automation/core/models/customer_model.dart';
import '../constants/api_constants.dart';
import '../models/activity.dart';
import '../models/visit.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<Customer>> getCustomers() async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.customers}';
    try {
      final response = await http.get(Uri.parse(url), headers: ApiConstants.headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Customer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Activity>> getActivities() async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.activities}';
    try {
      final response = await http.get(Uri.parse(url), headers: ApiConstants.headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Visit>> getVisits() async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.visits}';
    try {
      final response = await http.get(Uri.parse(url), headers: ApiConstants.headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Visit.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load visits: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Visit> createVisit(Visit visit) async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.visits}';
    final body = json.encode(visit.toApiJson());

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: ApiConstants.headers,
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body.trim().isEmpty) {
          return visit;
        }

        try {
          final data = json.decode(response.body);
          if (data is List && data.isNotEmpty) {
            return Visit.fromJson(Map<String, dynamic>.from(data[0]));
          } else if (data is Map) {
            return Visit.fromJson(Map<String, dynamic>.from(data));
          } else {
            return visit;
          }
        } catch (jsonError) {
          return visit;
        }
      } else {
        String errorMessage = 'HTTP ${response.statusCode}';
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
          } catch (e) {
            errorMessage = response.body;
          }
        }
        throw Exception('Failed to create visit: $errorMessage');
      }
    } catch (e) {
      if (e is FormatException && e.toString().contains('Unexpected end of input')) {
        return visit;
      }
      throw Exception('Network error: $e');
    }
  }


  Future<Visit> updateVisit(Visit visit) async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.visits}?id=eq.${visit.id}';
    final body = json.encode(visit.toApiJson());
    try {
      final response = await http.patch(Uri.parse(url), headers: ApiConstants.headers, body: body);
      if (response.statusCode == 200) {
        return visit;
      } else {
        throw Exception('Failed to update visit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
