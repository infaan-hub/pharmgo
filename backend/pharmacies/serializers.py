from rest_framework import serializers
from .models import Pharmacy


class PharmacySerializer(serializers.ModelSerializer):
    distance_km = serializers.SerializerMethodField()

    class Meta:
        model = Pharmacy
        fields = [
            "id", "name", "address", "lat", "lng", "hours",
            "contact_phone", "contact_email", "is_active",
            "created_at", "distance_km",
        ]
        read_only_fields = ["id", "created_at"]

    def get_distance_km(self, obj):
        lat = self.context.get("request_lat")
        lng = self.context.get("request_lng")
        if lat is None or lng is None:
            return None
        from math import radians, sin, cos, sqrt, atan2
        R = 6371
        lat1, lon1 = radians(float(lat)), radians(float(lng))
        lat2, lon2 = radians(float(obj.lat)), radians(float(obj.lng))
        dlat = lat2 - lat1
        dlon = lon2 - lon1
        a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
        c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return round(R * c, 2)
