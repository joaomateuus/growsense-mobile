import 'package:flutter/material.dart';
import 'package:tcc_app/models/plant.dart';
import 'package:tcc_app/viewmodel/home/home_viewmodel.dart';
import 'package:tcc_app/screens/home/plants/form.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({Key? key}) : super(key: key);

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final homeViewModel = HomeViewModelImpl();
  List<Plant> plants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlants();
  }

  Future<void> loadPlants() async {
    try {
      final loadedPlants = await homeViewModel.listPlants();
      setState(() {
        plants = loadedPlants;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar plantas: $e');
    }
  }

  Future<void> navigateToCreatePlant() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlantFormPage()),
    );

    if (result == true) {
      loadPlants();
    }
  }

  void logout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Listagem de Plantas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              navigateToCreatePlant();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : plants.isEmpty
                      ? const Center(child: Text('Nenhuma planta encontrada.'))
                      : ListView.builder(
                          itemCount: plants.length,
                          itemBuilder: (context, index) {
                            final plant = plants[index];
                            return PlantCard(plant: plant);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plant.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Redireciona para a tela de edição
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantFormPage(
                              plant: plant, // Passe o objeto aqui
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
                                'Are you sure you want to delete this plant?'),
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
                  ],
                ),
              ],
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: Image.asset(
            //     'assets/images/laranja.png',
            //     height: 150,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(height: 8),
            Text('Temperature: ${plant.temperature}°C'),
            Text('Soil Moisture: ${plant.soilMoisture}%'),
            Text('Air Humidity: ${plant.airHumidity}%'),
            Text('Light Intensity: ${plant.lightIntensity} lx'),
            Text('Rain Sensor: ${plant.rainSensor}'),
            Text('Water Pump: ${plant.waterPumpStatus}'),
            Text('Relay Status: ${plant.relayStatus}'),
            const SizedBox(height: 8),
            Text(
              'Last Updated: ${plant.lastUpdated}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
