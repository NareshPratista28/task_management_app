import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/constants/app_themes.dart';
import 'package:task_management_app/core/utils/app_router.dart';

class TuduApp extends StatelessWidget {
  const TuduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp.router(
          title: 'TuduApp',
          theme: ThemeData(
            primarySwatch: AppColors.primarySwatch,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
