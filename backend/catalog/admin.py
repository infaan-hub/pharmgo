from django.contrib import admin
from .models import Category, Medicine, MedicineImage


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ["id", "name", "slug", "is_active", "created_at"]
    search_fields = ["name", "slug"]
    list_filter = ["is_active"]
    prepopulated_fields = {"slug": ("name",)}


@admin.register(Medicine)
class MedicineAdmin(admin.ModelAdmin):
    list_display = ["id", "name", "slug", "manufacturer", "price", "stock_quantity", "requires_prescription", "rating_avg", "is_active"]
    search_fields = ["name", "manufacturer"]
    list_filter = ["is_active", "requires_prescription", "category"]
    prepopulated_fields = {"slug": ("name",)}


@admin.register(MedicineImage)
class MedicineImageAdmin(admin.ModelAdmin):
    list_display = ["id", "medicine", "is_primary"]
    list_filter = ["is_primary"]
