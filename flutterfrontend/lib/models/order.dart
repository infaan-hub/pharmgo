import 'medicine.dart';

class OrderItem {
  final int id;
  final int medicineId;
  final Medicine? medicineDetail;
  final int quantity;
  final double priceAtPurchase;
  final String? selectedDosage;

  OrderItem({
    required this.id,
    required this.medicineId,
    this.medicineDetail,
    required this.quantity,
    required this.priceAtPurchase,
    this.selectedDosage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      medicineId: json['medicine'] ?? 0,
      medicineDetail: json['medicine_detail'] != null
          ? Medicine.fromJson(json['medicine_detail'])
          : null,
      quantity: json['quantity'] ?? 1,
      priceAtPurchase: (json['price_at_purchase'] ?? 0).toDouble(),
      selectedDosage: json['selected_dosage'],
    );
  }

  Medicine get medicine => medicineDetail ?? Medicine(id: medicineId, name: '', slug: '', price: 0, category: 0);
  double get totalPrice => priceAtPurchase * quantity;
  Medicine? get medicine => medicineDetail;
  String get selectedDosage => '';
}

class Order {
  final int id;
  final int address;
  final int paymentMethod;
  final String status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final List<OrderItem> items;
  final DateTime createdAt;
  final String? orderNumber;
  final String? shippingAddress;
  final double discount;

  Order({
    required this.id,
    required this.address,
    required this.paymentMethod,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.items = const [],
    required this.createdAt,
    this.orderNumber,
    this.shippingAddress,
    this.discount = 0.0,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      address: json['address'] is int ? json['address'] : 0,
      paymentMethod: json['payment_method'] is int ? json['payment_method'] : 0,
      status: json['status'] ?? 'placed',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      items: (json['items'] as List?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      orderNumber: json['order_number'] ?? 'ORD-${json['id']}',
      shippingAddress: json['shipping_address'] ?? '',
      discount: (json['discount'] ?? 0).toDouble(),
    );
  }

  String get statusLabel {
    switch (status) {
      case 'placed':
        return 'Order Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'verifying':
        return 'Pharmacist Verifying';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  int get statusStep {
    switch (status) {
      case 'placed':
        return 0;
      case 'confirmed':
        return 1;
      case 'verifying':
        return 2;
      case 'out_for_delivery':
        return 3;
      case 'delivered':
        return 4;
      case 'cancelled':
        return 0;
      default:
        return 0;
    }
  }

  String get orderNumber => '#$id';
  String get shippingAddress => '';
  double get discount => 0.0;
}
