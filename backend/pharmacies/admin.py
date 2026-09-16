from django.contrib import admin
from .models import Pharmacy


@admin.register(Pharmacy)
class PharmacyAdmin(admin.ModelAdmin):
    list_display = ["id", "name", "address", "lat", "lng", "contact_phone", "is_active"]
    search_fields = ["name", "address"]
    list_filter = ["is_active"]
