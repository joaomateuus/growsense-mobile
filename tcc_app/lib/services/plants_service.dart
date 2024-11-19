import 'dart:convert';

import 'package:tcc_app/services/api_service.dart';
import 'package:tcc_app/models/plant.dart';

class PlantService {
  final ApiService apiService = ApiService();

  Future<List<Plant>> listPlants() async {
    final response = await apiService.get("/api/plants/");

    final parsedJson = jsonDecode(response!.body);
    final plants = Plant.fromJsonList(parsedJson);

    return plants;
  }

  Future<Plant?> createPlant(Plant data) async {
    final response = await apiService.post("/api/plants/", data.toJson());

    final parsedJson = jsonDecode(response!.body);
    final plants = Plant.fromJson(parsedJson);

    return plants;
  }
}
