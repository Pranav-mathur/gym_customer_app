import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../providers/booking_provider.dart';

class SubscriptionSuccessScreen extends StatelessWidget {
  final String membershipId;
  final String subscriptionType; // single_gym or multi_gym
  final String? gymName; // Only for single_gym

  const SubscriptionSuccessScreen({
    super.key,
    required this.membershipId,
    required this.subscriptionType,
    this.gymName,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Subscription Confirmed',
              showBackButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),

                    // Success icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                        size: 80,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Success message
                    Text(
                      'Subscription Activated!',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      subscriptionType == 'single_gym'
                          ? 'Your membership for ${gymName ?? 'the gym'} is now active'
                          : 'Your multi-gym membership is now active',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Membership details card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          // Membership ID
                          _buildDetailRow(
                            'Membership ID',
                            membershipId,
                            Icons.card_membership,
                          ),
                          const Divider(height: 24),

                          // Type
                          _buildDetailRow(
                            'Type',
                            subscriptionType == 'single_gym' ? 'Single Gym' : 'Multi Gym',
                            Icons.fitness_center,
                          ),
                          const Divider(height: 24),

                          // Duration
                          _buildDetailRow(
                            'Validity',
                            '30 Days',
                            Icons.access_time,
                          ),
                          if (gymName != null && subscriptionType == 'single_gym') ...[
                            const Divider(height: 24),
                            _buildDetailRow(
                              'Gym',
                              gymName!,
                              Icons.location_on,
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Benefits
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Benefits',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildBenefitItem('No visiting fees at ${subscriptionType == 'single_gym' ? 'this gym' : 'any gym'}'),
                          const SizedBox(height: 12),
                          _buildBenefitItem('Access all services'),
                          const SizedBox(height: 12),
                          _buildBenefitItem('Priority slot booking'),
                          const SizedBox(height: 12),
                          _buildBenefitItem('30-day validity'),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Action buttons
                    PrimaryButton(
                      text: 'Book a Service',
                      onPressed: () {
                        // Navigate to home/gym listing
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),

                    const SizedBox(height: 12),

                    SecondaryButton(
                      text: 'View My Memberships',
                      onPressed: () {
                        // Navigate to memberships/bookings screen
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // TODO: Navigate to memberships tab
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.primaryGreen,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}