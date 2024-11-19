import "package:tcc_app/repository/home/device_repository.dart";
import "package:tcc_app/models/device.dart";

abstract class DeviceViewModel {}

class DeviceViewModelImpl {
  final deviceRepository = DeviceRepository();

  Future<List<Device>> listDevices() async {
    final response = await deviceRepository.listDevices();

    return response;
  }

  Future<Device?> createDevice(Device data) async {
    final response = await deviceRepository.createDevice(data);

    return response;
  }

  Future<Device?> updateDevice(Device data) async {
    final response = await deviceRepository.createDevice(data);

    return response;
  }
}
