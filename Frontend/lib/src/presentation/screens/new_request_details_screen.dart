
import 'package:flutter/material.dart';

class NewRequestDetailsScreen extends StatelessWidget {
  const NewRequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Nueva Solicitud', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceDetails(),
            const SizedBox(height: 24),
            _buildClientDetails(),
            const Spacer(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Card(
      color: Colors.grey[900],
      child: const ListTile(
        leading: Icon(Icons.plumbing, color: Colors.white, size: 40),
        title: Text('Servicio de Plomería', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text('Ubicación: Calle Principal 123', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildClientDetails() {
    return Card(
      color: Colors.grey[900],
      child: const ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text('Cliente: Ana', style: TextStyle(color: Colors.white, fontSize: 18)),
        subtitle: Text('Rating: 4.8 estrellas', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Decline logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Rechazar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Accept logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Aceptar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
