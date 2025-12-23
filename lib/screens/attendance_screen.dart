import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../core/utils/formatters.dart';
import '../providers/providers.dart';
import 'qr_scanner_screen.dart';
import 'set_location_screen.dart';
import 'notification_screen.dart';
import 'side_menu_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load attendance on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().loadAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: const SideMenuScreen(),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Consumer2<LocationProvider, HomeProvider>(
              builder: (context, locationProvider, homeProvider, child) {
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
            AppSpacing.h16,

            // Title
            Text('Your Attendance', style: AppTextStyles.heading4),
            AppSpacing.h16,

            Expanded(
              child: Consumer<AttendanceProvider>(
                builder: (context, provider, child) {
                  // Loading state
                  if (provider.isLoading && provider.attendanceData.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    );
                  }

                  // Error state
                  if (provider.error != null && provider.attendanceData.isEmpty) {
                    return Center(
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
                            provider.error!,
                            style: const TextStyle(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.h16,
                          TextButton(
                            onPressed: () {
                              provider.clearError();
                              provider.loadAttendance();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingH,
                    ),
                    child: Column(
                      children: [
                        // Month selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   'This Month',
                            //   style: AppTextStyles.labelMedium,
                            // ),
                            // const Icon(Icons.keyboard_arrow_down, size: 20),
                            AppSpacing.w12,
                            Text(
                              provider.dateRangeText,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.h16,

                        // Stats card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                              ),
                              AppSpacing.w12,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Attendance %',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${provider.attendancePercentage.toStringAsFixed(0)}%',
                                    style: AppTextStyles.heading4.copyWith(
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: 1,
                                height: 40,
                                color: AppColors.border,
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Present',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${provider.presentDays}',
                                    style: AppTextStyles.heading4,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Absent',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${provider.absentDays}',
                                    style: AppTextStyles.heading4.copyWith(
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.h24,

                        // Calendar
                        _buildCalendar(provider),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Mark attendance button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: PrimaryButton(
                text: 'Mark Attendance',
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(AttendanceProvider provider) {
    final selectedMonth = provider.selectedMonth;
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    // Previous month days to show
    final prevMonth = DateTime(selectedMonth.year, selectedMonth.month, 0);
    final prevMonthDays = prevMonth.day;

    List<Widget> dayWidgets = [];

    // Previous month trailing days
    for (int i = firstWeekday - 1; i > 0; i--) {
      dayWidgets.add(_buildDayCell(prevMonthDays - i + 1, false, null));
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, day);
      final attendance = provider.getAttendanceForDate(date);
      dayWidgets.add(_buildDayCell(day, true, attendance));
    }

    // Next month leading days
    int nextMonthDay = 1;
    while (dayWidgets.length < 42) {
      dayWidgets.add(_buildDayCell(nextMonthDay++, false, null));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => provider.changeMonth(-1),
                child: Text(
                  AppFormatters.getMonthNameShort(
                    selectedMonth.month == 1 ? 12 : selectedMonth.month - 1,
                  ),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              AppSpacing.w24,
              Text(
                AppFormatters.getMonthName(selectedMonth.month),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
              AppSpacing.w24,
              GestureDetector(
                onTap: () => provider.changeMonth(1),
                child: Text(
                  AppFormatters.getMonthNameShort(
                    selectedMonth.month == 12 ? 1 : selectedMonth.month + 1,
                  ),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h16,

          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                .map((day) => SizedBox(
              width: 36,
              child: Center(
                child: Text(
                  day,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ))
                .toList(),
          ),
          AppSpacing.h8,

          // Calendar grid
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: dayWidgets,
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(int day, bool isCurrentMonth, bool? attendance) {
    Color bgColor = Colors.transparent;
    Color textColor = isCurrentMonth ? AppColors.textPrimary : AppColors.textHint;

    if (isCurrentMonth && attendance != null) {
      bgColor = attendance ? AppColors.calendarPresent : AppColors.calendarAbsent;
      textColor = AppColors.textPrimary;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$day',
          style: AppTextStyles.bodySmall.copyWith(color: textColor),
        ),
      ),
    );
  }
}