import 'package:flutter/material.dart';
import 'package:tcc_app/models/cultivation.dart';
import 'package:tcc_app/models/device.dart';
import 'package:tcc_app/viewmodel/home/cultivation_viewmodel.dart';
import 'package:tcc_app/viewmodel/home/device_viewmodel.dart';

class DeviceFormPage extends StatefulWidget {
  const DeviceFormPage({Key? key}) : super(key: key);

  @override
  _DeviceFormPage createState() => _DeviceFormPage();
}

class _DeviceFormPage extends State<DeviceFormPage> {
  final deviceViewModel = DeviceViewModelImpl();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serialNumberController = TextEditingController();
  final cultivationViewModel = CultivationViewModelImpl();
  Cultivation? _selectedCultivation;

  void _navigateBackWithSuccess() {
    Navigator.pop(context, true);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void handleSubmit() async {
    try {
      if (!_formKey.currentState!.validate()) {
        print('Formulário inválido');
        return;
      }

      Device data = Device(
          serialNumber: _serialNumberController.text,
          cultivation: _selectedCultivation!);

      await deviceViewModel.createDevice(data);

      _showSnackBar("Device cadastrado com sucesso!!");
      _navigateBackWithSuccess();
    } catch (e) {
      final error = e;
      _showSnackBar("Erro ao cadastrar Device");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome input
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Select de planta
              FutureBuilder<List<Cultivation>>(
                future: cultivationViewModel
                    .listCultivations(), // Método que retorna a lista de plantas
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading plants');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No plants available');
                  }

                  final plants = snapshot.data!;

                  // Garante que o valor inicial de _selectedPlant é válido
                  if (_selectedCultivation == null ||
                      !plants.contains(_selectedCultivation)) {
                    _selectedCultivation =
                        plants.first; // Inicializa com o primeiro item da lista
                  }

                  return DropdownButtonFormField<Cultivation>(
                    value: _selectedCultivation,
                    decoration:
                        const InputDecoration(labelText: 'Selecione o Cultivo'),
                    items: plants.map((plant) {
                      return DropdownMenuItem<Cultivation>(
                        value: plant, // O valor é o objeto Plant
                        child: Text(plant.name), // Exibe o nome da planta
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCultivation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a plant';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 32),

              // Botão de envio
              ElevatedButton(
                onPressed: handleSubmit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
