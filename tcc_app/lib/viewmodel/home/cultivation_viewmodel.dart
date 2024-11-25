import "package:tcc_app/models/cultivation.dart";
import "package:tcc_app/repository/home/cultivation_repository.dart";

abstract class CultivationViewModel {}

class CultivationViewModelImpl {
  final cultivationRepostory = CultivationRepository();

  Future<List<Cultivation>> listCultivations() async {
    final response = await cultivationRepostory.listCultivation();

    return response;
  }

  Future<Cultivation?> createCultivation(Cultivation data) async {
    final response = await cultivationRepostory.createCultivation(data);

    return response;
  }

  Future<Cultivation?> updateCultivation(
      int cultivationId, Cultivation data) async {
    final response =
        await cultivationRepostory.updateCultivation(cultivationId, data);

    return response;
  }

  Future<bool> deleteCultivation(int cultivationId) async {
    final response =
        await cultivationRepostory.deleteCultivation(cultivationId);
    return response;
  }
}
