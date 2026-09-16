from rest_framework import generics, permissions
from rest_framework.response import Response
from .models import Pharmacy
from .serializers import PharmacySerializer


class PharmacyNearbyView(generics.ListAPIView):
    serializer_class = PharmacySerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        return Pharmacy.objects.filter(is_active=True)

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context["request_lat"] = self.request.query_params.get("lat")
        context["request_lng"] = self.request.query_params.get("lng")
        return context

    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())
        lat = request.query_params.get("lat")
        lng = request.query_params.get("lng")
        radius = float(request.query_params.get("radius", 50))

        if lat and lng:
            from math import radians, sin, cos, sqrt, atan2
            R = 6371
            lat1, lon1 = radians(float(lat)), radians(float(lng))
            filtered = []
            for pharmacy in queryset:
                lat2 = radians(float(pharmacy.lat))
                lon2 = radians(float(pharmacy.lng))
                dlat = lat2 - lat1
                dlon = lon2 - lon1
                a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
                c = 2 * atan2(sqrt(a), sqrt(1 - a))
                dist = R * c
                if dist <= radius:
                    filtered.append(pharmacy.id)
            queryset = queryset.filter(id__in=filtered)

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)
