import 'package:flutter/material.dart';
import 'package:tcc_app/models/cultivation.dart';
import 'package:tcc_app/models/device.dart';
import 'package:tcc_app/viewmodel/home/cultivation_viewmodel.dart';
import 'package:tcc_app/viewmodel/home/device_viewmodel.dart';

class DeviceFormPage extends StatefulWidget {
  final Device?
      device; // Recebe um dispositivo, que pode ser nulo para nova criação

  const DeviceFormPage({Key? key, this.device}) : super(key: key);

  @override
  _DeviceFormPage createState() => _DeviceFormPage();
}

class _DeviceFormPage extends State<DeviceFormPage> {
  final deviceViewModel = DeviceViewModelImpl();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serialNumberController = TextEditingController();
  final cultivationViewModel = CultivationViewModelImpl();
  Cultivation? _selectedCultivation;

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      // Caso esteja editando, preenche o formulário com os dados do dispositivo
      _serialNumberController.text = widget.device!.serialNumber;
      _selectedCultivation = widget.device!.cultivation;
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

    try {
      Device data = Device(
          serialNumber: _serialNumberController.text,
          cultivation: _selectedCultivation!);

      if (widget.device == null) {
        // Criação de novo dispositivo
        await deviceViewModel.createDevice(data);
        _showSnackBar("Device cadastrado com sucesso!!");
      } else {
        // Edição de dispositivo existente
        await deviceViewModel.updateDevice(widget.device!);
        _showSnackBar("Device editado com sucesso!!");
      }
      _navigateBackWithSuccess();
    } catch (e) {
      _showSnackBar("Erro ao cadastrar ou editar Device");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device == null ? 'Device Form' : 'Edit Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Serial number input
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a serial number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Select cultivation
              FutureBuilder<List<Cultivation>>(
                future: cultivationViewModel.listCultivations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading cultivations');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No cultivations available');
                  }

                  final cultivations = snapshot.data!;

                  // Initialize _selectedCultivation if it's null or invalid
                  if (_selectedCultivation == null ||
                      !cultivations.contains(_selectedCultivation)) {
                    _selectedCultivation = cultivations.first;
                  }

                  return DropdownButtonFormField<Cultivation>(
                    value: _selectedCultivation,
                    decoration:
                        const InputDecoration(labelText: 'Select Cultivation'),
                    items: cultivations.map((cultivation) {
                      return DropdownMenuItem<Cultivation>(
                        value: cultivation,
                        child: Text(cultivation.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCultivation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a cultivation';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 32),

              // Submit button
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text(widget.device == null ? 'Submit' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
