from django.urls import path
from . import views

urlpatterns = [
    path("nearby/", views.PharmacyNearbyView.as_view(), name="pharmacy-nearby"),
]
