from django.contrib import admin
from .models import Prescription


@admin.register(Prescription)
class PrescriptionAdmin(admin.ModelAdmin):
    list_display = ["id", "user", "status", "created_at", "updated_at"]
    search_fields = ["user__email", "pharmacist_notes"]
    list_filter = ["status"]
