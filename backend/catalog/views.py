from rest_framework import viewsets, generics, permissions, filters
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.pagination import PageNumberPagination
from .models import Category, Medicine
from .serializers import CategorySerializer, MedicineListSerializer, MedicineDetailSerializer


class CategoryListView(generics.ListAPIView):
    serializer_class = CategorySerializer
    permission_classes = [permissions.AllowAny]
    queryset = Category.objects.filter(is_active=True)
    pagination_class = None


class MedicinePagination(PageNumberPagination):
    page_size = 20
    page_size_query_param = "page_size"
    max_page_size = 100


class MedicineListView(generics.ListAPIView):
    serializer_class = MedicineListSerializer
    permission_classes = [permissions.AllowAny]
    queryset = Medicine.objects.filter(is_active=True).select_related("category")
    pagination_class = MedicinePagination
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ["category", "requires_prescription"]
    search_fields = ["name", "description", "manufacturer"]
    ordering_fields = ["name", "price", "rating_avg", "created_at"]


class MedicineDetailView(generics.RetrieveAPIView):
    serializer_class = MedicineDetailSerializer
    permission_classes = [permissions.AllowAny]
    queryset = Medicine.objects.filter(is_active=True).select_related("category")
    lookup_field = "pk"
