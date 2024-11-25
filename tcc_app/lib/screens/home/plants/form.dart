import 'package:flutter/material.dart';
import 'package:tcc_app/models/plant.dart';
import 'package:tcc_app/viewmodel/home/plant.viewmodel.dart';

class PlantFormPage extends StatefulWidget {
  final Plant? plant;

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

  void handleUpdate(Plant plant) async {
    try {
      await plantViewModel.updatePlant(plant.id!, plant);
      _showSnackBar("Planta atualizada com sucesso");
      _navigateBackWithSuccess();
    } catch (e) {
      _showSnackBar('Erro ao atualizar planta!');
    }
  }

  void handleCreate(Plant data) async {
    try {
      await plantViewModel.createPlant(data);
      _showSnackBar("Planta criada com sucesso");
      _navigateBackWithSuccess();
    } catch (e) {
      _showSnackBar('Erro ao cadastrar planta! $e');
    }
  }

  Plant mountPayload(bool create) {
    return Plant(
      id: !create ? widget.plant?.id : null,
      name: _nameController.text,
      temperature: double.tryParse(_temperatureController.text) ?? 0,
      soilMoisture: double.tryParse(_soilMoistureController.text) ?? 0,
      airHumidity: double.tryParse(_airHumidityController.text) ?? 0,
      lightIntensity: double.tryParse(_lightIntensityController.text) ?? 0,
      rainSensor: double.tryParse(_rainSensorController.text) ?? 0,
      waterPumpStatus: _waterPumpStatusController.text,
      relayStatus: _relayStatusController.text,
    );
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return _showSnackBar("Formulário Inválido");
    }

    if (widget.plant != null) {
      final plant = mountPayload(false);
      return handleUpdate(plant);
    }

    final plant = mountPayload(true);
    handleCreate(plant);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingHorizontal = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.plant == null ? 'Criar Planta' : 'Editar Planta'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildResponsiveField(
                controller: _nameController,
                label: 'Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
              _buildResponsiveField(
                controller: _temperatureController,
                label: 'Temperature (°C)',
                keyboardType: TextInputType.number,
              ),
              _buildResponsiveField(
                controller: _soilMoistureController,
                label: 'Soil Moisture (%)',
                keyboardType: TextInputType.number,
              ),
              _buildResponsiveField(
                controller: _airHumidityController,
                label: 'Air Humidity (%)',
                keyboardType: TextInputType.number,
              ),
              _buildResponsiveField(
                controller: _lightIntensityController,
                label: 'Light Intensity (lx)',
                keyboardType: TextInputType.number,
              ),
              _buildResponsiveField(
                controller: _rainSensorController,
                label: 'Rain Sensor',
                keyboardType: TextInputType.number,
              ),
              _buildResponsiveField(
                controller: _waterPumpStatusController,
                label: 'Water Pump Status',
              ),
              _buildResponsiveField(
                controller: _relayStatusController,
                label: 'Relay Status',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: handleSubmit,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
