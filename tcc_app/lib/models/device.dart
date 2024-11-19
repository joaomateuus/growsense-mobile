import 'package:tcc_app/models/cultivation.dart';

class Device {
  int? id;
  final String serialNumber;
  final Cultivation cultivation;

  Device({
    this.id,
    required this.serialNumber,
    required this.cultivation,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int?,
      serialNumber: json['serial_number'] as String,
      cultivation:
          Cultivation.fromJson(json['cultivation'] as Map<String, dynamic>),
    );
  }

  static List<Device> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Device.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson(bool forCreation) {
    return {
      'serial_number': serialNumber,
      'cultivation': forCreation ? cultivation.id : cultivation.toJson(),
    };
  }
}
