import 'package:tcc_app/services/device_service.dart';
import 'package:tcc_app/models/device.dart';

class DeviceRepository {
  final deviceService = DeviceService();

  Future<List<Device>> listDevices() async {
    final response = await deviceService.listDevices();

    return response;
  }

  Future<Device?> createDevice(Device data) async {
    final response = await deviceService.createDevice(data);

    return response;
  }
}
