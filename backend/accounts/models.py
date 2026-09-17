from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone
import secrets
import hashlib


class User(AbstractUser):
    ROLE_CHOICES = (
        ("customer", "Customer"),
        ("pharmacist", "Pharmacist"),
        ("admin", "Admin"),
    )
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=20, blank=True, default="")
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default="customer")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    USERNAME_FIELD = "username"
    REQUIRED_FIELDS = ["email"]

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return self.username


class OTP(models.Model):
    PURPOSE_CHOICES = (
        ("otp_verification", "OTP Verification"),
        ("password_reset", "Password Reset"),
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="otps")
    code_hash = models.CharField(max_length=128)
    purpose = models.CharField(max_length=20, choices=PURPOSE_CHOICES)
    is_used = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"OTP for {self.user.username} ({self.purpose})"

    @classmethod
    def generate(cls, user, purpose, expiry_minutes=10):
        raw_code = f"{secrets.randbelow(900000) + 100000}"
        code_hash = hashlib.sha256(raw_code.encode()).hexdigest()
        otp = cls.objects.create(
            user=user,
            code_hash=code_hash,
            purpose=purpose,
            expires_at=timezone.now() + timezone.timedelta(minutes=expiry_minutes),
        )
        return raw_code, otp

    def is_valid(self):
        return not self.is_used and timezone.now() < self.expires_at

    def verify(self, code):
        if not self.is_valid():
            return False
        code_hash = hashlib.sha256(code.encode()).hexdigest()
        if self.code_hash == code_hash:
            self.is_used = True
            self.save(update_fields=["is_used"])
            return True
        return False

    @classmethod
    def cleanup_expired(cls):
        cls.objects.filter(expires_at__lt=timezone.now()).delete()


class PasswordResetToken(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="password_reset_tokens")
    token_hash = models.CharField(max_length=128)
    is_used = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"Password reset token for {self.user.username}"

    @classmethod
    def generate(cls, user, expiry_minutes=30):
        raw_token = secrets.token_urlsafe(48)
        token_hash = hashlib.sha256(raw_token.encode()).hexdigest()
        token = cls.objects.create(
            user=user,
            token_hash=token_hash,
            expires_at=timezone.now() + timezone.timedelta(minutes=expiry_minutes),
        )
        return raw_token, token

    def is_valid(self):
        return not self.is_used and timezone.now() < self.expires_at

    def verify(self, token):
        if not self.is_valid():
            return False
        token_hash = hashlib.sha256(token.encode()).hexdigest()
        if self.token_hash == token_hash:
            self.is_used = True
            self.save(update_fields=["is_used"])
            return True
        return False

    @classmethod
    def cleanup_expired(cls):
        cls.objects.filter(expires_at__lt=timezone.now()).delete()


class Address(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="addresses")
    name = models.CharField(max_length=100)
    address_line1 = models.CharField(max_length=255)
    address_line2 = models.CharField(max_length=255, blank=True, default="")
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    zip_code = models.CharField(max_length=20)
    country = models.CharField(max_length=100, default="US")
    is_default = models.BooleanField(default=False)
    lat = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    lng = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-is_default", "-created_at"]

    def __str__(self):
        return f"{self.name}: {self.address_line1}, {self.city}"


class PaymentMethod(models.Model):
    CARD_TYPE_CHOICES = (
        ("visa", "Visa"),
        ("mastercard", "Mastercard"),
        ("amex", "American Express"),
        ("discover", "Discover"),
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="payment_methods")
    card_type = models.CharField(max_length=20, choices=CARD_TYPE_CHOICES)
    last_four = models.CharField(max_length=4)
    cardholder_name = models.CharField(max_length=200)
    expiry_month = models.PositiveIntegerField()
    expiry_year = models.PositiveIntegerField()
    is_default = models.BooleanField(default=False)
    tokenized_ref = models.CharField(max_length=255, blank=True, default="")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-is_default", "-created_at"]

    def __str__(self):
        return f"{self.card_type} ending in {self.last_four}"
