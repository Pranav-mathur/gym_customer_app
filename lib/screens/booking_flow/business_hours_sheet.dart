import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/widgets/widgets.dart';
import '../../models/models.dart';

class BusinessHoursSheet extends StatelessWidget {
  final String gymName;
  final List<BusinessHours> businessHours;
  final VoidCallback onContinue;

  const BusinessHoursSheet({
    super.key,
    required this.gymName,
    required this.businessHours,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final hours = businessHours.isNotEmpty
        ? businessHours
        : _getDefaultHours();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOlive.withOpacity(0.5),
            AppColors.cardBackground,
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            gymName,
            style: AppTextStyles.heading4,
          ),
          AppSpacing.h24,

          ...hours.map((h) => _buildDayRow(h)).toList(),

          AppSpacing.h24,
          PrimaryButton(
            text: 'Continue',
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(BusinessHours hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              hours.day,
              style: AppTextStyles.bodyMedium.copyWith(
                color: hours.isOpen
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          AppSpacing.w8,
          Container(
            width: 36,
            height: 20,
            decoration: BoxDecoration(
              color: hours.isOpen
                  ? AppColors.primaryGreen
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  hours.isOpen ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: hours.isOpen
                      ? AppColors.primaryDark
                      : AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const Spacer(),
          if (hours.isOpen) ...[
            _buildTimeBox(hours.openTime ?? '9:00 AM'),
            AppSpacing.w12,
            _buildTimeBox(hours.closeTime ?? '5:00 PM'),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        time,
        style: AppTextStyles.bodySmall,
      ),
    );
  }

  List<BusinessHours> _getDefaultHours() {
    return [
      BusinessHours(day: 'Mon', isOpen: true, openTime: '9:00 AM', closeTime: '5:00 PM'),
      BusinessHours(day: 'Tue', isOpen: true, openTime: '9:00 AM', closeTime: '5:00 PM'),
      BusinessHours(day: 'Wed', isOpen: true, openTime: '9:00 AM', closeTime: '5:00 PM'),
      BusinessHours(day: 'Thu', isOpen: true, openTime: '9:00 AM', closeTime: '5:00 PM'),
      BusinessHours(day: 'Fri', isOpen: true, openTime: '9:00 AM', closeTime: '5:00 PM'),
      BusinessHours(day: 'Sat', isOpen: false),
      BusinessHours(day: 'Sun', isOpen: false),
    ];
  }
}
