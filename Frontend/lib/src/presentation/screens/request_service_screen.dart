
import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/finding_provider_screen.dart';
import 'package:myfixer/src/presentation/screens/schedule_service_screen.dart';

class RequestServiceScreen extends StatefulWidget {
  final String serviceName;

  const RequestServiceScreen({super.key, required this.serviceName});

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.serviceName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle('Describe el trabajo'),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 5,
                    decoration: _buildInputDecoration('Añade detalles sobre lo que necesitas...'),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Añade fotos (opcional)'),
                  _buildPhotoUploader(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Ubicación'),
                  _buildLocationTile(),
                ],
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildPhotoUploader() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.add_a_photo, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildLocationTile() {
    return Card(
      color: Colors.grey[900],
      child: const ListTile(
        leading: Icon(Icons.location_on, color: Colors.white),
        title: Text('Calle Principal 123', style: TextStyle(color: Colors.white)),
        subtitle: Text('Santo Domingo, DN', style: TextStyle(color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleServiceScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Programar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FindingProviderScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Solicitar Ahora', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
