from rest_framework import viewsets, permissions, status, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Cart, CartItem
from .serializers import (
    CartSerializer,
    CartItemSerializer,
    AddCartItemSerializer,
    UpdateCartItemSerializer,
)


class CartView(generics.RetrieveAPIView):
    serializer_class = CartSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        cart, _ = Cart.objects.get_or_create(user=self.request.user)
        return cart


class CartItemViewSet(viewsets.ModelViewSet):
    serializer_class = CartItemSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        cart, _ = Cart.objects.get_or_create(user=self.request.user)
        return CartItem.objects.filter(cart=cart)

    def create(self, request, *args, **kwargs):
        serializer = AddCartItemSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        cart, _ = Cart.objects.get_or_create(user=request.user)
        medicine_id = serializer.validated_data["medicine_id"]
        quantity = serializer.validated_data["quantity"]

        from catalog.models import Medicine
        try:
            medicine = Medicine.objects.get(id=medicine_id, is_active=True)
        except Medicine.DoesNotExist:
            return Response(
                {"detail": "Medicine not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        if medicine.stock_quantity < quantity:
            return Response(
                {"detail": "Insufficient stock."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        cart_item, created = CartItem.objects.get_or_create(
            cart=cart, medicine=medicine, defaults={"quantity": quantity}
        )
        if not created:
            cart_item.quantity += quantity
            if cart_item.quantity > medicine.stock_quantity:
                return Response(
                    {"detail": "Insufficient stock."},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            cart_item.save()

        return Response(CartItemSerializer(cart_item).data, status=status.HTTP_201_CREATED)

    def partial_update(self, request, *args, **kwargs):
        item = self.get_object()
        serializer = UpdateCartItemSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        quantity = serializer.validated_data["quantity"]
        if quantity > item.medicine.stock_quantity:
            return Response(
                {"detail": "Insufficient stock."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        item.quantity = quantity
        item.save()
        return Response(CartItemSerializer(item).data)

    @action(detail=False, methods=["delete"], permission_classes=[permissions.IsAuthenticated])
    def clear(self, request):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        cart.items.all().delete()
        return Response({"detail": "Cart cleared."})
