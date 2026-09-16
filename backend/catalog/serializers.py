from rest_framework import serializers
from .models import Category, Medicine, MedicineImage


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name", "slug", "description", "icon", "image", "is_active", "created_at"]


class MedicineImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = MedicineImage
        fields = ["id", "image", "is_primary"]


class MedicineListSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source="category.name", read_only=True, default=None)

    class Meta:
        model = Medicine
        fields = [
            "id", "name", "slug", "description", "manufacturer", "dosage_options",
            "price", "stock_quantity", "requires_prescription", "image", "rating_avg",
            "category", "category_name", "is_active", "created_at", "updated_at",
        ]


class MedicineDetailSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source="category.name", read_only=True, default=None)
    images = MedicineImageSerializer(many=True, read_only=True)
    in_stock = serializers.BooleanField(read_only=True)

    class Meta:
        model = Medicine
        fields = [
            "id", "name", "slug", "description", "manufacturer", "dosage_options",
            "price", "stock_quantity", "requires_prescription", "image", "rating_avg",
            "category", "category_name", "is_active", "images", "in_stock",
            "created_at", "updated_at",
        ]
