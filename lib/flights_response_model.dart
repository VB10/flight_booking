class FlightsResponseModel {
  bool success;
  List<FlightModel> data;
  String message;

  FlightsResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FlightsResponseModel.fromJson(Map<String, dynamic> json) {
    List<FlightModel> flightList = [];
    if (json['data'] != null) {
      for (var item in json['data']) {
        flightList.add(FlightModel.fromJson(item));
      }
    }
    
    return FlightsResponseModel(
      success: json['success'] ?? false,
      data: flightList,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((flight) => flight.toJson()).toList(),
      'message': message,
    };
  }
}

class FlightModel {
  int id;
  String airline;
  String from;
  String to;
  String departureTime;
  String arrivalTime;
  int price;
  String duration;
  String date;

  FlightModel({
    required this.id,
    required this.airline,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.duration,
    required this.date,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] ?? 0,
      airline: json['airline'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      price: json['price'] ?? 0,
      duration: json['duration'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline,
      'from': from,
      'to': to,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'price': price,
      'duration': duration,
      'date': date,
    };
  }
}