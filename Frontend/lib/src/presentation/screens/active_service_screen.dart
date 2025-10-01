
import 'package:flutter/material.dart';

class ActiveServiceScreen extends StatelessWidget {
  const ActiveServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Servicio Activo', style: TextStyle(color: Colors.white)),
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
            _buildProviderDetails(),
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
        subtitle: Text('Estado: En progreso', style: TextStyle(color: Colors.green)),
      ),
    );
  }

  Widget _buildProviderDetails() {
    return Card(
      color: Colors.grey[900],
      child: const ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text('Proveedor: John Doe', style: TextStyle(color: Colors.white, fontSize: 18)),
        subtitle: Text('Llegada estimada: 15 minutos', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showConfirmationDialog(context, 'Pausar Servicio', '¿Estás seguro de que quieres pausar este servicio?'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Pausar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showConfirmationDialog(context, 'Cancelar Servicio', '¿Estás seguro de que quieres cancelar este servicio?'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(content, style: const TextStyle(color: Colors.grey)),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sí', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
