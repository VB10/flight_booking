/// Data models (request/response/cache DTOs) for the flight_booking app.
///
/// Every model is a freezed class with a json_serializable codec. Cubit states
/// do NOT live here — they stay next to their cubits.
library;

export 'src/model/cache/auth_session_cache_model.dart';
export 'src/model/error/product_error_model.dart';
export 'src/model/request/checkout_request_model.dart';
export 'src/model/request/login_request_model.dart';
export 'src/model/response/checkout_response_model.dart';
export 'src/model/response/flights_response_model.dart';
export 'src/model/response/login_response_model.dart';
export 'src/model/response/profile_response_model.dart';
