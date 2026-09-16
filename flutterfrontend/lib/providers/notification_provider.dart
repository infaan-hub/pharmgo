import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final notificationListProvider =
    StateNotifierProvider<NotificationListNotifier, NotificationListState>((ref) {
  return NotificationListNotifier(ref.read(notificationServiceProvider));
});

final unreadNotificationCountProvider = StateProvider<int>((ref) => 0);

class NotificationListState {
  final List<AppNotification> notifications;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  NotificationListState({
    this.notifications = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  NotificationListState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return NotificationListState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class NotificationListNotifier extends StateNotifier<NotificationListState> {
  final NotificationService _service;

  NotificationListNotifier(this._service) : super(NotificationListState());

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(notifications: [], currentPage: 1, hasMore: true);
    }
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final notifications = await _service.getNotifications(page: state.currentPage);
      state = state.copyWith(
        notifications: [...state.notifications, ...notifications],
        isLoading: false,
        hasMore: notifications.length >= 20,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _service.markAsRead(id);
      state = state.copyWith(
        notifications: state.notifications
            .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
            .toList(),
      );
    } catch (_) {}
  }
}
