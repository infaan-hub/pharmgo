from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Prescription
from .serializers import PrescriptionSerializer


class PrescriptionViewSet(viewsets.ModelViewSet):
    serializer_class = PrescriptionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        if self.request.user.role in ("pharmacist", "admin"):
            return Prescription.objects.all()
        return Prescription.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=True, methods=["patch"], permission_classes=[permissions.IsAuthenticated])
    def approve(self, request, pk=None):
        prescription = self.get_object()
        if request.user.role not in ("pharmacist", "admin"):
            return Response(
                {"detail": "Only pharmacists can approve prescriptions."},
                status=status.HTTP_403_FORBIDDEN,
            )
        prescription.status = "approved"
        prescription.pharmacist_notes = request.data.get("pharmacist_notes", "")
        prescription.save()
        return Response(PrescriptionSerializer(prescription).data)

    @action(detail=True, methods=["patch"], permission_classes=[permissions.IsAuthenticated])
    def reject(self, request, pk=None):
        prescription = self.get_object()
        if request.user.role not in ("pharmacist", "admin"):
            return Response(
                {"detail": "Only pharmacists can reject prescriptions."},
                status=status.HTTP_403_FORBIDDEN,
            )
        prescription.status = "rejected"
        prescription.pharmacist_notes = request.data.get("pharmacist_notes", "")
        prescription.save()
        return Response(PrescriptionSerializer(prescription).data)

    def partial_update(self, request, *args, **kwargs):
        return super().partial_update(request, *args, **kwargs)
