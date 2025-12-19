import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../providers/providers.dart';
import 'set_location_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isInitialSetup;

  const ProfileScreen({
    super.key,
    this.isInitialSetup = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _selectedGender = user.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<void> _handleUpdate() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _selectedGender,
    );

    if (success && mounted) {
      if (widget.isInitialSetup) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SetLocationScreen(isInitialSetup: true)),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  void _handleSkip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetLocationScreen(isInitialSetup: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.isInitialSetup
          ? null
          : const CustomAppBar(title: 'My Profile'),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.isInitialSetup) ...[
              AppSpacing.h24,
              Text(
                'Profile Details',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
              AppSpacing.h16,
            ],
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingXL),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryOlive.withOpacity(0.3),
                        AppColors.cardBackground,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      AppSpacing.h16,
                      // Profile Image
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.surfaceLight,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.textSecondary,
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h32,

                      // Name Field
                      CustomTextField(
                        label: 'Your Name',
                        hint: 'Enter your name',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                      ),
                      AppSpacing.h20,

                      // Gender Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AppSpacing.h8,
                          Row(
                            children: [
                              Expanded(
                                child: _GenderButton(
                                  label: 'Male',
                                  isSelected: _selectedGender == 'Male',
                                  onTap: () {
                                    setState(() => _selectedGender = 'Male');
                                  },
                                ),
                              ),
                              AppSpacing.w12,
                              Expanded(
                                child: _GenderButton(
                                  label: 'Female',
                                  isSelected: _selectedGender == 'Female',
                                  onTap: () {
                                    setState(() => _selectedGender = 'Female');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      AppSpacing.h20,

                      // Email Field
                      CustomTextField(
                        label: 'Email',
                        hint: 'michael.mitc@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                      ),
                      AppSpacing.h32,

                      // Skip button (only for initial setup)
                      if (widget.isInitialSetup) ...[
                        TextButton(
                          onPressed: _handleSkip,
                          child: Text(
                            'Skip',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Update Button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return PrimaryButton(
                    text: 'Update Profile',
                    isLoading: auth.status == AuthStatus.loading,
                    onPressed: _handleUpdate,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withOpacity(0.1)
              : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
