from rest_framework import viewsets, generics, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.db import transaction
from .models import Order, OrderItem
from .serializers import (
    OrderSerializer,
    CreateOrderSerializer,
    OrderStatusSerializer,
    OrderItemSerializer,
)
from cart.models import Cart
from accounts.models import Address, PaymentMethod
from catalog.models import Medicine
from notifications.models import Notification


class OrderViewSet(viewsets.ModelViewSet):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        if self.request.user.role in ("pharmacist", "admin"):
            return Order.objects.all()
        return Order.objects.filter(user=self.request.user)

    @transaction.atomic
    def create(self, request, *args, **kwargs):
        serializer = CreateOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        try:
            address = Address.objects.get(
                id=serializer.validated_data["address_id"], user=request.user
            )
        except Address.DoesNotExist:
            return Response(
                {"detail": "Address not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        try:
            payment_method = PaymentMethod.objects.get(
                id=serializer.validated_data["payment_method_id"], user=request.user
            )
        except PaymentMethod.DoesNotExist:
            return Response(
                {"detail": "Payment method not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        try:
            cart = Cart.objects.get(user=request.user)
        except Cart.DoesNotExist:
            return Response(
                {"detail": "Cart is empty."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        cart_items = cart.items.select_related("medicine").all()
        if not cart_items.exists():
            return Response(
                {"detail": "Cart is empty."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        for cart_item in cart_items:
            if cart_item.medicine.requires_prescription:
                from prescriptions.models import Prescription
                has_approved = Prescription.objects.filter(
                    user=request.user,
                    status="approved",
                    linked_medicines=cart_item.medicine,
                ).exists()
                if not has_approved:
                    return Response(
                        {"detail": f"'{cart_item.medicine.name}' requires an approved prescription."},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

        subtotal = float(cart.subtotal)
        delivery_fee = float(cart.delivery_fee)
        total = subtotal + delivery_fee

        order = Order.objects.create(
            user=request.user,
            address=address,
            payment_method=payment_method,
            status="placed",
            subtotal=subtotal,
            delivery_fee=delivery_fee,
            total=total,
        )

        for cart_item in cart_items:
            OrderItem.objects.create(
                order=order,
                medicine=cart_item.medicine,
                quantity=cart_item.quantity,
                price_at_purchase=cart_item.medicine.price,
            )
            medicine = cart_item.medicine
            medicine.stock_quantity -= cart_item.quantity
            medicine.save()

        cart.items.all().delete()

        Notification.objects.create(
            user=request.user,
            type="order",
            title="Order Placed",
            body=f"Your order #{order.pk} has been placed successfully.",
        )

        return Response(OrderSerializer(order).data, status=status.HTTP_201_CREATED)

    @action(detail=True, methods=["patch"], url_path="status", permission_classes=[permissions.IsAuthenticated])
    def status_update(self, request, pk=None):
        order = self.get_object()
        serializer = OrderStatusSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        new_status = serializer.validated_data["status"]

        valid_transitions = {
            "placed": ["confirmed", "cancelled"],
            "confirmed": ["verifying", "cancelled"],
            "verifying": ["out_for_delivery", "cancelled"],
            "out_for_delivery": ["delivered"],
            "delivered": [],
            "cancelled": [],
        }

        if new_status not in valid_transitions.get(order.status, []):
            return Response(
                {"detail": f"Cannot transition from '{order.status}' to '{new_status}'."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        order.status = new_status
        order.save()

        status_messages = {
            "confirmed": "Your order has been confirmed.",
            "verifying": "Your order is being verified.",
            "out_for_delivery": "Your order is out for delivery.",
            "delivered": "Your order has been delivered.",
            "cancelled": "Your order has been cancelled.",
        }

        Notification.objects.create(
            user=order.user,
            type="order",
            title=f"Order {new_status.replace('_', ' ').title()}",
            body=status_messages.get(new_status, f"Order status updated to {new_status}."),
        )

        return Response(OrderSerializer(order).data)

    @action(detail=True, methods=["post"], permission_classes=[permissions.IsAuthenticated])
    def reorder(self, request, pk=None):
        original_order = self.get_object()

        try:
            cart = Cart.objects.get(user=request.user)
        except Cart.DoesNotExist:
            cart = Cart.objects.create(user=request.user)

        for order_item in original_order.items.select_related("medicine").all():
            if order_item.medicine and order_item.medicine.is_active and order_item.medicine.stock_quantity >= order_item.quantity:
                from cart.models import CartItem
                cart_item, created = CartItem.objects.get_or_create(
                    cart=cart,
                    medicine=order_item.medicine,
                    defaults={"quantity": order_item.quantity},
                )
                if not created:
                    cart_item.quantity += order_item.quantity
                    cart_item.save()

        return Response({"detail": "Items added to cart."})
