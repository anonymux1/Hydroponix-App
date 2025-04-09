class CartProduct {
final String productId;
final String variantId;
int quantity;

CartProduct({
  required this.productId,
  required this.variantId,
  this.quantity = 1,
});

Map<String, dynamic> toFirestore() {
  return {
    'productId': productId,
    'variantId': variantId,
    'quantity': quantity,
  };
}

factory CartProduct.fromFirestore(Map<String, dynamic> data) {
return CartProduct(
productId: data['productId'],
variantId: data['variantId'],
quantity: data['quantity'] ?? 1,
);
}
}