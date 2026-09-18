from django.urls import path
from .views import WishlistItemViewSet

item_list = WishlistItemViewSet.as_view({"get": "list", "post": "create"})
item_detail = WishlistItemViewSet.as_view({"delete": "destroy"})
urlpatterns = [path("items/", item_list), path("items/<int:pk>/", item_detail)]
