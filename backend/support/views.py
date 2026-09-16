from rest_framework import viewsets, generics, permissions
from rest_framework.response import Response
from .models import FAQ, SupportTicket
from .serializers import FAQSerializer, SupportTicketSerializer


class FAQListView(generics.ListAPIView):
    serializer_class = FAQSerializer
    permission_classes = [permissions.AllowAny]
    queryset = FAQ.objects.filter(is_active=True)
    pagination_class = None


class SupportTicketViewSet(viewsets.ModelViewSet):
    serializer_class = SupportTicketSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        if self.request.user.role in ("pharmacist", "admin"):
            return SupportTicket.objects.all()
        return SupportTicket.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
