import 'package:flutter/material.dart';
import 'package:tcc_app/models/cultivation.dart';
import 'package:tcc_app/models/plant.dart';
import 'package:tcc_app/models/user_session.dart';
import 'package:tcc_app/viewmodel/home/cultivation_viewmodel.dart';
import 'package:tcc_app/viewmodel/home/plant.viewmodel.dart';
import 'package:tcc_app/viewmodel/home/device_viewmodel.dart';
import 'package:tcc_app/models/device.dart';

class CultivationFormPage extends StatefulWidget {
  final Cultivation? cultivation;

  const CultivationFormPage({Key? key, this.cultivation}) : super(key: key);

  @override
  _CultivationFormPage createState() => _CultivationFormPage();
}

class _CultivationFormPage extends State<CultivationFormPage> {
  final cultivationViewModel = CultivationViewModelImpl();
  final plantViewModel = PlantViewModelImpl();
  final deviceViewModel = DeviceViewModelImpl();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  Plant? _selectedPlant;
  Device? _selectedDevice;

  @override
  void initState() {
    super.initState();
    // Preencher os campos se estiver editando
    if (widget.cultivation != null) {
      _nameController.text = widget.cultivation!.name;
      _selectedPlant = widget.cultivation!.plant;
    }
  }

  void _navigateBackWithSuccess() {
    Navigator.pop(context, true);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      print('Formulário inválido');
      return;
    }

    UserSession? user = UserSession.getSession();
    Cultivation data = Cultivation(
        name: _nameController.text,
        plant: _selectedPlant!,
        user: user!.user,
        device: _selectedDevice!);

    final response = await cultivationViewModel.createCultivation(data);

    if (response != null) {
      _showSnackBar("Cultivo cadastrado com sucesso!!");
      _navigateBackWithSuccess();
    } else {
      _showSnackBar("Erro ao cadastrar Cultivo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cultivation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Cultivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              FutureBuilder<List<Plant>>(
                future: plantViewModel
                    .listPlants(), // Método que retorna a lista de plantas
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    _showSnackBar("Erro ao carregar plantas");
                    // return const SizedBox.shrink();
                  }
                  // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //   return const SizedBox.shrink();
                  // }

                  final plants = snapshot.data ?? [];

                  // Garante que o valor inicial de _selectedPlant é válido
                  if (plants.isNotEmpty) {
                    // Garante que o valor inicial de _selectedPlant é válido
                    if (_selectedPlant == null ||
                        !plants.contains(_selectedPlant)) {
                      _selectedPlant = plants
                          .first; // Inicializa com o primeiro item da lista
                    }
                  } else {
                    _selectedPlant =
                        null; // Define como null se a lista estiver vazia
                  }

                  return DropdownButtonFormField<Plant>(
                    value: _selectedPlant,
                    decoration:
                        const InputDecoration(labelText: 'Select Plant'),
                    items: plants.map((plant) {
                      return DropdownMenuItem<Plant>(
                        value: plant, // O valor é o objeto Plant
                        child: Text(plant.name), // Exibe o nome da planta
                      );
                    }).toList(),
                    onChanged: plants.isNotEmpty
                        ? (value) {
                            setState(() {
                              _selectedPlant = value;
                            });
                          }
                        : null, // Desabilita o campo se não houver plantas
                    validator: (value) {
                      if (value == null && plants.isNotEmpty) {
                        return 'Please select a plant';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              FutureBuilder<List<Device>>(
                future: deviceViewModel
                    .listDevices(), // Método que retorna a lista de plantas
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    _showSnackBar("Erro ao carregar devices");
                    // return const SizedBox.shrink();
                  }
                  // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //   return const SizedBox.shrink();
                  // }

                  final devices = snapshot.data ?? [];

                  // Garante que o valor inicial de _selectedPlant é válido
                  if (devices.isNotEmpty) {
                    // Garante que o valor inicial de _selectedDevice é válido
                    if (_selectedDevice == null ||
                        !devices.contains(_selectedDevice)) {
                      _selectedDevice = devices
                          .first; // Inicializa com o primeiro item da lista
                    }
                  } else {
                    _selectedDevice =
                        null; // Define como null se a lista estiver vazia
                  }

                  return DropdownButtonFormField<Device>(
                    value: _selectedDevice,
                    decoration:
                        const InputDecoration(labelText: 'Select Plant'),
                    items: devices.map((device) {
                      return DropdownMenuItem<Device>(
                        value: device, // O valor é o objeto Device
                        child: Text(device
                            .serialNumber), // Exibe o serial do dispositivo
                      );
                    }).toList(),
                    onChanged: devices.isNotEmpty
                        ? (value) {
                            setState(() {
                              _selectedDevice = value;
                            });
                          }
                        : null, // Desabilita o campo se não houver dispositivos
                    validator: (value) {
                      if (value == null && devices.isNotEmpty) {
                        return 'Please select a device';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 32),
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
