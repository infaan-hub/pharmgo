from rest_framework import serializers
from .models import Order, OrderItem
from catalog.serializers import MedicineListSerializer


class OrderItemSerializer(serializers.ModelSerializer):
    medicine_detail = MedicineListSerializer(source="medicine", read_only=True)

    class Meta:
        model = OrderItem
        fields = ["id", "medicine", "medicine_detail", "quantity", "price_at_purchase"]
        read_only_fields = ["id", "price_at_purchase"]


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)

    class Meta:
        model = Order
        fields = [
            "id", "user", "address", "payment_method", "status",
            "subtotal", "delivery_fee", "total", "items",
            "created_at", "updated_at",
        ]
        read_only_fields = ["id", "user", "status", "subtotal", "delivery_fee", "total", "created_at", "updated_at"]


class CreateOrderSerializer(serializers.Serializer):
    address_id = serializers.IntegerField()
    payment_method_id = serializers.IntegerField()


class OrderStatusSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=Order.STATUS_CHOICES)


class ReorderSerializer(serializers.Serializer):
    order_id = serializers.IntegerField()
