from rest_framework import serializers
from .models import WishlistItem
from catalog.serializers import MedicineListSerializer


class WishlistItemSerializer(serializers.ModelSerializer):
    medicine = MedicineListSerializer(read_only=True)
    medicine_id = serializers.IntegerField(write_only=True)

    class Meta:
        model = WishlistItem
        fields = ["id", "medicine", "medicine_id", "added_at"]
        read_only_fields = ["id", "medicine", "added_at"]
