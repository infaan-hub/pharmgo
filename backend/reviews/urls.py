from django.urls import path
from . import views

urlpatterns = [
    path("medicines/<int:medicine_id>/reviews/", views.MedicineReviewListCreateView.as_view(), name="medicine-reviews"),
]
