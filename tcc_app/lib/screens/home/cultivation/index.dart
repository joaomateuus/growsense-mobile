import 'package:flutter/material.dart';
import 'package:tcc_app/models/cultivation.dart';
import 'package:tcc_app/screens/home/cultivation/form.dart';
import 'package:tcc_app/screens/home/device_data/index.dart';
import 'package:tcc_app/viewmodel/home/cultivation_viewmodel.dart';

class CultivationPage extends StatefulWidget {
  const CultivationPage({Key? key}) : super(key: key);

  @override
  State<CultivationPage> createState() => _CultivationPageState();
}

class _CultivationPageState extends State<CultivationPage> {
  final cultivationViewModel = CultivationViewModelImpl();
  List<Cultivation> cultivations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCultivations();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> loadCultivations() async {
    try {
      final loadedCultivations = await cultivationViewModel.listCultivations();
      setState(() {
        cultivations = loadedCultivations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar cultivos: $e');
    }
  }

  Future<void> deleteCultivation(int cultivationId) async {
    setState(() {
      isLoading = true; // Mostra um indicador de carregamento
    });

    try {
      final result =
          await cultivationViewModel.deleteCultivation(cultivationId);
      if (result) {
        _showSnackBar('Cultivo excluído com sucesso!');
        await loadCultivations(); // Recarrega a lista após exclusão
      } else {
        _showSnackBar('Erro ao excluir cultivo.');
      }
    } catch (e) {
      _showSnackBar('Erro ao excluir cultivo: $e');
    } finally {
      setState(() {
        isLoading = false; // Remove o indicador de carregamento
      });
    }
  }

  Future<void> navigateToCreateCultivation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CultivationFormPage()),
    );

    if (result == true) {
      loadCultivations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Seus Cultivos 🌳'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              navigateToCreateCultivation();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : cultivations.isEmpty
                ? const Center(child: Text('Nenhum cultivo encontrado.'))
                : ListView.builder(
                    itemCount: cultivations.length,
                    itemBuilder: (context, index) {
                      final cultivation = cultivations[index];
                      return CultivationCard(
                        cultivation: cultivation,
                        reloadCultivations: loadCultivations,
                        onDelete: () => deleteCultivation(
                            cultivation.id!), // Passa o ID para exclusão
                      );
                    },
                  ),
      ),
    );
  }
}

class CultivationCard extends StatelessWidget {
  final Cultivation cultivation;
  final VoidCallback reloadCultivations;
  final VoidCallback onDelete;

  const CultivationCard({
    Key? key,
    required this.cultivation,
    required this.reloadCultivations,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: InkWell(
        onTap: () {
          // Redireciona para a página de dados do cultivo
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDataPage(
                  cultivationId: cultivation.id!), // Página de dados
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cultivation.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Planta: ${cultivation.plant.name}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CultivationFormPage(
                              cultivation: cultivation,
                            ),
                          ),
                        ).then((_) => reloadCultivations());
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit, color: Colors.blue),
                          title: Text('Editar Cultivo'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Excluir Cultivo'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ExpansionTile(
                title: const Center(
                  child: Text(
                    'Parâmetros de Cultivo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                children: [
                  _buildInfoRow(
                      'Temperatura', '${cultivation.plant.temperature}°C'),
                  _buildInfoRow(
                      'Umidade do Solo', '${cultivation.plant.soilMoisture}%'),
                  _buildInfoRow(
                      'Umidade do Ar', '${cultivation.plant.airHumidity}%'),
                  _buildInfoRow('Intensidade de Luz',
                      '${cultivation.plant.lightIntensity} lx'),
                  _buildInfoRow('Sensor de Chuva',
                      cultivation.plant.rainSensor.toString()),
                  _buildInfoRow('Status da Bomba de Água',
                      cultivation.plant.waterPumpStatus ?? 'N/A'),
                  _buildInfoRow(
                      'Status do Relé', cultivation.plant.relayStatus ?? 'N/A'),
                  _buildInfoRow(
                    'Última Atualização',
                    cultivation.plant.lastUpdated != null
                        ? cultivation.plant.lastUpdated!.toLocal().toString()
                        : 'N/A',
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir este cultivo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
