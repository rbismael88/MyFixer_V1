
import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/edit_provider_area_screen.dart';
import 'package:myfixer/src/presentation/screens/edit_provider_portfolio_screen.dart';
import 'package:myfixer/src/presentation/screens/edit_provider_schedule_screen.dart';
import 'package:myfixer/src/presentation/screens/edit_provider_services_screen.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Perfil de Proveedor', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Servicios Ofrecidos'),
          _buildInfoTile(context, 'Plomería', 'Reparaciones e instalaciones', () {}),
          _buildInfoTile(context, 'Electricidad', 'Cableado, cortos, etc.', () {}),
          _buildActionTile(context, 'Añadir o editar servicios', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProviderServicesScreen()));
          }),
          const SizedBox(height: 24),

          _buildSectionTitle('Horario de Trabajo'),
          _buildInfoTile(context, 'Lunes a Viernes', '9:00 AM - 5:00 PM', () {}),
          _buildActionTile(context, 'Editar horario', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProviderScheduleScreen()));
          }),
          const SizedBox(height: 24),

          _buildSectionTitle('Área de Servicio'),
          _buildInfoTile(context, 'Radio de 10km', 'Alrededor de tu ubicación base', () {}),
          _buildActionTile(context, 'Editar área de servicio', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProviderAreaScreen()));
          }),
          const SizedBox(height: 24),

          _buildSectionTitle('Portafolio'),
          _buildPortfolio(),
          _buildActionTile(context, 'Editar portafolio', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProviderPortfolioScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }

  Widget _buildInfoTile(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String title, VoidCallback onTap, {Color? color}) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        title: Text(title, style: TextStyle(color: color ?? Colors.white, fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPortfolio() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildPortfolioItem(),
          _buildPortfolioItem(),
          _buildPortfolioItem(),
        ],
      ),
    );
  }

  Widget _buildPortfolioItem() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Icon(Icons.image, color: Colors.white, size: 40)),
    );
  }
}
