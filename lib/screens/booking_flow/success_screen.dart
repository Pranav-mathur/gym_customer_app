import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../../models/models.dart';
import '../main_screen.dart';

class SuccessScreen extends StatelessWidget {
  final BookingModel booking;

  const SuccessScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                        (route) => false,
                      );
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                AppSpacing.h16,

                // Success icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.primaryDark,
                    size: 32,
                  ),
                ),
                AppSpacing.h16,
                Text(
                  'Order Confirmed',
                  style: AppTextStyles.heading3,
                ),
                AppSpacing.h24,

                // Gym info card
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.gymName,
                                  style: AppTextStyles.labelLarge,
                                ),
                                AppSpacing.h4,
                                Text(
                                  booking.gymAddress,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions,
                              color: AppColors.primaryGreen,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.h12,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Reach atleast 5mins before your booking time',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      AppSpacing.h16,
                      Text(
                        'Selected Time',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h4,
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          AppSpacing.w8,
                          Text(
                            booking.timeSlot ?? 'Everyday 10:00 AM - 11 AM',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            'Reschedule',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      if (booking.type == BookingType.membership) ...[
                        AppSpacing.h12,
                        Text(
                          'Membership Type',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        AppSpacing.h4,
                        Text(
                          booking.membershipType ?? 'Single Gym',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                      AppSpacing.h12,
                      Text(
                        'Booking For',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h4,
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16),
                          AppSpacing.w8,
                          Text(booking.bookingFor, style: AppTextStyles.bodyMedium),
                        ],
                      ),
                      if (booking.serviceName != null) ...[
                        AppSpacing.h12,
                        Row(
                          children: [
                            Text(
                              'Services',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              booking.serviceName!,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                AppSpacing.h16,

                // Instructions
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.article_outlined, size: 18),
                          AppSpacing.w8,
                          Text('Instructions', style: AppTextStyles.labelMedium),
                        ],
                      ),
                      AppSpacing.h12,
                      Text(
                        '1. Arrive 5mins early to ensure timely entry',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h4,
                      Text(
                        '2. Bring mobile, water bottle and workout shoes,',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.h16,

                // Payment details
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Details',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Amount', style: AppTextStyles.bodyMedium),
                          Text(
                            '₹${booking.totalAmount.toInt()}',
                            style: AppTextStyles.labelMedium,
                          ),
                        ],
                      ),
                      AppSpacing.h8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Paid via',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            booking.paymentMethod ?? 'HDFC Card | xx7354',
                            style: AppTextStyles.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSpacing.h16,

                // Order info
                _buildCard(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(booking.id.substring(0, 8), style: AppTextStyles.bodyMedium),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Placed on',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            AppFormatters.formatDateWithTime(booking.createdAt),
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSpacing.h16,

                // Need support
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need Support?',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.h8,
                      Row(
                        children: [
                          const Icon(Icons.headset_mic_outlined, size: 18),
                          AppSpacing.w8,
                          const Text('Contact Us', style: AppTextStyles.bodyMedium),
                          const Spacer(),
                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
