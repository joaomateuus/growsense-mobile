import 'package:flutter/material.dart';
import 'package:tcc_app/models/cultivation.dart';
import 'package:tcc_app/models/plant.dart';
import 'package:tcc_app/models/user_session.dart';
import 'package:tcc_app/viewmodel/home/cultivation_viewmodel.dart';
import 'package:tcc_app/viewmodel/home/plant.viewmodel.dart';

class CultivationFormPage extends StatefulWidget {
  final Cultivation? cultivation;

  const CultivationFormPage({Key? key, this.cultivation}) : super(key: key);

  @override
  _CultivationFormPage createState() => _CultivationFormPage();
}

class _CultivationFormPage extends State<CultivationFormPage> {
  final cultivationViewModel = CultivationViewModelImpl();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final plantViewModel = PlantViewModelImpl();
  Plant? _selectedPlant;

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
        name: _nameController.text, plant: _selectedPlant!, user: user!.user);

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

              // Select de planta
              FutureBuilder<List<Plant>>(
                future: plantViewModel
                    .listPlants(), // Método que retorna a lista de plantas
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
                  if (_selectedPlant == null ||
                      !plants.contains(_selectedPlant)) {
                    _selectedPlant =
                        plants.first; // Inicializa com o primeiro item da lista
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
                    onChanged: (value) {
                      setState(() {
                        _selectedPlant = value;
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
