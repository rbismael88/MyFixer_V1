
import 'package:flutter/material.dart';

class Service {
  final String name;
  bool isSelected;

  Service(this.name, {this.isSelected = false});
}

class EditProviderServicesScreen extends StatefulWidget {
  const EditProviderServicesScreen({super.key});

  @override
  State<EditProviderServicesScreen> createState() => _EditProviderServicesScreenState();
}

class _EditProviderServicesScreenState extends State<EditProviderServicesScreen> {
  final List<Service> _services = [
    Service('Plomería', isSelected: true),
    Service('Electricidad', isSelected: true),
    Service('Limpieza'),
    Service('Pintura'),
    Service('Carpintería'),
    Service('Jardinería'),
    Service('Peluquería'),
    Service('Manicura'),
    Service('Masajes'),
    Service('Maquillaje'),
    Service('Enviar Paquete'),
    Service('Recados'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Editar Servicios', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              // Save logic here
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return CheckboxListTile(
            title: Text(service.name, style: const TextStyle(color: Colors.white)),
            value: service.isSelected,
            onChanged: (bool? value) {
              setState(() {
                service.isSelected = value ?? false;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white),
          );
        },
      ),
    );
  }
}
