import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/manage_account_screen.dart';
import 'package:myfixer/src/presentation/screens/provider_profile_screen.dart';
import 'package:myfixer/src/services/auth_service.dart';

class AccountScreen extends StatelessWidget {
  final bool isProviderMode;
  final VoidCallback onToggleProviderMode;
  final VoidCallback onSignOut;
  final AuthService authService;

  const AccountScreen(
      {super.key,
      required this.isProviderMode,
      required this.onToggleProviderMode,
      required this.onSignOut,
      required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),

          // Mode Switch
          _buildModeSwitch(authService), // Pass authService
          const SizedBox(height: 24),

          // Action Buttons
          _buildActionButtons(),
          const SizedBox(height: 24),

          // Promotional Cards
          _buildPromoCard(
            'Revisión de Privacidad',
            'Haz un tour interactivo por tu configuración de privacidad.',
            Icons.privacy_tip,
            Colors.blue,
          ),
          const SizedBox(height: 24),

          // Settings List
          _buildSettingsList(context),

          // Version Number
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${authService.currentFirstName ?? ''} ${authService.currentLastName ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                if (authService.isVerified)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.verified, color: Colors.blue, size: 24),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                SizedBox(width: 4),
                Text('5.0',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[800],
          backgroundImage: authService.profilePictureUrl != null
              ? NetworkImage(authService.profilePictureUrl!)
              : null,
          child: authService.profilePictureUrl == null
              ? const Icon(Icons.person, color: Colors.white, size: 50)
              : null,
        ),
      ],
    );
  }

  Widget _buildModeSwitch(AuthService authService) {
    // Update signature
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Modo Proveedor',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Switch(
            value: isProviderMode,
            onChanged: (value) => onToggleProviderMode(),
            activeTrackColor: Colors.green,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.help_outline, 'Ayuda'),
        _buildActionButton(Icons.account_balance_wallet, 'Billetera'),
        _buildActionButton(Icons.history, 'Actividad'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPromoCard(
      String title, String subtitle, IconData icon, Color color) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, color: color, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingsItem(Icons.person_outline, 'Gestionar Cuenta',
            'Edita tu perfil, contraseña, etc.', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ManageAccountScreen(authService: authService)));
        }),
        if (isProviderMode)
          Column(
            children: [
              Divider(color: Colors.grey[800]),
              _buildSettingsItem(Icons.business_center, 'Perfil de Proveedor',
                  'Gestiona tu información de proveedor', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProviderProfileScreen()));
              }),
            ],
          ),
        Divider(color: Colors.grey[800]),
        _buildSettingsItem(
            Icons.favorite_border, 'Proveedores Guardados', null, () {}),
        Divider(color: Colors.grey[800]),
        _buildSettingsItem(Icons.local_offer, 'Promociones', null, () {}),
        Divider(color: Colors.grey[800]),
        _buildSettingsItem(Icons.settings, 'Configuración', null, () {}),
        Divider(color: Colors.grey[800]),
        _buildSettingsItem(Icons.message, 'Mensajes', null, () {}),
        Divider(color: Colors.grey[800]),
        _buildSettingsItem(Icons.gavel, 'Legal',
            'Términos de Servicio, Política de Privacidad', () {}),
        Divider(color: Colors.grey[800]),
        _buildSettingsItem(Icons.logout, 'Cerrar Sesión', null, onSignOut,
            color: Colors.red),
      ],
    );
  }

  Widget _buildSettingsItem(
      IconData icon, String title, String? subtitle, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(title,
          style: TextStyle(color: color ?? Colors.white, fontSize: 16)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey[400]))
          : null,
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }
}
