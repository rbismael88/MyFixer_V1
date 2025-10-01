
import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/request_service_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Servicios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceSection(
              context,
              'Servicios para el Hogar',
              'Todo lo que necesitas para tu hogar',
              [
                _Service('Plomería', Icons.plumbing),
                _Service('Electricidad', Icons.electrical_services),
                _Service('Limpieza', Icons.cleaning_services),
                _Service('Pintura', Icons.format_paint),
                _Service('Carpintería', Icons.carpenter),
                _Service('Jardinería', Icons.local_florist),
              ],
            ),
            const SizedBox(height: 24),
            _buildServiceSection(
              context,
              'Cuidado Personal',
              'Luce y siéntete de lo mejor',
              [
                _Service('Peluquería', Icons.content_cut),
                _Service('Manicura', Icons.brush),
                _Service('Masajes', Icons.spa),
                _Service('Maquillaje', Icons.face),
              ],
            ),
             const SizedBox(height: 24),
            _buildServiceSection(
              context,
              'Mensajería y Paquetería',
              'Envía y recibe paquetes',
              [
                _Service('Enviar Paquete', Icons.send),
                _Service('Recados', Icons.shopping_bag),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(BuildContext context, String title, String subtitle, List<_Service> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5, // Adjust this ratio for card height
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return _buildServiceCard(context, services[index]);
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, _Service service) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RequestServiceScreen(serviceName: service.name)));
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(service.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
            Icon(service.icon, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}

class _Service {
  final String name;
  final IconData icon;

  _Service(this.name, this.icon);
}
