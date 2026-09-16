from django.contrib import admin
from .models import Order, OrderItem


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0
    readonly_fields = ["medicine", "quantity", "price_at_purchase"]


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ["id", "user", "status", "subtotal", "delivery_fee", "total", "created_at"]
    search_fields = ["user__email"]
    list_filter = ["status", "created_at"]
    readonly_fields = ["subtotal", "delivery_fee", "total"]
    inlines = [OrderItemInline]


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    list_display = ["id", "order", "medicine", "quantity", "price_at_purchase"]
    list_filter = ["order"]
