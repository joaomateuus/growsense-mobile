import 'package:tcc_app/services/cultivations_service.dart';
import 'package:tcc_app/models/cultivation.dart';

class CultivationRepository {
  final cultivationService = CultivationService();

  Future<List<Cultivation>> listCultivation() async {
    final response = await cultivationService.listCultivations();

    return response;
  }

  Future<Cultivation?> createCultivation(Cultivation data) async {
    final response = await cultivationService.createCultivation(data);

    return response;
  }
}
