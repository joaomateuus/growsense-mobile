class Plant {
  int? id;
  final String name;
  double? temperature;
  double? soilMoisture;
  double? airHumidity;
  double? lightIntensity;
  double? rainSensor;
  String? waterPumpStatus;
  String? relayStatus;
  DateTime? lastUpdated;

  Plant(
      {this.id,
      required this.name,
      this.temperature,
      this.soilMoisture,
      this.airHumidity,
      this.lightIntensity,
      this.rainSensor,
      this.waterPumpStatus,
      this.relayStatus,
      this.lastUpdated});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as int?,
      name: json['name'] as String,
      temperature: (json['temperature'] as num?)?.toDouble(),
      soilMoisture: (json['soil_moisture'] as num?)?.toDouble(),
      airHumidity: (json['air_humidity'] as num?)?.toDouble(),
      lightIntensity: (json['light_intensity'] as num?)?.toDouble(),
      rainSensor: (json['rain_sensor'] as num?)?.toDouble(),
      waterPumpStatus: json['water_pump_status'] as String?,
      relayStatus: json['relay_status'] as String?,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'temperature': temperature,
      'soil_moisture': soilMoisture,
      'air_humidity': airHumidity,
      'light_intensity': lightIntensity,
      'rain_sensor': rainSensor,
      'water_pump_status': waterPumpStatus,
      'relay_status': relayStatus,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static List<Plant> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Plant.fromJson(json)).toList();
  }
}
