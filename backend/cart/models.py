from django.db import models
from django.conf import settings


class Cart(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="cart")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name_plural = "carts"

    def __str__(self):
        return f"Cart for {self.user.email}"

    @property
    def subtotal(self):
        return sum(item.line_total for item in self.items.all())

    @property
    def delivery_fee(self):
        return 5.00 if self.subtotal < 50 else 0.00

    @property
    def total(self):
        return float(self.subtotal) + float(self.delivery_fee)


class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name="items")
    medicine = models.ForeignKey("catalog.Medicine", on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("cart", "medicine")
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.quantity}x {self.medicine.name} in cart"

    @property
    def line_total(self):
        return self.medicine.price * self.quantity
