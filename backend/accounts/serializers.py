from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from .models import Address, PaymentMethod

User = get_user_model()


class UserRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            "id", "email", "username", "password", "password_confirm",
            "first_name", "last_name", "phone", "role",
        ]

    def validate(self, attrs):
        if attrs["password"] != attrs["password_confirm"]:
            raise serializers.ValidationError({"password_confirm": "Passwords do not match."})
        return attrs

    def create(self, validated_data):
        validated_data.pop("password_confirm")
        password = validated_data.pop("password")
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user


class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            "id", "email", "username", "first_name", "last_name",
            "phone", "role", "created_at", "updated_at",
        ]
        read_only_fields = ["id", "email", "role", "created_at", "updated_at"]


class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = [
            "id", "user", "name", "address_line1", "address_line2",
            "city", "state", "zip_code", "country", "is_default",
            "lat", "lng", "created_at",
        ]
        read_only_fields = ["id", "user", "created_at"]


class PaymentMethodSerializer(serializers.ModelSerializer):
    class Meta:
        model = PaymentMethod
        fields = [
            "id", "user", "card_type", "last_four", "cardholder_name",
            "expiry_month", "expiry_year", "is_default", "tokenized_ref", "created_at",
        ]
        read_only_fields = ["id", "user", "tokenized_ref", "created_at"]
