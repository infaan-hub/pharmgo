from django.conf import settings
from django.db import models
from catalog.models import Medicine


class WishlistItem(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="wishlist_items")
    medicine = models.ForeignKey(Medicine, on_delete=models.CASCADE, related_name="wishlisted_by")
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-added_at"]
        constraints = [models.UniqueConstraint(fields=["user", "medicine"], name="unique_wishlist_medicine")]

    def __str__(self):
        return f"{self.user.username}: {self.medicine.name}"
