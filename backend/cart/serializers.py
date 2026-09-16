from rest_framework import serializers
from .models import Cart, CartItem
from catalog.serializers import MedicineListSerializer


class CartItemSerializer(serializers.ModelSerializer):
    medicine_detail = MedicineListSerializer(source="medicine", read_only=True)
    line_total = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = CartItem
        fields = ["id", "medicine", "medicine_detail", "quantity", "line_total", "created_at"]
        read_only_fields = ["id", "line_total", "created_at"]


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    subtotal = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    delivery_fee = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    total = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = Cart
        fields = ["id", "items", "subtotal", "delivery_fee", "total", "created_at", "updated_at"]
        read_only_fields = ["id", "created_at", "updated_at"]


class AddCartItemSerializer(serializers.Serializer):
    medicine_id = serializers.IntegerField()
    quantity = serializers.IntegerField(min_value=1, default=1)


class UpdateCartItemSerializer(serializers.Serializer):
    quantity = serializers.IntegerField(min_value=1)
