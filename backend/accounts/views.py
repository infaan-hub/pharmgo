from rest_framework import viewsets, generics, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenRefreshView
from rest_framework_simplejwt.tokens import OutstandingToken, BlacklistedToken
from django.contrib.auth import get_user_model, authenticate
from django.core.mail import send_mail
from django.conf import settings
from django.utils import timezone
from .models import Address, PaymentMethod, OTP, PasswordResetToken
from .serializers import (
    UserRegisterSerializer,
    UserLoginSerializer,
    UserSerializer,
    AddressSerializer,
    PaymentMethodSerializer,
)

User = get_user_model()


class RegisterView(generics.CreateAPIView):
    serializer_class = UserRegisterSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        refresh = RefreshToken.for_user(user)
        return Response({
            "user": UserSerializer(user).data,
            "tokens": {
                "access": str(refresh.access_token),
                "refresh": str(refresh),
            },
        }, status=status.HTTP_201_CREATED)


class LoginView(generics.GenericAPIView):
    serializer_class = UserLoginSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        username = serializer.validated_data["username"]
        password = serializer.validated_data["password"]
        user = authenticate(request, username=username, password=password)
        if user is None:
            return Response(
                {"detail": "Invalid credentials."},
                status=status.HTTP_401_UNAUTHORIZED,
            )
        refresh = RefreshToken.for_user(user)
        return Response({
            "user": UserSerializer(user).data,
            "tokens": {
                "access": str(refresh.access_token),
                "refresh": str(refresh),
            },
        })


class LogoutView(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, *args, **kwargs):
        try:
            refresh_token = request.data.get("refresh")
            if refresh_token:
                token = RefreshToken(refresh_token)
                token.blacklist()
            else:
                for token in OutstandingToken.objects.filter(user=request.user):
                    _, _ = BlacklistedToken.objects.get_or_create(token=token)
        except Exception:
            pass
        return Response({"detail": "Successfully logged out."}, status=status.HTTP_200_OK)


class OTPRequestView(generics.GenericAPIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        if not email:
            return Response({"detail": "Email is required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({"detail": "If an account exists with this email, an OTP has been sent."},
                          status=status.HTTP_200_OK)

        OTP.cleanup_expired()

        raw_code, otp = OTP.generate(user, purpose="otp_verification", expiry_minutes=10)

        try:
            send_mail(
                subject="PharmGo - Your Verification Code",
                message=f"Your verification code is: {raw_code}\n\nThis code expires in 10 minutes.",
                from_email=settings.DEFAULT_FROM_EMAIL if hasattr(settings, 'DEFAULT_FROM_EMAIL') else settings.EMAIL_HOST_USER,
                recipient_list=[email],
                fail_silently=True,
            )
        except Exception:
            pass

        return Response({"detail": "OTP sent to your email."})


class OTPVerifyView(generics.GenericAPIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        otp_code = request.data.get("otp")

        if not email or not otp_code:
            return Response({"detail": "Email and OTP are required."},
                          status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({"detail": "Invalid OTP."},
                          status=status.HTTP_400_BAD_REQUEST)

        otp = OTP.objects.filter(
            user=user,
            purpose="otp_verification",
            is_used=False,
        ).order_by("-created_at").first()

        if otp is None:
            return Response({"detail": "No valid OTP found. Please request a new one."},
                          status=status.HTTP_400_BAD_REQUEST)

        if not otp.is_valid():
            return Response({"detail": "OTP has expired. Please request a new one."},
                          status=status.HTTP_400_BAD_REQUEST)

        if otp.verify(otp_code):
            return Response({"detail": "OTP verified successfully."})
        else:
            return Response({"detail": "Invalid OTP code."},
                          status=status.HTTP_400_BAD_REQUEST)


class PasswordResetView(generics.GenericAPIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        if not email:
            return Response({"detail": "Email is required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({"detail": "If an account exists with this email, a reset link has been sent."},
                          status=status.HTTP_200_OK)

        PasswordResetToken.cleanup_expired()

        raw_token, token = PasswordResetToken.generate(user, expiry_minutes=30)

        reset_url = f"{request.build_absolute_uri('/api/auth/password/reset/confirm/')}?token={raw_token}"

        try:
            send_mail(
                subject="PharmGo - Password Reset Request",
                message=(
                    f"Hi {user.username},\n\n"
                    f"You requested a password reset. Click the link below to reset your password:\n\n"
                    f"{reset_url}\n\n"
                    f"This link expires in 30 minutes.\n\n"
                    f"If you didn't request this, please ignore this email."
                ),
                from_email=settings.DEFAULT_FROM_EMAIL if hasattr(settings, 'DEFAULT_FROM_EMAIL') else settings.EMAIL_HOST_USER,
                recipient_list=[email],
                fail_silently=True,
            )
        except Exception:
            pass

        return Response({"detail": "If an account exists with this email, a reset link has been sent."})


class PasswordResetConfirmView(generics.GenericAPIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        token = request.data.get("token")
        new_password = request.data.get("new_password")
        new_password_confirm = request.data.get("new_password_confirm")

        if not token or not new_password or not new_password_confirm:
            return Response(
                {"detail": "Token, new_password, and new_password_confirm are required."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if new_password != new_password_confirm:
            return Response({"detail": "Passwords do not match."},
                          status=status.HTTP_400_BAD_REQUEST)

        if len(new_password) < 8:
            return Response({"detail": "Password must be at least 8 characters."},
                          status=status.HTTP_400_BAD_REQUEST)

        password_reset_token = PasswordResetToken.objects.filter(
            is_used=False,
        ).order_by("-created_at").first()

        if password_reset_token is None:
            return Response({"detail": "Invalid or expired reset token."},
                          status=status.HTTP_400_BAD_REQUEST)

        if not password_reset_token.is_valid():
            return Response({"detail": "Reset token has expired. Please request a new one."},
                          status=status.HTTP_400_BAD_REQUEST)

        if password_reset_token.verify(token):
            user = password_reset_token.user
            user.set_password(new_password)
            user.save()

            OutstandingToken.objects.filter(user=user).delete()

            return Response({"detail": "Password reset successfully."})
        else:
            return Response({"detail": "Invalid reset token."},
                          status=status.HTTP_400_BAD_REQUEST)


class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user


class AddressViewSet(viewsets.ModelViewSet):
    serializer_class = AddressSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Address.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class PaymentMethodViewSet(viewsets.ModelViewSet):
    serializer_class = PaymentMethodSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return PaymentMethod.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
