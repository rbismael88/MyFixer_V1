
import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/account_screen.dart';
import 'package:myfixer/src/presentation/screens/activity_screen.dart';
import 'package:myfixer/src/presentation/screens/provider_home_screen.dart';
import 'package:myfixer/src/presentation/screens/services_screen.dart';
import 'package:myfixer/src/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isProviderMode;
  final VoidCallback onToggleProviderMode;
  final VoidCallback onSignOut;
  final AuthService authService;

  const HomeScreen({super.key, required this.isProviderMode, required this.onToggleProviderMode, required this.onSignOut, required this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      widget.isProviderMode ? const ProviderHomeScreen() : const ClientHomeScreenBody(),
      const ServicesScreen(),
      const ActivityScreen(),
      AccountScreen(isProviderMode: widget.isProviderMode, onToggleProviderMode: widget.onToggleProviderMode, onSignOut: widget.onSignOut, authService: widget.authService),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isProviderMode ? 'Modo Proveedor' : 'MyFixer', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Servicios'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Actividad'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Cuenta'),
        ],
      ),
    );
  }
}

class ClientHomeScreenBody extends StatelessWidget {
  const ClientHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintText: '¿Qué servicio necesitas?',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text('Más tarde', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Suggestions
            const Text('Sugerencias', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSuggestionItem(Icons.plumbing, 'Plomería'),
                _buildSuggestionItem(Icons.electrical_services, 'Electricidad'),
                _buildSuggestionItem(Icons.cleaning_services, 'Limpieza'),
                _buildSuggestionItem(Icons.format_paint, 'Pintura'),
              ],
            ),
            const SizedBox(height: 24),

            // Promotional Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE1D5E7),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Encuentra a los mejores profesionales',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Proveedores verificados y de confianza para las necesidades de tu hogar.',
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 80, color: Colors.purple[800]),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Plan your next service
            const Text('Planifica tu próximo servicio', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPlanCard(Colors.orange, 'Reparación del Hogar'),
                  _buildPlanCard(Colors.blue, 'Arreglo de Electrodomésticos'),
                  _buildPlanCard(Colors.green, 'Jardinería'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[900],
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildPlanCard(Color color, String title) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withAlpha(77),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
