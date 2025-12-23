import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/widgets/widgets.dart';
import '../../core/utils/formatters.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import 'slot_count_screen.dart';

class TimeSlotScreen extends StatefulWidget {
  final GymModel gym;
  final ServiceModel service;

  const TimeSlotScreen({
    super.key,
    required this.gym,
    required this.service,
  });

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  DateTime? _selectedDate;
  TimeSlotModel? _selectedSlot;

  final List<DateTime> _availableDates = List.generate(
    7,
        (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = _availableDates.first;

    // Load time slots on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTimeSlots();
    });
  }

  Future<void> _loadTimeSlots() async {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      await context.read<BookingProvider>().loadAvailableSlots(token);
    }
  }

  Future<void> _onDateChanged(DateTime date) async {
    setState(() => _selectedDate = date);
    context.read<BookingProvider>().selectDate(date);
    await _loadTimeSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            final slots = bookingProvider.availableSlots;

            // Group slots by period
            final morningSlots = slots.where((s) => s.period == 'morning').toList();
            final afternoonSlots = slots.where((s) => s.period == 'afternoon').toList();
            final eveningSlots = slots.where((s) => s.period == 'evening').toList();

            return Container(
              margin: const EdgeInsets.all(AppDimensions.screenPaddingH),
              padding: const EdgeInsets.all(AppDimensions.paddingXL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryOlive.withOpacity(0.3),
                    AppColors.cardBackground,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      AppSpacing.w12,
                      Text(
                        'Select Pickup Slot',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.h24,

                  Expanded(
                    child: Row(
                      children: [
                        // Date list
                        SizedBox(
                          width: 100,
                          child: ListView.builder(
                            itemCount: _availableDates.length,
                            itemBuilder: (context, index) {
                              final date = _availableDates[index];
                              final isSelected = _selectedDate != null &&
                                  _selectedDate!.day == date.day;
                              final isToday = date.day == DateTime.now().day;

                              return GestureDetector(
                                onTap: () => _onDateChanged(date),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryGreen.withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: isSelected
                                        ? Border.all(color: AppColors.primaryGreen)
                                        : null,
                                  ),
                                  child: Text(
                                    isToday
                                        ? 'Today, ${AppFormatters.getDayName(date.weekday)}'
                                        : '${AppFormatters.getDayName(date.weekday)}, ${date.day} ${AppFormatters.getMonthNameShort(date.month)}',
                                    style: AppTextStyles.bodySmall.copyWith(
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
                        AppSpacing.w16,

                        // Time slots
                        Expanded(
                          child: bookingProvider.isLoadingSlots
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          )
                              : bookingProvider.error != null
                              ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 48,
                                ),
                                AppSpacing.h16,
                                Text(
                                  bookingProvider.error!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                AppSpacing.h16,
                                TextButton(
                                  onPressed: _loadTimeSlots,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                              : slots.isEmpty
                              ? Center(
                            child: Text(
                              'No slots available',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                              : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (morningSlots.isNotEmpty) ...[
                                  Text(
                                    'Morning',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  AppSpacing.h8,
                                  ...morningSlots.map((slot) => _buildSlotTile(slot)),
                                  AppSpacing.h16,
                                ],
                                if (afternoonSlots.isNotEmpty) ...[
                                  Text(
                                    'After noon',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  AppSpacing.h8,
                                  ...afternoonSlots.map((slot) => _buildSlotTile(slot)),
                                  AppSpacing.h16,
                                ],
                                if (eveningSlots.isNotEmpty) ...[
                                  Text(
                                    'Evening',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  AppSpacing.h8,
                                  ...eveningSlots.map((slot) => _buildSlotTile(slot)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.h16,
                  // Selected summary
                  if (_selectedDate != null && _selectedSlot != null)
                    Center(
                      child: Text(
                        'Today, ${_selectedSlot!.startTime}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  AppSpacing.h16,

                  PrimaryButton(
                    text: 'Confirm Slot',
                    isEnabled: _selectedSlot != null,
                    onPressed: () {
                      if (_selectedSlot != null) {
                        bookingProvider.selectTimeSlot(_selectedSlot!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SlotCountScreen(
                              gym: widget.gym,
                              service: widget.service,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlotTile(TimeSlotModel slot) {
    final isSelected = _selectedSlot?.id == slot.id;
    final isDisabled = !slot.isAvailable;

    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => _selectedSlot = slot),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  slot.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              if (slot.availableCount != null && slot.maxCapacity != null)
                Text(
                  '${slot.availableCount}/${slot.maxCapacity}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}