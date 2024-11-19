import "package:tcc_app/repository/home/plant_repository.dart";
import "package:tcc_app/models/plant.dart";

abstract class PlantViewModel {}

class PlantViewModelImpl {
  final plantRespository = PlantRespository();

  Future<List<Plant>> listPlants() async {
    final response = await plantRespository.listPlants();

    return response;
  }

  Future<Plant?> createPlant(Plant data) async {
    final response = await plantRespository.createPlants(data);

    return response;
  }

  Future<Plant?> updatePlant(int plantId, Plant data) async {
    final response = await plantRespository.updatePlant(plantId, data);

    return response;
  }

  Future<bool> deletePlant(int plantId) async {
    final response = await plantRespository.deletePlant(plantId);

    return response;
  }
}
