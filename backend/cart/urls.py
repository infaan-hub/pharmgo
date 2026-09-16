from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r"items", views.CartItemViewSet, basename="cart-item")

urlpatterns = [
    path("", views.CartView.as_view(), name="cart-detail"),
    path("", include(router.urls)),
]
