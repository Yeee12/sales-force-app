import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['SUPABASE_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['SUPABASE_API_KEY'] ?? '';

  static const String customers = '/customers';
  static const String activities = '/activities';
  static const String visits = '/visits';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'apikey': apiKey,
    'Authorization': 'Bearer $apiKey',
  };
}
