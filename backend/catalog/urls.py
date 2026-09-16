from django.urls import path
from rest_framework.routers import DefaultRouter
from . import views

urlpatterns = [
    path("categories/", views.CategoryListView.as_view(), name="category-list"),
    path("medicines/", views.MedicineListView.as_view(), name="medicine-list"),
    path("medicines/<int:pk>/", views.MedicineDetailView.as_view(), name="medicine-detail"),
]
