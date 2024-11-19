class DeviceData {
  int? id;
  final int deviceId;
  final String serialNumber;
  final double temperature;
  final double soilMoisture;
  final double airHumidity;
  final double lightIntensity;
  final bool rain;
  final String systemStatus;
  final String? errors;
  final DateTime timestamp;

  DeviceData({
    this.id,
    required this.deviceId,
    required this.serialNumber,
    required this.temperature,
    required this.soilMoisture,
    required this.airHumidity,
    required this.lightIntensity,
    required this.rain,
    required this.systemStatus,
    this.errors,
    required this.timestamp,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      id: json['id'] as int?,
      deviceId: json['device'] as int,
      serialNumber: json['serial_number'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      soilMoisture: (json['soil_moisture'] as num).toDouble(),
      airHumidity: (json['air_humidity'] as num).toDouble(),
      lightIntensity: (json['light_intensity'] as num).toDouble(),
      rain: json['rain'] as bool,
      systemStatus: json['system_status'] as String,
      errors: json['errors'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device': deviceId,
      'serial_number': serialNumber,
      'temperature': temperature,
      'soil_moisture': soilMoisture,
      'air_humidity': airHumidity,
      'light_intensity': lightIntensity,
      'rain': rain,
      'system_status': systemStatus,
      'errors': errors,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
