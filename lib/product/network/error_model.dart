import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'error_model.g.dart';

/// Global error model for API responses
///
/// All API errors should follow this format for consistent error handling
@JsonSerializable()
final class ProductErrorModel extends Equatable
    implements INetworkModel<ProductErrorModel> {
  const ProductErrorModel({
    this.success = false,
    this.message,
    this.errorCode,
    this.details,
  });

  factory ProductErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ProductErrorModelFromJson(json);

  /// Whether the request was successful (always false for errors)
  @JsonKey(defaultValue: false)
  final bool success;

  /// Human-readable error message
  final String? message;

  /// Machine-readable error code for specific handling
  final String? errorCode;

  /// Additional error details (field errors, etc.)
  final Map<String, dynamic>? details;

  @override
  ProductErrorModel fromJson(Map<String, dynamic> json) =>
      ProductErrorModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductErrorModelToJson(this);

  @override
  List<Object?> get props => [success, message, errorCode, details];

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
