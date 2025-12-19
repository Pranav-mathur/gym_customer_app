import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../core/utils/formatters.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'booking_flow/time_slot_screen.dart';
import 'booking_flow/business_hours_sheet.dart';
import 'ratings_reviews_screen.dart';

class GymDetailScreen extends StatefulWidget {
  final GymModel gym;

  const GymDetailScreen({
    super.key,
    required this.gym,
  });

  @override
  State<GymDetailScreen> createState() => _GymDetailScreenState();
}

class _GymDetailScreenState extends State<GymDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button and header
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ],
                      ),
                    ),

                    // Gym name and info
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                      ),
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
                                      widget.gym.name,
                                      style: AppTextStyles.heading3,
                                    ),
                                    AppSpacing.h4,
                                    Text(
                                      widget.gym.fullAddress,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              // Directions button
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.directions,
                                  color: AppColors.primaryGreen,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.h12,
                          // Open status, distance, rating
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: AppColors.primaryGreen,
                                    ),
                                    AppSpacing.w4,
                                    Text(
                                      widget.gym.isOpen ? 'Open' : 'Closed',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                    if (widget.gym.is24x7) ...[
                                      Text(
                                        ' 24x7',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              AppSpacing.w8,
                              const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                              AppSpacing.w8,
                              Icon(Icons.directions_walk, size: 14, color: AppColors.textSecondary),
                              AppSpacing.w4,
                              Text(
                                '${widget.gym.distance.toStringAsFixed(1)} km',
                                style: AppTextStyles.caption,
                              ),
                              AppSpacing.w8,
                              const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                              AppSpacing.w8,
                              Icon(Icons.star, size: 14, color: AppColors.starFilled),
                              AppSpacing.w4,
                              Text(
                                '${widget.gym.rating} (${AppFormatters.formatReviewCount(widget.gym.reviewCount)})',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.h16,

                    // Images
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _imageController,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemCount: widget.gym.images.isEmpty ? 1 : widget.gym.images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.screenPaddingH,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(16),
                              // TODO: Add actual images
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.fitness_center,
                                size: 60,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AppSpacing.h12,

                    // Image indicators
                    if (widget.gym.images.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.gym.images.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? AppColors.primaryGreen
                                  : AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    AppSpacing.h8,

                    // Thumbnail images
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenPaddingH,
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                              border: index == _currentImageIndex
                                  ? Border.all(color: AppColors.primaryGreen, width: 2)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    AppSpacing.h16,

                    // About Us
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About Us', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          AppSpacing.h8,
                          Text(
                            widget.gym.aboutUs ?? 'No description available.',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.h16,
                    const Divider(color: AppColors.border),

                    // Facilities
                    if (widget.gym.facilities.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenPaddingH,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Facilities', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                            AppSpacing.h12,
                            Wrap(
                              spacing: 24,
                              runSpacing: 8,
                              children: widget.gym.facilities.map((f) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check, size: 16, color: AppColors.primaryGreen),
                                    AppSpacing.w4,
                                    Text(f.name, style: AppTextStyles.bodySmall),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.border),
                    ],

                    // Tab bar
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.border.withOpacity(0.3)),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primaryGreen,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.primaryGreen,
                        indicatorWeight: 2,
                        tabs: const [
                          Tab(text: 'Services'),
                          Tab(text: 'Reviews'),
                          Tab(text: 'Equipments'),
                        ],
                      ),
                    ),

                    // Tab content
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildServicesTab(),
                          _buildReviewsTab(),
                          _buildEquipmentsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  text: 'Book Gym Membership',
                  onPressed: () {
                    _showBusinessHoursSheet();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTab() {
    if (widget.gym.services.isEmpty) {
      return const Center(
        child: Text('No services available', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      itemCount: widget.gym.services.length,
      itemBuilder: (context, index) {
        final service = widget.gym.services[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Service image placeholder
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sports_gymnastics, color: AppColors.textSecondary),
              ),
              AppSpacing.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: AppTextStyles.labelMedium),
                    Text(
                      '${service.schedule ?? 'Every day'}\n${service.timing ?? ''}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<BookingProvider>().initializeBooking(widget.gym);
                  context.read<BookingProvider>().selectService(service);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TimeSlotScreen(
                        gym: widget.gym,
                        service: service,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Book Slot >',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGreen),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RatingsReviewsScreen(
              gymId: widget.gym.id,
              gymName: widget.gym.name,
              rating: widget.gym.rating,
              reviewCount: widget.gym.reviewCount,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ratings & Reviews', style: AppTextStyles.labelMedium),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.starFilled),
                    AppSpacing.w4,
                    Text(
                      '${widget.gym.rating} (${AppFormatters.formatReviewCount(widget.gym.reviewCount)})',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGreen),
                    ),
                  ],
                ),
              ],
            ),
            AppSpacing.h16,
            Expanded(
              child: Center(
                child: Text(
                  'Tap to see all reviews',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentsTab() {
    if (widget.gym.equipments.isEmpty) {
      return const Center(
        child: Text('No equipment information', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: widget.gym.equipments.length,
      itemBuilder: (context, index) {
        final equipment = widget.gym.equipments[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fitness_center, color: AppColors.textSecondary),
              ),
              AppSpacing.h8,
              Text(
                equipment.name,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBusinessHoursSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BusinessHoursSheet(
        gymName: widget.gym.name,
        businessHours: widget.gym.businessHours,
        onContinue: () {
          Navigator.pop(context);
          // Navigate to subscription screen
          // For now, navigate to time slot with membership type
        },
      ),
    );
  }
}
