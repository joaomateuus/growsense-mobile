import 'package:flutter/material.dart';
import 'package:tcc_app/models/plant.dart';
import 'package:tcc_app/viewmodel/home/home_viewmodel.dart';
import 'package:tcc_app/screens/home/plants/form.dart';
import 'package:tcc_app/viewmodel/home/plant.viewmodel.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({Key? key}) : super(key: key);

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final homeViewModel = HomeViewModelImpl();
  final plantViewModel = PlantViewModelImpl();
  List<Plant> plants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlants();
  }

  Future<void> navigateToCreatePlant(Plant? plant) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantFormPage(plant: plant)),
    );

    if (result == true) {
      loadPlants();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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

  void handleDelete(int plantId) async {
    final result = await plantViewModel.deletePlant(plantId);

    if (result) {
      _showSnackBar("Planta deletada com sucesso!!");
      loadPlants();
    } else {
      _showSnackBar("Não foi possivel deletar");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Suas Plantas 🌱',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () => navigateToCreatePlant(null),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : plants.isEmpty
              ? const Center(child: Text('Não há plantas cadastradas'))
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: 16.0,
                  ),
                  child: ListView.builder(
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      return PlantCard(
                        plant: plant,
                        handleDelete: handleDelete,
                        navigateToCreatePlant: navigateToCreatePlant,
                      );
                    },
                  ),
                ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;
  final Function(int) handleDelete;
  final Function(Plant?) navigateToCreatePlant;

  const PlantCard({
    Key? key,
    required this.plant,
    required this.handleDelete,
    required this.navigateToCreatePlant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/thumbnails/023/742/329/small_2x/banana-plant-in-flowerpot-illustration-ai-generative-free-png.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigateToCreatePlant(plant);
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
                        title: Text('Editar'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Excluir'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildInfoRow(
                    Icons.thermostat, '${plant.temperature}°C', Colors.blue),
                _buildInfoRow(
                    Icons.water_drop, '${plant.soilMoisture}%', Colors.green),
                _buildInfoRow(
                    Icons.wb_sunny, '${plant.lightIntensity} lx', Colors.amber),
                _buildInfoRow(
                    Icons.cloud, '${plant.airHumidity}%', Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this plant?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                handleDelete(plant.id!);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
