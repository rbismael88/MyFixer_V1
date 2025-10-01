
import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/new_request_details_screen.dart';

class ServiceRequest {
  final String serviceName;
  final String clientName;
  final double distance;

  ServiceRequest(this.serviceName, this.clientName, this.distance);
}

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceRequest> requests = [
      ServiceRequest('Plomería', 'Ana', 2.5),
      ServiceRequest('Electricidad', 'Carlos', 5.0),
      ServiceRequest('Limpieza', 'Maria', 1.2),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            leading: const Icon(Icons.person_pin_circle, color: Colors.white, size: 40),
            title: Text(request.serviceName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('${request.clientName} • A ${request.distance} km', style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewRequestDetailsScreen()));
            },
          ),
        );
      },
    );
  }
}
