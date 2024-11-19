import 'package:flutter/material.dart';
import 'package:tcc_app/models/plant.dart';
import 'package:tcc_app/viewmodel/home/plant.viewmodel.dart';

class PlantFormPage extends StatefulWidget {
  final Plant? plant; // Objeto opcional para edição

  const PlantFormPage({Key? key, this.plant}) : super(key: key);

  @override
  _PlantFormPageState createState() => _PlantFormPageState();
}

class _PlantFormPageState extends State<PlantFormPage> {
  final plantViewModel = PlantViewModelImpl();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _soilMoistureController = TextEditingController();
  final TextEditingController _airHumidityController = TextEditingController();
  final TextEditingController _lightIntensityController =
      TextEditingController();
  final TextEditingController _rainSensorController = TextEditingController();
  final TextEditingController _waterPumpStatusController =
      TextEditingController();
  final TextEditingController _relayStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preenche os controladores caso seja edição
    if (widget.plant != null) {
      _nameController.text = widget.plant!.name;
      _temperatureController.text = widget.plant!.temperature.toString();
      _soilMoistureController.text = widget.plant!.soilMoisture.toString();
      _airHumidityController.text = widget.plant!.airHumidity.toString();
      _lightIntensityController.text = widget.plant!.lightIntensity.toString();
      _rainSensorController.text = widget.plant!.rainSensor.toString();
      _waterPumpStatusController.text =
          widget.plant!.waterPumpStatus.toString();
      _relayStatusController.text = widget.plant!.relayStatus.toString();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateBackWithSuccess() {
    Navigator.pop(context, true);
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return _showSnackBar("Formulário Inválido");
    }

    final updatedPlant = Plant(
      name: _nameController.text,
      temperature: double.tryParse(_temperatureController.text) ?? 0,
      soilMoisture: double.tryParse(_soilMoistureController.text) ?? 0,
      airHumidity: double.tryParse(_airHumidityController.text) ?? 0,
      lightIntensity: double.tryParse(_lightIntensityController.text) ?? 0,
      rainSensor: double.tryParse(_rainSensorController.text) ?? 0,
      waterPumpStatus: _waterPumpStatusController.text,
      relayStatus: _relayStatusController.text,
    );

    if (widget.plant != null) {
      // Atualização
      final response = await plantViewModel.updatePlant(widget.plant!);
      if (response != null) {
        _showSnackBar("Planta atualizada com sucesso");
        _navigateBackWithSuccess();
      } else {
        _showSnackBar('Erro ao atualizar planta!');
      }
    } else {
      // Criação
      final response = await plantViewModel.createPlant(updatedPlant);
      if (response != null) {
        _showSnackBar("Planta criada com sucesso");
        _navigateBackWithSuccess();
      } else {
        _showSnackBar('Erro ao cadastrar planta!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.plant == null ? 'Criar Planta' : 'Editar Planta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureController,
                decoration:
                    const InputDecoration(labelText: 'Temperature (°C)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _soilMoistureController,
                decoration:
                    const InputDecoration(labelText: 'Soil Moisture (%)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _airHumidityController,
                decoration:
                    const InputDecoration(labelText: 'Air Humidity (%)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lightIntensityController,
                decoration:
                    const InputDecoration(labelText: 'Light Intensity (lx)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rainSensorController,
                decoration: const InputDecoration(labelText: 'Rain Sensor'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _waterPumpStatusController,
                decoration:
                    const InputDecoration(labelText: 'Water Pump Status'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _relayStatusController,
                decoration: const InputDecoration(labelText: 'Relay Status'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text(widget.plant == null ? 'Criar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
