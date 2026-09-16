from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularSwaggerView,
    SpectacularRedocView,
)

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="schema"), name="swagger-ui"),
    path("api/redoc/", SpectacularRedocView.as_view(url_name="schema"), name="redoc"),
    path("api/auth/", include("accounts.urls_auth")),
    path("api/accounts/", include("accounts.urls")),
    path("api/", include("catalog.urls")),
    path("api/", include("reviews.urls")),
    path("api/prescriptions/", include("prescriptions.urls")),
    path("api/cart/", include("cart.urls")),
    path("api/orders/", include("orders.urls")),
    path("api/pharmacies/", include("pharmacies.urls")),
    path("api/notifications/", include("notifications.urls")),
    path("api/support/", include("support.urls")),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
