
import 'package:flutter/material.dart';

class EditProviderAreaScreen extends StatefulWidget {
  const EditProviderAreaScreen({super.key});

  @override
  State<EditProviderAreaScreen> createState() => _EditProviderAreaScreenState();
}

class _EditProviderAreaScreenState extends State<EditProviderAreaScreen> {
  double _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Editar Área de Servicio', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Radio de Servicio (km)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: _radius,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: '${_radius.round()} km',
                    onChanged: (double value) {
                      setState(() {
                        _radius = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Text('${_radius.round()} km', style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Vista Previa del Área', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Mapa no disponible', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
