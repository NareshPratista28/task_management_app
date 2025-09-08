import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/constants/app_themes.dart';
import 'package:task_management_app/core/widgets/primary_button.dart';
import 'package:task_management_app/providers/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        context.go('/home');
      }
    });
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome ${authProvider.currentUser?.displayName ?? 'User'}!',
          ),
          backgroundColor: AppColors.primaryDefault,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to home
      context.go('/home');
    } else if (authProvider.errorMessage != null && mounted) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );

      // Clear error after showing
      authProvider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Welcome to ', style: AppTextStyles.title),
                      TextSpan(
                        text: 'TuduApp',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.primaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 38),
              Image.asset(
                'assets/welcome/welcome.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
              PrimaryButton(
                text: 'Continue with email',
                onPressed: () {
                  context.go('/login');
                },
                icon: BootstrapIcons.envelope_fill,
              ),
              const SizedBox(height: 16),
              Text('or continue with', style: AppTextStyles.smallText),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return PrimaryButton(
                          text: 'Google',
                          textColor: Colors.black,
                          onPressed: _handleGoogleSignIn,
                          isLoading: authProvider.isLoading,
                          icon: BootstrapIcons.google,
                          backgroundColor: Colors.grey[100],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Facebook',
                      textColor: Colors.black,
                      onPressed: () {},
                      icon: BootstrapIcons.facebook,
                      backgroundColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
