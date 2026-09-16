from django.contrib import admin
from .models import FAQ, SupportTicket


@admin.register(FAQ)
class FAQAdmin(admin.ModelAdmin):
    list_display = ["id", "question", "category", "is_active", "created_at"]
    search_fields = ["question", "answer"]
    list_filter = ["category", "is_active"]


@admin.register(SupportTicket)
class SupportTicketAdmin(admin.ModelAdmin):
    list_display = ["id", "user", "subject", "status", "created_at", "updated_at"]
    search_fields = ["user__email", "subject", "message"]
    list_filter = ["status", "created_at"]
