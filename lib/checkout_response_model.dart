class CheckoutResponseModel {
  bool success;
  String message;
  int orderId;
  int totalPrice;

  CheckoutResponseModel({
    required this.success,
    required this.message,
    required this.orderId,
    required this.totalPrice,
  });

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckoutResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      orderId: json['orderId'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'orderId': orderId,
      'totalPrice': totalPrice,
    };
  }
}