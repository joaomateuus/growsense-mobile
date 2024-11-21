import 'package:flutter/material.dart';
import 'package:tcc_app/models/device.dart';
import 'package:tcc_app/screens/home/device/form.dart';
import 'package:tcc_app/viewmodel/home/device_viewmodel.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final deviceViewModel = DeviceViewModelImpl();
  List<Device> devices = [];
  bool isLoading = true;

  Future<void> loadDevices() async {
    try {
      final loadedDevices = await deviceViewModel.listDevices();
      setState(() {
        devices = loadedDevices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar cultivos: $e');
    }
  }

  Future<void> navigateToCreateDevice() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeviceFormPage()),
    );

    if (result == true) {
      loadDevices();
    }
  }

  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Listagem de Dispositivos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: navigateToCreateDevice,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : devices.isEmpty
                ? const Center(child: Text('Nenhum Device encontrado.'))
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return DeviceCard(device: device);
                    },
                  ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final Device device;

  const DeviceCard({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.serialNumber,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Text('Cultivo: ${device.cultivation.name}'),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Redireciona para a tela de edição do device
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceFormPage(
                          device: device, // Passe o objeto aqui
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
                            'Are you sure you want to delete this device?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Fecha o diálogo
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Lógica para deletar o device
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
      ),
    );
  }
}
