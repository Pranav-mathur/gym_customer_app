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
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.all(AppDimensions.screenPaddingH),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryOlive.withOpacity(0.3),
                                AppColors.primaryGreen.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                size: 60,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),

                        AppSpacing.h16,

                        // Subscription type selection
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPaddingH,
                          ),
                          child: Column(
                            children: [
                              // Title
                              Text(
                                'Select Subscription Type',
                                style: AppTextStyles.heading4,
                              ),
                              AppSpacing.h16,

                              // Type cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTypeCard(
                                      'Single Gym',
                                      'Access only to',
                                      'Zinga Fitness & Training',
                                      _selectedType == 'single_gym',
                                          () => setState(() => _selectedType = 'single_gym'),
                                      showRecommended: false,
                                    ),
                                  ),
                                  AppSpacing.w12,
                                  Expanded(
                                    child: _buildTypeCard(
                                      'Multi Gym',
                                      'Access to all',
                                      '112 Pro Gyms',
                                      _selectedType == 'multi_gym',
                                          () => setState(() => _selectedType = 'multi_gym'),
                                      showRecommended: true,
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
                              // Title (FIXED: Changed from duplicate "Select Subscription Type")
                              Text(
                                'Select Duration',
                                style: AppTextStyles.heading4,
                              ),
                              AppSpacing.h16,

                              // Duration chips (FIXED: Proper height and constraints)
                              SizedBox(
                                height: 100,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: plans.length,
                                  separatorBuilder: (context, index) => AppSpacing.w12,
                                  itemBuilder: (context, index) {
                                    final plan = plans[index];
                                    final isSelected = selectedPlan.id == plan.id;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedDuration = plan.duration);
                                        bookingProvider.selectPlan(plan);
                                      },
                                      child: Container(
                                        width: 85,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryGreen.withOpacity(0.1)
                                              : AppColors.cardBackground,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primaryGreen
                                                : AppColors.border,
                                            width: isSelected ? 2 : 1,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (isSelected)
                                              const Icon(
                                                Icons.check_circle,
                                                color: AppColors.primaryGreen,
                                                size: 20,
                                              )
                                            else
                                              const Icon(
                                                Icons.circle_outlined,
                                                color: AppColors.border,
                                                size: 20,
                                              ),
                                            AppSpacing.h8,
                                            Text(
                                              plan.durationLabel,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: isSelected
                                                    ? AppColors.primaryGreen
                                                    : AppColors.textSecondary,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            AppSpacing.h4,
                                            Text(
                                              '₹${plan.price}',
                                              style: AppTextStyles.labelMedium.copyWith(
                                                color: isSelected
                                                    ? AppColors.primaryGreen
                                                    : AppColors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (plan.originalPrice != null) ...[
                                              AppSpacing.h4,
                                              Text(
                                                '₹${plan.originalPrice}',
                                                style: AppTextStyles.caption.copyWith(
                                                  color: AppColors.textSecondary,
                                                  decoration: TextDecoration.lineThrough,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
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
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '•',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                              Text(
                                selectedPlan.durationLabel,
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '•',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                              Text(
                                '₹${selectedPlan.price}',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.h24,
                      ],
                    ),
                  ),
                ),

                // Subscribe button
                Container(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  decoration: const BoxDecoration(
                    color: AppColors.cardBackground,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
      VoidCallback onTap, {
        required bool showRecommended,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Selection indicator
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryGreen,
                    size: 28,
                  )
                else
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.border,
                        width: 2,
                      ),
                    ),
                  ),
                AppSpacing.h12,

                // Title
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.h8,

                // Subtitle
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Detail
                Text(
                  detail,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryGreen,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),

          // RECOMMENDED badge (FIXED: Properly positioned)
          if (showRecommended)
            Positioned(
              top: -8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'RECOMMENDED',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
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