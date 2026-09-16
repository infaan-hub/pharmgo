from rest_framework import generics, permissions
from rest_framework.response import Response
from .models import Review
from .serializers import ReviewSerializer, ReviewCreateSerializer


class MedicineReviewListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.AllowAny]

    def get_serializer_class(self):
        if self.request.method == "POST":
            return ReviewCreateSerializer
        return ReviewSerializer

    def get_queryset(self):
        medicine_id = self.kwargs["medicine_id"]
        return Review.objects.filter(medicine_id=medicine_id).select_related("user")

    def perform_create(self, serializer):
        medicine_id = self.kwargs["medicine_id"]
        if Review.objects.filter(user=self.request.user, medicine_id=medicine_id).exists():
            from rest_framework.exceptions import ValidationError
            raise ValidationError({"detail": "You have already reviewed this medicine."})
        serializer.save(user=self.request.user, medicine_id=medicine_id)
