import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/order_service.dart';

final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

final orderListProvider = StateNotifierProvider<OrderListNotifier, OrderListState>((ref) {
  return OrderListNotifier(ref.read(orderServiceProvider));
});

final orderDetailProvider = FutureProvider.family<Order, int>((ref, orderId) async {
  return ref.read(orderServiceProvider).getOrderDetail(orderId);
});

class OrderListState {
  final List<Order> orders;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  OrderListState({
    this.orders = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  OrderListState copyWith({
    List<Order>? orders,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return OrderListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class OrderListNotifier extends StateNotifier<OrderListState> {
  final OrderService _service;

  OrderListNotifier(this._service) : super(OrderListState());

  Future<void> loadOrders({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(orders: [], currentPage: 1, hasMore: true);
    }
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _service.getOrders(page: state.currentPage);
      state = state.copyWith(
        orders: [...state.orders, ...orders],
        isLoading: false,
        hasMore: orders.length >= 20,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
