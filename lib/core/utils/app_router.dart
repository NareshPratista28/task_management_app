import 'package:go_router/go_router.dart';
import 'package:task_management_app/presentation/auth/welcome_screen.dart';
import 'package:task_management_app/presentation/splash/splash_screen.dart';
import 'package:task_management_app/presentation/onboarding/onboarding_screen..dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
  ],
);
