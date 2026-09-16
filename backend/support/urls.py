from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r"tickets", views.SupportTicketViewSet, basename="support-ticket")

urlpatterns = [
    path("faqs/", views.FAQListView.as_view(), name="faq-list"),
    path("", include(router.urls)),
]
