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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              orElse: () => plans.isNotEmpty && plans.length > 2 ? plans[2] : plans.first,
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
                        // Hero image with dumbbell icon
                        Container(
                          height: screenHeight * 0.25,
                          width: double.infinity,
                          margin: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/gym_bg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryGreen.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.fitness_center,
                                  size: 50,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // Subscription type selection title
                        Text(
                          'Select Subscription Type',
                          style: AppTextStyles.heading4.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Type cards - Single Gym & Multi Gym
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: Row(
                            children: [
                              // Single Gym Card
                              Expanded(
                                child: _buildTypeCard(
                                  title: 'Single Gym',
                                  subtitle: 'Access only to',
                                  detail: 'Zinga Fitness & Training',
                                  isSelected: _selectedType == 'single_gym',
                                  onTap: () => setState(() => _selectedType = 'single_gym'),
                                  showRecommended: false,
                                  screenWidth: screenWidth,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              // Multi Gym Card
                              Expanded(
                                child: _buildTypeCard(
                                  title: 'Multi Gym',
                                  subtitle: 'Access to all',
                                  detail: '112 Pro Gyms',
                                  isSelected: _selectedType == 'multi_gym',
                                  onTap: () => setState(() => _selectedType = 'multi_gym'),
                                  showRecommended: true,
                                  screenWidth: screenWidth,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Duration selection title
                        Text(
                          'Select Subscription Type',
                          style: AppTextStyles.heading4.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Duration cards - horizontal scroll
                        SizedBox(
                          height: screenHeight * 0.13,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            itemCount: plans.length,
                            itemBuilder: (context, index) {
                              final plan = plans[index];
                              final isSelected = selectedPlan.id == plan.id;
                              return Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.025),
                                child: _buildDurationCard(
                                  plan: plan,
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() => _selectedDuration = plan.duration);
                                    bookingProvider.selectPlan(plan);
                                  },
                                  screenWidth: screenWidth,
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),

                // Bottom section with summary and subscribe button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: const Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Summary row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedType == 'multi_gym' ? 'Multi Gym' : 'Single Gym',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              selectedPlan.durationLabel,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              '₹${selectedPlan.price}',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.015),

                        // Subscribe button
                        PrimaryButton(
                          text: 'Subscribe',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Subscription flow coming soon')),
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.01),

                        // Renewal text
                        Text(
                          'Next renewal will be on ${_getNextRenewalDate(selectedPlan.duration)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
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

  Widget _buildTypeCard({
    required String title,
    required String subtitle,
    required String detail,
    required bool isSelected,
    required VoidCallback onTap,
    required bool showRecommended,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenWidth * 0.045,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryOlive.withOpacity(0.4),
                  AppColors.primaryGreen.withOpacity(0.15),
                ],
              )
                  : null,
              color: isSelected ? null : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primaryGreen,
                    size: screenWidth * 0.065,
                  )
                else
                  Container(
                    width: screenWidth * 0.06,
                    height: screenWidth * 0.06,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textSecondary.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                SizedBox(height: screenWidth * 0.025),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: screenWidth * 0.035),

                // Divider
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.border.withOpacity(0.5),
                ),
                SizedBox(height: screenWidth * 0.025),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenWidth * 0.01),

                // Detail (gym name/count)
                Text(
                  detail,
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // RECOMMENDED badge
          if (showRecommended)
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'RECOMMENDED',
                    style: TextStyle(
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

  Widget _buildDurationCard({
    required SubscriptionModel plan,
    required bool isSelected,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.22,
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.025,
          horizontal: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withOpacity(0.1)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkmark for selected
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
                size: screenWidth * 0.05,
              )
            else
              SizedBox(height: screenWidth * 0.05),

            SizedBox(height: screenWidth * 0.01),

            // Duration label
            Text(
              plan.durationLabel,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenWidth * 0.008),

            // Price
            Text(
              '₹ ${plan.price}',
              style: TextStyle(
                color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            // Original price (strikethrough)
            if (plan.originalPrice != null) ...[
              SizedBox(height: screenWidth * 0.005),
              Text(
                '${plan.originalPrice}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.textSecondary,
                ),
              ),
            ],
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