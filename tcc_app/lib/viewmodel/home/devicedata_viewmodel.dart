import "package:tcc_app/repository/home/device_repository.dart";
import "package:tcc_app/models/device_data.dart";

abstract class DeviceDataViewModel {}

class DeviceDataViewModelImpl {
  final deviceRepository = DeviceRepository();

  Future<DeviceData> getDeviceData(int cultivationId) async {
    final response = await deviceRepository.getDeviceData(cultivationId);
    return response;
  }
}
