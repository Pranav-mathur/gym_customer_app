import 'package:flutter/material.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../core/utils/formatters.dart';
import '../data/mock_data.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications', style: AppTextStyles.heading4),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark All as Read',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: notification.type == 'booking'
                              ? AppColors.primaryGreen.withOpacity(0.2)
                              : AppColors.starFilled.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          notification.type == 'booking'
                              ? Icons.check_circle
                              : Icons.auto_awesome,
                          color: notification.type == 'booking'
                              ? AppColors.primaryGreen
                              : AppColors.starFilled,
                          size: 20,
                        ),
                      ),
                      AppSpacing.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: AppTextStyles.labelMedium,
                            ),
                            AppSpacing.h4,
                            Text(
                              AppFormatters.formatRelativeTime(notification.createdAt),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
