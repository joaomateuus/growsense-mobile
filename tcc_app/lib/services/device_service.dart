import 'package:tcc_app/services/api_service.dart';
import 'package:tcc_app/models/device.dart';
import 'dart:convert';

class DeviceService {
  final ApiService apiService = ApiService();

  Future<List<Device>> listDevices() async {
    final response = await apiService.get("/api/device/");

    final parsedJson = jsonDecode(response!.body);
    final data = Device.fromJsonList(parsedJson);

    return data;
  }

  Future<Device?> createDevice(Device data) async {
    final response = await apiService.post("/api/device/", data.toJson());

    final parsedJson = jsonDecode(response!.body);
    final device = Device.fromJson(parsedJson);

    return device;
  }
}
