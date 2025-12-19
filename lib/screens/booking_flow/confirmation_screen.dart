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
      appBar: const CustomAppBar(title: 'Confirmation'),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Services section
                      Text(
                        'Services',
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
                              // TODO: Service image placeholder
                            ),
                            AppSpacing.w12,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service.name, style: AppTextStyles.labelMedium),
                                Text(
                                  '₹${service.pricePerSlot}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h16,

                      // Selected Time
                      Text(
                        'Selected Time',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      _buildSection(
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            AppSpacing.w12,
                            Text(
                              'Today ${provider.selectedTimeSlot?.label ?? '10:00 AM - 11:00 AM'}',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_down, size: 20),
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
                            const Icon(Icons.person_outline, size: 20),
                            AppSpacing.w12,
                            Text(
                              context.read<AuthProvider>().user?.name ?? 'Karthik Aryan',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_down, size: 20),
                          ],
                        ),
                      ),
                      AppSpacing.h16,

                      // Service Location
                      Text(
                        'Service Location',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      _buildSection(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 20),
                            AppSpacing.w12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.read<LocationProvider>().savedAddress?.houseFlat ?? 'SNN Raj Vista',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  Text(
                                    context.read<LocationProvider>().savedAddress?.fullAddress ?? '312, MG road, Korama...',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 20),
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
                            _buildPaymentRow(service.name, provider.serviceTotal),
                            AppSpacing.h12,
                            _buildPaymentRow('Visiting Fee', provider.visitingFee),
                            AppSpacing.h12,
                            _buildPaymentRow('Tax', provider.tax),
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
                    text: 'Confirm',
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
