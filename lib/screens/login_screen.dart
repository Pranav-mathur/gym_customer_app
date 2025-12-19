import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../providers/providers.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    // Format phone number with country code
    final phoneNumber = _phoneController.text.trim();
    final formattedPhone = '+91$phoneNumber';

    try {
      final success = await authProvider.sendOtp(phoneNumber);

      if (success && mounted) {
        // Clear any previous errors
        authProvider.clearError();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('OTP sent successfully!'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              phoneNumber: formattedPhone,
            ),
          ),
        );
      } else if (mounted && authProvider.error != null) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image placeholder
          Positioned.fill(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        // TODO: Add background image
                        // Replace with: Image.asset('assets/images/login_bg.png', fit: BoxFit.cover)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.06),
                          // Logo placeholder
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              // TODO: Add logo image
                              // Replace with actual logo
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'B',
                                      style: TextStyle(
                                        color: AppColors.primaryDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                AppSpacing.w8,
                                Text(
                                  'BookMyFit',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.h4,
                          Text(
                            'Tagline goes here',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 4, child: Container()),
                ],
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryOlive.withOpacity(0.95),
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.h16,
                        Center(
                          child: Text(
                            'Login/Sign Up',
                            style: AppTextStyles.heading4.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        AppSpacing.h24,
                        Text(
                          'Phone Number',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.h8,
                        // Phone number input with country code prefix
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Country code prefix
                            Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.inputBackground.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.inputRadius,
                                ),
                                border: Border.all(
                                  color: AppColors.inputBorder,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '+91',
                                  style: AppTextStyles.inputText.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Phone number input
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                style: AppTextStyles.inputText,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Enter Phone Number',
                                  counterText: '',
                                  filled: true,
                                  fillColor: AppColors.inputBackground.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.inputRadius,
                                    ),
                                    borderSide: const BorderSide(
                                      color: AppColors.inputBorder,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.inputRadius,
                                    ),
                                    borderSide: const BorderSide(
                                      color: AppColors.inputBorder,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.inputRadius,
                                    ),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryGreen,
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.inputRadius,
                                    ),
                                    borderSide: const BorderSide(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  if (value.length != 10) {
                                    return 'Enter valid 10-digit number';
                                  }
                                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                    return 'Enter valid Indian number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.h24,
                        Consumer<AuthProvider>(
                          builder: (context, auth, child) {
                            return PrimaryButton(
                              text: 'Continue',
                              isLoading: auth.status == AuthStatus.loading,
                              onPressed: auth.status == AuthStatus.loading
                                  ? null
                                  : _handleContinue,
                            );
                          },
                        ),
                        AppSpacing.h16,
                        // Terms and conditions text
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'By continuing, you agree to our Terms of Service and Privacy Policy',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.h8,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}