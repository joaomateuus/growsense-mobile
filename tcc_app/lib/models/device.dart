class Device {
  int? id;
  final String serialNumber;

  Device({
    this.id,
    required this.serialNumber,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int?,
      serialNumber: json['serial_number'] as String,
    );
  }

  static List<Device> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Device.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'serial_number': serialNumber,
    };
  }
}
