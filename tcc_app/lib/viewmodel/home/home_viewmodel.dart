import "package:tcc_app/repository/home/plant_repository.dart";
import "package:tcc_app/models/plant.dart";

abstract class HomeViewModel {}

class HomeViewModelImpl {
  final plantRespository = PlantRespository();
  List<Plant> plants = [];

  Future<List<Plant>> listPlants() async {
    final response = await plantRespository.listPlants();

    return response;
  }
}
