// lib/pages/cultivation_page.dart
import 'package:flutter/material.dart';
import 'package:tcc_app/models/cultivation.dart';
import 'package:tcc_app/screens/home/cultivation/form.dart';
// import 'package:tcc_app/models/plant.dart';
// import 'package:tcc_app/models/user.dart';
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
      print('Erro ao carregar plantas: $e');
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
  void initState() {
    super.initState();
    loadCultivations();
  }

  void logout(BuildContext context) {
    // Implementar lógica de logout se necessário
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Listagem de Cultivos'),
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
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : cultivations.isEmpty
                ? const Center(child: Text('Nenhum cultivo encontrado.'))
                : ListView.builder(
                    itemCount: cultivations.length,
                    itemBuilder: (context, index) {
                      final cultivation = cultivations[index];
                      return CultivationCard(cultivation: cultivation);
                    },
                  ),
      ),
    );
  }
}

class CultivationCard extends StatelessWidget {
  final Cultivation cultivation;

  const CultivationCard({Key? key, required this.cultivation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          cultivation.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Plant: ${cultivation.plant.name}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.nature, color: Colors.green),
              onPressed: () {
                // Redireciona para a tela de edição
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CultivationFormPage(
                      cultivation: cultivation, // Passe o objeto aqui
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Redireciona para a tela de edição
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CultivationFormPage(
                      cultivation: cultivation, // Passe o objeto aqui
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Mostra um diálogo de confirmação antes de deletar
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to delete this cultivation?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Fecha o diálogo
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Insira a lógica para deletar aqui
                          Navigator.pop(context); // Fecha o diálogo
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Icon(Icons.keyboard_arrow_down), // Seta de expansão
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Centraliza o conteúdo horizontalmente
              children: [
                // Título centralizado
                const Text(
                  'Parâmetros de Cultivo',
                  style: TextStyle(
                    fontSize: 15, // Tamanho da fonte do título
                    fontWeight: FontWeight.bold, // Negrito
                  ),
                ),
                const SizedBox(
                    height: 20), // Espaçamento entre o título e os dados
                _buildInfoRow('Usuário ID', cultivation.user.username),
                _buildInfoRow(
                    'Temperatura', '${cultivation.plant.temperature}°C'),
                _buildInfoRow(
                    'Umidade do Solo', '${cultivation.plant.soilMoisture}%'),
                _buildInfoRow(
                    'Umidade do Ar', '${cultivation.plant.airHumidity}%'),
                _buildInfoRow('Intensidade de Luz',
                    '${cultivation.plant.lightIntensity} lx'),
                _buildInfoRow(
                    'Sensor de Chuva', cultivation.plant.rainSensor.toString()),
                _buildInfoRow('Status da Bomba de Água',
                    cultivation.plant.waterPumpStatus ?? 'N/A'),
                _buildInfoRow(
                    'Status do Relé', cultivation.plant.relayStatus ?? 'N/A'),
                _buildInfoRow(
                    'Última Atualização',
                    cultivation.plant.lastUpdated != null
                        ? cultivation.plant.lastUpdated!.toLocal().toString()
                        : 'N/A'),
              ],
            ),
          ),
        ],
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
              child: Text('$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
