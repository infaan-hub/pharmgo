from django.db import models
from django.conf import settings
from django.core.validators import MinValueValidator, MaxValueValidator


class Review(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="reviews")
    medicine = models.ForeignKey("catalog.Medicine", on_delete=models.CASCADE, related_name="reviews")
    rating = models.PositiveIntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    comment = models.TextField(blank=True, default="")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-created_at"]
        unique_together = ("user", "medicine")

    def __str__(self):
        return f"Review by {self.user.email} for {self.medicine.name} - {self.rating}/5"

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        self._update_medicine_rating()

    def _update_medicine_rating(self):
        from django.db.models import Avg
        avg = Review.objects.filter(medicine=self.medicine).aggregate(Avg("rating"))["rating__avg"]
        self.medicine.rating_avg = round(avg or 0, 2)
        self.medicine.save(update_fields=["rating_avg"])
