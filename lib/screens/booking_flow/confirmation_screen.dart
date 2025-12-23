import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import 'success_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final GymModel gym;
  final ServiceModel service;

  const ConfirmationScreen({
    super.key,
    required this.gym,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Booking Confirmation'),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          final selectedDate = provider.selectedDate ?? DateTime.now();
          final selectedSlot = provider.selectedTimeSlot;
          final slotCount = provider.slotCount;

          // Format date
          final dateStr = '${_getDayName(selectedDate.weekday)}, ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}';

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gym Details
                      Text(
                        'Gym Details',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      _buildSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: gym.images.isNotEmpty
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      gym.images.first,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stack) {
                                        return const Icon(
                                          Icons.fitness_center,
                                          color: AppColors.textSecondary,
                                        );
                                      },
                                    ),
                                  )
                                      : const Icon(
                                    Icons.fitness_center,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                AppSpacing.w12,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gym.name,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      AppSpacing.h4,
                                      Text(
                                        gym.locality,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h16,

                      // Service Details
                      Text(
                        'Service',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      _buildSection(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: service.image != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  service.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) {
                                    return const Icon(
                                      Icons.fitness_center,
                                      color: AppColors.textSecondary,
                                      size: 24,
                                    );
                                  },
                                ),
                              )
                                  : const Icon(
                                Icons.fitness_center,
                                color: AppColors.textSecondary,
                                size: 24,
                              ),
                            ),
                            AppSpacing.w12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(service.name, style: AppTextStyles.labelMedium),
                                  AppSpacing.h4,
                                  Text(
                                    '₹${service.pricePerSlot} per slot',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h16,

                      // Date & Time
                      Text(
                        'Date & Time',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      _buildSection(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20, color: AppColors.primaryGreen),
                                AppSpacing.w12,
                                Expanded(
                                  child: Text(
                                    dateStr,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            if (selectedSlot != null) ...[
                              AppSpacing.h12,
                              const Divider(color: AppColors.border),
                              AppSpacing.h12,
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 20, color: AppColors.primaryGreen),
                                  AppSpacing.w12,
                                  Expanded(
                                    child: Text(
                                      selectedSlot.label,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            AppSpacing.h12,
                            const Divider(color: AppColors.border),
                            AppSpacing.h12,
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 20, color: AppColors.primaryGreen),
                                AppSpacing.w12,
                                Expanded(
                                  child: Text(
                                    '$slotCount ${slotCount > 1 ? "slots" : "slot"} selected',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h16,

                      // Booking For
                      Text(
                        'Booking For',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      _buildSection(
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline, size: 20, color: AppColors.primaryGreen),
                            AppSpacing.w12,
                            Text(
                              context.read<AuthProvider>().user?.name ?? 'User',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h24,

                      // Payment Breakup
                      Text(
                        'Payment Breakup',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      _buildSection(
                        child: Column(
                          children: [
                            _buildPaymentRow(
                              '${service.name} (x$slotCount)',
                              provider.serviceTotal,
                            ),
                            AppSpacing.h12,
                            _buildPaymentRow('Visiting Fee', provider.visitingFee),
                            AppSpacing.h12,
                            _buildPaymentRow('Tax (18%)', provider.tax),
                            AppSpacing.h12,
                            const Divider(color: AppColors.border),
                            AppSpacing.h12,
                            _buildPaymentRow(
                              'Total Amount',
                              provider.totalAmount,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Confirm button
              Container(
                padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                decoration: const BoxDecoration(
                  color: AppColors.cardBackground,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: SafeArea(
                  top: false,
                  child: PrimaryButton(
                    text: 'Confirm & Pay ₹${provider.totalAmount.toInt()}',
                    isLoading: provider.isLoading,
                    onPressed: () async {
                      provider.setBookingFor(
                        context.read<AuthProvider>().user?.name ?? 'Guest',
                      );
                      final booking = await provider.createServiceBooking();
                      if (booking != null && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuccessScreen(booking: booking),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  Widget _buildPaymentRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTextStyles.labelMedium : AppTextStyles.bodyMedium,
        ),
        Text(
          '₹${amount.toInt()}',
          style: isBold ? AppTextStyles.labelLarge : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}