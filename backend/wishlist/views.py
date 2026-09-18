from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import WishlistItem
from .serializers import WishlistItemSerializer


class WishlistItemViewSet(viewsets.ModelViewSet):
    serializer_class = WishlistItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return WishlistItem.objects.filter(user=self.request.user).select_related("medicine", "medicine__category")

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
