import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import 'gym_detail_screen.dart';
import 'map_view_screen.dart';
import 'filter_screen.dart';
import 'notification_screen.dart';
import 'side_menu_screen.dart';
import 'set_location_screen.dart';
import 'review_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: const SideMenuScreen(),
      body: SafeArea(
        child: Column(
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
                  onMenuTap: _openDrawer,
                );
              },
            ),

            // Hero image placeholder
            Container(
              height: size.height * 0.22,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                // TODO: Add hero image
              ),
              child: const Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 60,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            AppSpacing.h16,

            // Gym count
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPaddingH,
                  ),
                  child: Text(
                    '${provider.totalGyms} Gyms near you',
                    style: AppTextStyles.heading4,
                  ),
                );
              },
            ),
            AppSpacing.h12,

            // Search and filter row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          context.read<HomeProvider>().searchGyms(value);
                        },
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Search gym',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.w8,
                  _buildIconButton(
                    Icons.tune,
                    onTap: () => _showFilterSheet(context),
                  ),
                  AppSpacing.w8,
                  _buildIconButton(
                    Icons.sort,
                    onTap: () => _showSortSheet(context),
                  ),
                ],
              ),
            ),
            AppSpacing.h16,

            // Gym list
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    );
                  }

                  if (provider.gyms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          AppSpacing.h16,
                          Text(
                            'No gyms found',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenPaddingH,
                        ),
                        itemCount: provider.gyms.length,
                        itemBuilder: (context, index) {
                          final gym = provider.gyms[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GymCard(
                              name: gym.name,
                              location: gym.locality,
                              distance: gym.distance,
                              rating: gym.rating,
                              reviewCount: gym.reviewCount,
                              price: gym.pricePerDay,
                              is24x7: gym.is24x7,
                              hasTrainer: gym.hasTrainer,
                              imageUrl: gym.images.isNotEmpty
                                  ? gym.images.first
                                  : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GymDetailScreen(gym: gym),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

                      // Map view toggle button
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _buildMapViewButton(context),
                        ),
                      ),

                      // Rate prompt
                      Consumer<AttendanceProvider>(
                        builder: (context, attendanceProvider, child) {
                          if (!attendanceProvider.showRatePrompt) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            bottom: 70,
                            left: AppDimensions.screenPaddingH,
                            right: AppDimensions.screenPaddingH,
                            child: _buildRatePrompt(
                              context,
                              attendanceProvider.lastVisitedGymId ?? '',
                              attendanceProvider.lastVisitedGymName ?? '',
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }

  Widget _buildMapViewButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapViewScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.primaryDark,
              size: 18,
            ),
            AppSpacing.w8,
            Text(
              'Map View',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatePrompt(BuildContext context, String gymId, String gymName) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Gym image placeholder
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  gymName,
                  style: AppTextStyles.labelMedium,
                ),
                Text(
                  'How was your experience?',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<AttendanceProvider>().dismissRatePrompt();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewScreen(
                    gymId: gymId,
                    gymName: gymName,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Rate',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FilterSheet(),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const SortSheet(),
    );
  }
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Facilities', 'Fee', 'Distance', 'Rating'];
  Set<String> _selectedFacilities = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = context.read<LocationProvider>();

      context.read<HomeProvider>().loadGyms(
        latitude: location.currentLocation?.latitude,
        longitude: location.currentLocation?.longitude,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        children: [
          AppSpacing.h12,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AppSpacing.h16,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
            ),
            child: Row(
              children: [
                Text('Filter', style: AppTextStyles.heading4),
              ],
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Row(
              children: [
                // Tab list
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedTab == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: isSelected
                                ? const Border(
                                    left: BorderSide(
                                      color: AppColors.primaryGreen,
                                      width: 3,
                                    ),
                                  )
                                : null,
                          ),
                          child: Text(
                            _tabs[index],
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Content
                Expanded(
                  child: _buildFilterContent(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            child: PrimaryButton(
              text: 'Apply Filter (${_selectedFacilities.length})',
              onPressed: () {
                context.read<HomeProvider>().setFacilities(_selectedFacilities);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent() {
    if (_selectedTab == 0) {
      // Facilities
      final facilities = ['A/C', 'Trainer Support', '24x7', 'Washroom', 'Lorem', 'Lorem'];
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: facilities.length,
        itemBuilder: (context, index) {
          final facility = facilities[index];
          final isSelected = _selectedFacilities.contains(facility);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedFacilities.remove(facility);
                } else {
                  _selectedFacilities.add(facility);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.border,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.primaryDark,
                          )
                        : null,
                  ),
                  AppSpacing.w12,
                  Text(
                    facility,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return const Center(
      child: Text(
        'Coming soon',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

class SortSheet extends StatelessWidget {
  const SortSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      'Relevance',
      'Fee: High to low',
      'Fee: Low to high',
      'Rating: High to low',
      'Distance: Low to High',
    ];

    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusXL),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...sortOptions.map((option) {
                final isSelected = provider.selectedSort == option;
                return GestureDetector(
                  onTap: () {
                    provider.setSort(option);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              AppSpacing.h16,
            ],
          ),
        );
      },
    );
  }
}
