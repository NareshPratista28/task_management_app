import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_themes.dart';
import 'package:task_management_app/core/utils/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
