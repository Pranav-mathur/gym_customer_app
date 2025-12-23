import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../core/utils/formatters.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import 'set_location_screen.dart';
import 'notification_screen.dart';
import 'side_menu_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedType = 'multi_gym';
  String? _selectedDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: const SideMenuScreen(),
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            final plans = bookingProvider.getPlansForType(_selectedType);
            final selectedPlan = plans.firstWhere(
                  (p) => p.duration == _selectedDuration,
              orElse: () => plans.isNotEmpty ? plans[2] : plans.first, // Default to 1 month
            );

            return Column(
              children: [
                // App bar
                Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                    return HomeAppBar(
                      location: locationProvider.displayLocation,
                      address: locationProvider.displayAddress,
                      onLocationTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SetLocationScreen(),
                          ),
                        );
                      },
                      onNotificationTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                      onMenuTap: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    );
                  },
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Hero image placeholder
                        Container(
                          height: 150,
                          width: double.infinity,
                          margin: const EdgeInsets.all(AppDimensions.screenPaddingH),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                size: 40,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),

                        // Subscription type selection
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPaddingH,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Select Subscription Type',
                                style: AppTextStyles.heading4,
                              ),
                              AppSpacing.h16,
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTypeCard(
                                      'Single Gym',
                                      'Access only to',
                                      'Zinga Fitness & Training',
                                      _selectedType == 'single_gym',
                                          () => setState(() => _selectedType = 'single_gym'),
                                    ),
                                  ),
                                  AppSpacing.w12,
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        _buildTypeCard(
                                          'Multi Gym',
                                          'Access to all',
                                          '112 Pro Gyms',
                                          _selectedType == 'multi_gym',
                                              () => setState(() => _selectedType = 'multi_gym'),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'RECOMMENDED',
                                              style: AppTextStyles.caption.copyWith(
                                                color: AppColors.primaryDark,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
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
                        AppSpacing.h24,

                        // Duration selection
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPaddingH,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Select Subscription Type',
                                style: AppTextStyles.heading4,
                              ),
                              AppSpacing.h16,
                              SizedBox(
                                height: 90,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: plans.length,
                                  itemBuilder: (context, index) {
                                    final plan = plans[index];
                                    final isSelected = selectedPlan.id == plan.id;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedDuration = plan.duration);
                                        bookingProvider.selectPlan(plan);
                                      },
                                      child: Container(
                                        width: 80,
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryGreen.withOpacity(0.1)
                                              : AppColors.cardBackground,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primaryGreen
                                                : AppColors.border,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (isSelected)
                                              const Icon(
                                                Icons.check_circle,
                                                color: AppColors.primaryGreen,
                                                size: 16,
                                              ),
                                            Text(
                                              plan.durationLabel,
                                              style: AppTextStyles.caption.copyWith(
                                                color: isSelected
                                                    ? AppColors.primaryGreen
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                            AppSpacing.h4,
                                            Text(
                                              '₹${plan.price}',
                                              style: AppTextStyles.labelMedium.copyWith(
                                                color: isSelected
                                                    ? AppColors.primaryGreen
                                                    : AppColors.textPrimary,
                                              ),
                                            ),
                                            if (plan.originalPrice != null)
                                              Text(
                                                '${plan.originalPrice}',
                                                style: AppTextStyles.caption.copyWith(
                                                  color: AppColors.textSecondary,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.h24,

                        // Summary
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPaddingH,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedType == 'multi_gym' ? 'Multi Gym' : 'Single Gym',
                                style: AppTextStyles.labelMedium,
                              ),
                              const Text(' • ', style: TextStyle(color: AppColors.textSecondary)),
                              Text(
                                selectedPlan.durationLabel,
                                style: AppTextStyles.labelMedium,
                              ),
                              const Text(' • ', style: TextStyle(color: AppColors.textSecondary)),
                              Text(
                                '₹${selectedPlan.price}',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Subscribe button
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'Subscribe',
                        onPressed: () {
                          // Handle subscription
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Subscription flow coming soon')),
                          );
                        },
                      ),
                      AppSpacing.h8,
                      Text(
                        'Next renewal will be on ${_getNextRenewalDate(selectedPlan.duration)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypeCard(
      String title,
      String subtitle,
      String detail,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withOpacity(0.1)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryGreen)
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
              ),
            AppSpacing.h12,
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
              ),
            ),
            AppSpacing.h4,
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              detail,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNextRenewalDate(String duration) {
    final now = DateTime.now();
    DateTime renewalDate;

    switch (duration) {
      case '1_day':
        renewalDate = now.add(const Duration(days: 1));
        break;
      case '1_week':
        renewalDate = now.add(const Duration(days: 7));
        break;
      case '1_month':
        renewalDate = DateTime(now.year, now.month + 1, now.day);
        break;
      case '3_months':
        renewalDate = DateTime(now.year, now.month + 3, now.day);
        break;
      case '1_year':
        renewalDate = DateTime(now.year + 1, now.month, now.day);
        break;
      default:
        renewalDate = now.add(const Duration(days: 30));
    }

    return AppFormatters.formatDate(renewalDate);
  }
}