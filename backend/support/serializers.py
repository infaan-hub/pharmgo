from rest_framework import serializers
from .models import FAQ, SupportTicket


class FAQSerializer(serializers.ModelSerializer):
    class Meta:
        model = FAQ
        fields = ["id", "question", "answer", "category", "is_active", "created_at"]


class SupportTicketSerializer(serializers.ModelSerializer):
    user_email = serializers.CharField(source="user.email", read_only=True)

    class Meta:
        model = SupportTicket
        fields = ["id", "user", "user_email", "subject", "message", "status", "created_at", "updated_at"]
        read_only_fields = ["id", "user", "status", "created_at", "updated_at"]
