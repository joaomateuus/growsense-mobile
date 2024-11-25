import 'package:flutter/material.dart';
import 'package:tcc_app/models/device_data.dart';
import 'package:tcc_app/viewmodel/home/devicedata_viewmodel.dart';

class PlantDataPage extends StatefulWidget {
  final int cultivationId;

  const PlantDataPage({Key? key, required this.cultivationId})
      : super(key: key);

  @override
  State<PlantDataPage> createState() => _PlantDataPage();
}

class _PlantDataPage extends State<PlantDataPage> {
  DeviceData? deviceData;
  bool isLoading = true;

  final deviceDataViewModel = DeviceDataViewModelImpl();

  @override
  void initState() {
    super.initState();
    loadDeviceData();
  }

  Future<void> loadDeviceData() async {
    try {
      final data =
          await deviceDataViewModel.getDeviceData(widget.cultivationId);
      setState(() {
        deviceData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar dados do dispositivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Macaxeira',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : deviceData == null
              ? const Center(
                  child: Text(
                    'Nenhum dado encontrado para este dispositivo.',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Imagem da planta
                        Image.network(
                          'https://static.vecteezy.com/system/resources/thumbnails/023/742/329/small_2x/banana-plant-in-flowerpot-illustration-ai-generative-free-png.png',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        // Cartões de métricas
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildInfoCard(deviceData!.temperature.toString(),
                                'Temperatura'),
                            _buildInfoCard(deviceData!.soilMoisture.toString(),
                                'Humidade do Solo'),
                            _buildInfoCard(deviceData!.airHumidity.toString(),
                                'Humidade do Ar'),
                            _buildInfoCard(
                                deviceData!.lightIntensity.toString(),
                                'Intensidade da Luz'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Informações sobre rega
                        const Text(
                          'Última Atualização',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Mon, Oct 31, 7:57 AM',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Widget para os cartões de informações
  Widget _buildInfoCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
