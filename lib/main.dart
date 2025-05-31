import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_force_automation/core/route/app_binding.dart';
import 'package:sales_force_automation/core/route/app_pages.dart';
import 'package:sales_force_automation/core/route/app_routes.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print('Env loaded successfully');
  } catch (e) {
    print('Error loading .env file: $e');
  }
  await ServiceLocator.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      title: 'Visits Tracker',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.VISITS,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
