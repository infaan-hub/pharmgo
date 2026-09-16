from django.db import models
from django.conf import settings


class Prescription(models.Model):
    STATUS_CHOICES = (
        ("pending", "Pending"),
        ("approved", "Approved"),
        ("rejected", "Rejected"),
    )
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="prescriptions")
    image = models.ImageField(upload_to="prescriptions/", blank=True, null=True)
    file = models.FileField(upload_to="prescriptions/files/", blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="pending")
    pharmacist_notes = models.TextField(blank=True, default="")
    linked_medicines = models.ManyToManyField("catalog.Medicine", blank=True, related_name="prescriptions")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"Prescription #{self.pk} by {self.user.email} - {self.status}"
