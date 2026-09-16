from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, Address, PaymentMethod


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    model = User
    list_display = ["id", "email", "username", "first_name", "last_name", "role", "is_active", "created_at"]
    list_filter = ["role", "is_active", "is_staff"]
    search_fields = ["email", "username", "first_name", "last_name"]
    ordering = ["-created_at"]
    fieldsets = BaseUserAdmin.fieldsets + (
        ("Extra", {"fields": ("phone", "role")}),
    )
    add_fieldsets = BaseUserAdmin.add_fieldsets + (
        ("Extra", {"fields": ("email", "phone", "role")}),
    )


@admin.register(Address)
class AddressAdmin(admin.ModelAdmin):
    list_display = ["id", "user", "name", "city", "state", "is_default"]
    search_fields = ["name", "city", "state", "user__email"]
    list_filter = ["is_default", "country"]


@admin.register(PaymentMethod)
class PaymentMethodAdmin(admin.ModelAdmin):
    list_display = ["id", "user", "card_type", "last_four", "is_default", "created_at"]
    search_fields = ["cardholder_name", "user__email"]
    list_filter = ["card_type", "is_default"]
