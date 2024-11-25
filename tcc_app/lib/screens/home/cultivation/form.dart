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

  void handleCreate(Cultivation data) async {
    try {
      await cultivationViewModel.createCultivation(data);
      _showSnackBar("Cultivo cadastrado com sucesso!!");
      _navigateBackWithSuccess();
    } catch (e) {
      _showSnackBar("Erro ao cadastrar Cultivo");
    }
  }

  void handleUpdate(int cultivationId, Cultivation data) async {
    try {
      await cultivationViewModel.updateCultivation(cultivationId, data);
      _showSnackBar("Cultivo editado com sucesso!!");
      _navigateBackWithSuccess();
    } catch (e) {
      _showSnackBar("Erro ao editar Cultivo");
    }
  }

  Cultivation mountPayload(bool create) {
    UserSession? user = UserSession.getSession();
    return Cultivation(
      id: !create ? widget.cultivation?.id : null,
      name: _nameController.text,
      plant: _selectedPlant!,
      user: user!.user,
      device: _selectedDevice!,
    );
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Formulário inválido');
      return;
    }

    if (widget.cultivation != null) {
      final data = mountPayload(false);

      return handleUpdate(data.id!, data);
    }

    final data = mountPayload(true);
    handleCreate(data);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08; // Mais espaçamento

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            widget.cultivation == null ? 'Criar Cultivo' : 'Editar Cultivo'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Cultivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Plant>>(
                future: plantViewModel.listPlants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    _showSnackBar("Erro ao carregar plantas");
                  }

                  final plants = snapshot.data ?? [];

                  if (plants.isNotEmpty) {
                    if (_selectedPlant == null ||
                        !plants.contains(_selectedPlant)) {
                      _selectedPlant = plants.first;
                    }
                  } else {
                    _selectedPlant = null;
                  }

                  return DropdownButtonFormField<Plant>(
                    value: _selectedPlant,
                    decoration:
                        const InputDecoration(labelText: 'Selecione a Planta'),
                    items: plants.map((plant) {
                      return DropdownMenuItem<Plant>(
                        value: plant,
                        child: Text(plant.name),
                      );
                    }).toList(),
                    onChanged: plants.isNotEmpty
                        ? (value) {
                            setState(() {
                              _selectedPlant = value;
                            });
                          }
                        : null,
                    validator: (value) {
                      if (value == null && plants.isNotEmpty) {
                        return 'Por favor, selecione uma planta';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 24), // Mais espaçamento entre elementos
              FutureBuilder<List<Device>>(
                future: deviceViewModel.listDevices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    _showSnackBar("Erro ao carregar dispositivos");
                  }

                  final devices = snapshot.data ?? [];

                  if (devices.isNotEmpty) {
                    if (_selectedDevice == null ||
                        !devices.contains(_selectedDevice)) {
                      _selectedDevice = devices.first;
                    }
                  } else {
                    _selectedDevice = null;
                  }

                  return DropdownButtonFormField<Device>(
                    value: _selectedDevice,
                    decoration: const InputDecoration(
                        labelText: 'Selecione o Dispositivo'),
                    items: devices.map((device) {
                      return DropdownMenuItem<Device>(
                        value: device,
                        child: Text(device.serialNumber),
                      );
                    }).toList(),
                    onChanged: devices.isNotEmpty
                        ? (value) {
                            setState(() {
                              _selectedDevice = value;
                            });
                          }
                        : null,
                    validator: (value) {
                      if (value == null && devices.isNotEmpty) {
                        return 'Por favor, selecione um dispositivo';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
