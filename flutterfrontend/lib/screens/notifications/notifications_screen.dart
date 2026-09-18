import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifications = [
    {
      'title': 'Order Delivered',
      'body': 'Your order #PG-2024-001 has been delivered successfully.',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'icon': Icons.check_circle,
      'color': AppColors.success,
    },
    {
      'title': 'Prescription Verified',
      'body': 'Your prescription has been verified. You can now order medicines.',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
      'icon': Icons.verified,
      'color': AppColors.primaryDark,
    },
    {
      'title': 'Special Offer',
      'body': 'Get 20% off on all vitamins. Use code VITAMIN20.',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'icon': Icons.local_offer,
      'color': AppColors.success,
    },
    {
      'title': 'Order Shipped',
      'body': 'Your order #PG-2024-002 is on the way.',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'icon': Icons.local_shipping,
      'color': AppColors.primaryDark,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Notifications',
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['isRead'] = true;
                }
              });
            },
            child: Text(
              'Mark all read',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_outlined,
              title: 'No notifications',
              subtitle: 'You\'re all caught up!',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(_notifications[index]);
              },
            ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? AppColors.white : AppColors.cardSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? AppColors.divider : AppColors.primaryDark.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (notification['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              notification['icon'] as IconData,
              color: notification['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'] as String,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['body'] as String,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.timeAgo(notification['time'] as DateTime),
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
