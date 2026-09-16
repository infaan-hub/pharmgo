from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenRefreshView
from . import views

router = DefaultRouter()
router.register(r"addresses", views.AddressViewSet, basename="address")
router.register(r"payment-methods", views.PaymentMethodViewSet, basename="payment-method")

urlpatterns = [
    path("", include(router.urls)),
    path("me/", views.UserProfileView.as_view(), name="user-profile"),
]
