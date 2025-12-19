import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: 0,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      automaticallyImplyLeading: showBackButton,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.heading4,
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);
}

class HomeAppBar extends StatelessWidget {
  final String location;
  final String address;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;

  const HomeAppBar({
    super.key,
    required this.location,
    required this.address,
    this.onLocationTap,
    this.onNotificationTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: AppDimensions.paddingM,
      ),
      child: Row(
        children: [
          // Location
          Expanded(
            child: GestureDetector(
              onTap: onLocationTap,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  AppSpacing.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          location,
                          style: AppTextStyles.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          address,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Actions
          Row(
            children: [
              _buildIconButton(
                Icons.notifications_outlined,
                onNotificationTap,
              ),
              AppSpacing.w8,
              _buildIconButton(
                Icons.menu,
                onMenuTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
    );
  }
}
