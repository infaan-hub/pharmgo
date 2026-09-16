from django.db import models
from django.conf import settings


class Order(models.Model):
    STATUS_CHOICES = (
        ("placed", "Placed"),
        ("confirmed", "Confirmed"),
        ("verifying", "Verifying"),
        ("out_for_delivery", "Out for Delivery"),
        ("delivered", "Delivered"),
        ("cancelled", "Cancelled"),
    )
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="orders")
    address = models.ForeignKey("accounts.Address", on_delete=models.SET_NULL, null=True, related_name="orders")
    payment_method = models.ForeignKey("accounts.PaymentMethod", on_delete=models.SET_NULL, null=True, related_name="orders")
    status = models.CharField(max_length=30, choices=STATUS_CHOICES, default="placed")
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    delivery_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"Order #{self.pk} by {self.user.email} - {self.status}"


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="items")
    medicine = models.ForeignKey("catalog.Medicine", on_delete=models.SET_NULL, null=True)
    quantity = models.PositiveIntegerField(default=1)
    price_at_purchase = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        ordering = ["id"]

    def __str__(self):
        return f"{self.quantity}x {self.medicine.name if self.medicine else 'deleted'} in Order #{self.order.pk}"
