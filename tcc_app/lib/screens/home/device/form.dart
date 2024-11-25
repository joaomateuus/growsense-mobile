import 'package:flutter/material.dart';
import 'package:tcc_app/models/device.dart';
import 'package:tcc_app/viewmodel/home/cultivation_viewmodel.dart';
import 'package:tcc_app/viewmodel/home/device_viewmodel.dart';

class DeviceFormPage extends StatefulWidget {
  final Device? device;

  const DeviceFormPage({Key? key, this.device}) : super(key: key);

  @override
  _DeviceFormPage createState() => _DeviceFormPage();
}

class _DeviceFormPage extends State<DeviceFormPage> {
  final deviceViewModel = DeviceViewModelImpl();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serialNumberController = TextEditingController();
  final cultivationViewModel = CultivationViewModelImpl();

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      _serialNumberController.text = widget.device!.serialNumber;
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
      _showSnackBar("Formulário Inválido");
      return;
    }

    try {
      Device data = Device(
        serialNumber: _serialNumberController.text,
      );

      if (widget.device == null) {
        await deviceViewModel.createDevice(data);
        _showSnackBar("Device cadastrado com sucesso!!");
      } else {
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
        centerTitle: true,
        title: Text(
            widget.device == null ? 'Criar Dispositivo' : 'Editar Dispositivo'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        constraints.maxWidth > 600 ? 600 : double.infinity,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _serialNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Serial Number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a serial number';
                            }
                            return null;
                          },
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
              ),
            ),
          );
        },
      ),
    );
  }
}
