import 'medicine.dart';

class CartItem {
  final int id;
  final int medicineId;
  final Medicine? medicineDetail;
  final int quantity;
  final double lineTotal;
  final String? selectedDosage;

  CartItem({
    required this.id,
    required this.medicineId,
    this.medicineDetail,
    required this.quantity,
    required this.lineTotal,
    this.selectedDosage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      medicineId: json['medicine'] ?? 0,
      medicineDetail: json['medicine_detail'] != null
          ? Medicine.fromJson(json['medicine_detail'])
          : null,
      quantity: json['quantity'] ?? 1,
      lineTotal: (json['line_total'] ?? 0).toDouble(),
      selectedDosage: json['selected_dosage'],
    );
  }

  Medicine get medicine => medicineDetail ?? Medicine(id: medicineId, name: '', slug: '', price: 0, category: 0);
  double get totalPrice => lineTotal > 0 ? lineTotal : medicine.price * quantity;
  bool get canIncrement => quantity < 10;
  bool get canDecrement => quantity > 1;
}

class Cart {
  final int id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final double discount;

  Cart({
    required this.id,
    this.items = const [],
    this.subtotal = 0.0,
    this.deliveryFee = 0.0,
    this.total = 0.0,
    this.discount = 0.0,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? 0,
      items: (json['items'] as List?)
              ?.map((e) => CartItem.fromJson(e))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
