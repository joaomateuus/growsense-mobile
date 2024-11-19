import 'package:tcc_app/services/api_service.dart';
import 'package:tcc_app/models/cultivation.dart';
import 'dart:convert';

class CultivationService {
  final ApiService apiService = ApiService();

  Future<List<Cultivation>> listCultivations() async {
    final response = await apiService.get("/api/cultivations/");

    final parsedJson = jsonDecode(response!.body);
    final data = Cultivation.fromJsonList(parsedJson);

    return data;
  }

  Future<Cultivation?> createCultivation(Cultivation data) async {
    final response = await apiService.post("/api/cultivations/", data.toJson());

    final parsedJson = jsonDecode(response!.body);
    final cultivation = Cultivation.fromJson(parsedJson);

    return cultivation;
  }
}
