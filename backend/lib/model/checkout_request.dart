/// Body of POST /checkout.
///
/// The Flutter app sends the same JSON as module/gen's CheckoutRequestModel.
class CheckoutRequest {
  final List<Map<String, dynamic>> cartItems;
  final String userEmail;

  const CheckoutRequest({required this.cartItems, required this.userEmail});

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) {
    final rawItems = json['cartItems'] as List? ?? const [];
    return CheckoutRequest(
      cartItems: [
        for (final item in rawItems) Map<String, dynamic>.from(item as Map),
      ],
      userEmail: json['userEmail'] as String? ?? 'unknown@test.com',
    );
  }

  /// Sum of every item's `price` (int).
  int get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item['price'] as int));
}
