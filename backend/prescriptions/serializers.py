from rest_framework import serializers
from .models import Prescription


class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = [
            "id", "user", "image", "file", "status", "pharmacist_notes",
            "linked_medicines", "created_at", "updated_at",
        ]
        read_only_fields = ["id", "user", "status", "pharmacist_notes", "linked_medicines", "created_at", "updated_at"]
