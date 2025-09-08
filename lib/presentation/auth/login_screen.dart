import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_app/core/constants/app_themes.dart';
import 'package:task_management_app/core/widgets/custom_text_field.dart';
import 'package:task_management_app/core/widgets/password_text_field.dart';
import 'package:task_management_app/core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isEmailValid = false;
  bool showAdditionalFields = false;
  bool isPasswordVisible = false;
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndShowFields() {
    String email = emailController.text.trim();
    bool emailValidation = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);

    setState(() {
      isEmailValid = emailValidation && email.isNotEmpty;
    });

    if (isEmailValid && !showAdditionalFields) {
      setState(() {
        showAdditionalFields = true;
      });
      _animationController.forward();
    } else if (!isEmailValid && showAdditionalFields) {
      _animationController.reverse().then((_) {
        setState(() {
          showAdditionalFields = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.go('/welcome'),
                  child: Icon(
                    BootstrapIcons.arrow_left_circle,
                    color: AppColors.primaryDefault,
                    size: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Text('Welcome Back!', style: AppTextStyles.title),
                        const SizedBox(height: 8),
                        Text(
                          'Your work faster and structured with TuduApp',
                          style: AppTextStyles.bodyText,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  label: 'Email Address',
                  hintText: 'Enter your email address',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  showValidIcon: true,
                  isValid: isEmailValid,
                  borderColor: isEmailValid ? AppColors.primaryDefault : null,
                  borderWidth: isEmailValid ? 2 : 1,
                  onChanged: (value) => _validateAndShowFields(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                if (showAdditionalFields) ...{
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          CustomTextField(
                            label: 'Name',
                            hintText: 'Enter your name',
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          PasswordTextField(
                            label: 'Password',
                            hintText: 'Enter your password',
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                },
                const Spacer(),
                PrimaryButton(
                  text: showAdditionalFields ? 'Sign In' : 'Next',
                  isLoading: isLoading,
                  onPressed:
                      showAdditionalFields
                          ? () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              // Simulate API call
                              await Future.delayed(const Duration(seconds: 2));

                              setState(() {
                                isLoading = false;
                              });

                              // Navigate to dashboard
                              if (mounted) {
                                context.go('/dashboard');
                              }
                            }
                          }
                          : () {
                            _validateAndShowFields();
                          },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
