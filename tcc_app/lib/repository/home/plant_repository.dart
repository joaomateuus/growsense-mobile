import 'package:tcc_app/services/plants_service.dart';
import 'package:tcc_app/models/plant.dart';

class PlantRespository {
  final plantService = PlantService();

  Future<List<Plant>> listPlants() async {
    final response = await plantService.listPlants();

    return response;
  }

  Future<Plant?> createPlants(Plant data) async {
    final response = await plantService.createPlant(data);

    return response;
  }

  Future<Plant?> updatePlant(int plantId, Plant data) async {
    final response = await plantService.updatePlant(plantId, data);

    return response;
  }

  Future<bool> deletePlant(int plantId) async {
    final response = await plantService.deletePlant(plantId);

    return response;
  }
}
