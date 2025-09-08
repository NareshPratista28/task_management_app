import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/app.dart';
import 'package:task_management_app/core/services/auth_service.dart';
import 'package:task_management_app/firebase_options.dart';
import 'package:task_management_app/providers/auth_provider.dart';
import 'package:task_management_app/providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();
  await authService.initializeGoogleSignIn();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()..initializeAuth()),

        // Navigation Provider
        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        // Add more providers here as needed
      ],
      child: const TuduApp(),
    );
  }
}
