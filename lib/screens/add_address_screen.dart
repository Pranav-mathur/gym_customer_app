import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import 'main_screen.dart';

class AddAddressScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? locality;

  const AddAddressScreen({
    super.key,
    this.latitude,
    this.longitude,
    this.locality,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _houseFlatController = TextEditingController();
  final _roadAreaController = TextEditingController();
  final _streetCityController = TextEditingController();
  String _selectedLabel = 'Other';
  final List<String> _labels = ['Home', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.locality != null) {
      _streetCityController.text = widget.locality!;
    }
  }

  @override
  void dispose() {
    _houseFlatController.dispose();
    _roadAreaController.dispose();
    _streetCityController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_houseFlatController.text.isEmpty ||
        _roadAreaController.text.isEmpty ||
        _streetCityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final address = AddressModel(
      houseFlat: _houseFlatController.text.trim(),
      roadArea: _roadAreaController.text.trim(),
      streetCity: _streetCityController.text.trim(),
      label: _selectedLabel,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    context.read<LocationProvider>().saveAddress(address);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Add Address'),
      body: Column(
        children: [
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
                      AppColors.primaryOlive.withOpacity(0.2),
                      AppColors.cardBackground,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Location icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textPrimary,
                        size: 28,
                      ),
                    ),
                    AppSpacing.h24,

                    // House/Flat/Block
                    CustomTextField(
                      label: 'House/Flat/Block',
                      hint: 'Enter house/flat/block',
                      controller: _houseFlatController,
                      textInputAction: TextInputAction.next,
                    ),
                    AppSpacing.h20,

                    // Apartment/Road/Area
                    CustomTextField(
                      label: 'Apartment/Road/Area',
                      hint: 'Enter apartment/road/area',
                      controller: _roadAreaController,
                      textInputAction: TextInputAction.next,
                    ),
                    AppSpacing.h20,

                    // Street and City
                    CustomTextField(
                      label: 'Street and City',
                      hint: 'Enter street and city',
                      controller: _streetCityController,
                      textInputAction: TextInputAction.done,
                      maxLines: 2,
                    ),
                    AppSpacing.h20,

                    // Save address as
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Save address as',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AppSpacing.h12,
                        Row(
                          children: [
                            _buildLabelChip('Other'),
                            // Add more if needed
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Clear the label
                                setState(() => _selectedLabel = 'Other');
                              },
                              child: const Icon(
                                Icons.cancel_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            child: PrimaryButton(
              text: 'Save Address',
              onPressed: _saveAddress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelChip(String label) {
    final isSelected = _selectedLabel == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedLabel = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withOpacity(0.1)
              : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
