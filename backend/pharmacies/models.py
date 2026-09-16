from django.db import models


class Pharmacy(models.Model):
    name = models.CharField(max_length=300)
    address = models.CharField(max_length=500)
    lat = models.DecimalField(max_digits=9, decimal_places=6)
    lng = models.DecimalField(max_digits=9, decimal_places=6)
    hours = models.JSONField(default=dict, blank=True)
    contact_phone = models.CharField(max_length=20, blank=True, default="")
    contact_email = models.EmailField(blank=True, default="")
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["name"]

    def __str__(self):
        return self.name
