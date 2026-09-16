from django.db import models
import json


class Category(models.Model):
    name = models.CharField(max_length=200)
    slug = models.SlugField(unique=True, max_length=200)
    description = models.TextField(blank=True, default="")
    icon = models.CharField(max_length=100, blank=True, default="")
    image = models.ImageField(upload_to="categories/", blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "categories"
        ordering = ["name"]

    def __str__(self):
        return self.name


class Medicine(models.Model):
    name = models.CharField(max_length=300)
    slug = models.SlugField(unique=True, max_length=300)
    description = models.TextField(blank=True, default="")
    manufacturer = models.CharField(max_length=300, blank=True, default="")
    dosage_options = models.JSONField(default=dict, blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stock_quantity = models.PositiveIntegerField(default=0)
    requires_prescription = models.BooleanField(default=False)
    image = models.ImageField(upload_to="medicines/", blank=True, null=True)
    rating_avg = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    category = models.ForeignKey(
        Category, on_delete=models.SET_NULL, null=True, blank=True, related_name="medicines"
    )
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["name"]

    def __str__(self):
        return self.name

    @property
    def in_stock(self):
        return self.stock_quantity > 0


class MedicineImage(models.Model):
    medicine = models.ForeignKey(Medicine, on_delete=models.CASCADE, related_name="images")
    image = models.ImageField(upload_to="medicines/gallery/")
    is_primary = models.BooleanField(default=False)

    class Meta:
        ordering = ["-is_primary"]

    def __str__(self):
        return f"Image for {self.medicine.name}"
