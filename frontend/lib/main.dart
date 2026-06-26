import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/routes/app_routes.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(const AlalaiApp());
}

class AlalaiApp extends StatelessWidget {
  const AlalaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALALAi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorSchemeSeed: AppColors.primary,
      ),
      home: const AppShell(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
