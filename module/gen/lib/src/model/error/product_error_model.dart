import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vexana/vexana.dart';

part 'product_error_model.freezed.dart';
part 'product_error_model.g.dart';

/// Global error model for API responses
///
/// All API errors should follow this format for consistent error handling.
/// It is the `E` of vexana's `NetworkManager<E extends INetworkModel<E>>`, so
/// vexana parses every error body through [fromJson] on a `const` instance.
@freezed
abstract class ProductErrorModel
    with _$ProductErrorModel
    implements INetworkModel<ProductErrorModel> {
  const factory ProductErrorModel({
    /// Whether the request was successful (always false for errors)
    @Default(false) bool success,

    /// Human-readable error message
    String? message,

    /// Machine-readable error code for specific handling
    String? errorCode,

    /// Additional error details (field errors, etc.)
    Map<String, dynamic>? details,
  }) = _ProductErrorModel;

  const ProductErrorModel._();

  factory ProductErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ProductErrorModelFromJson(json);

  @override
  ProductErrorModel fromJson(Map<String, dynamic> json) =>
      ProductErrorModel.fromJson(json);

  @override
  String toString() => 'ProductErrorModel(message: $message, code: $errorCode)';
}

/// Common error codes used across the application
final class ErrorCodes {
  const ErrorCodes._();

  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String notFound = 'NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String networkError = 'NETWORK_ERROR';
}
