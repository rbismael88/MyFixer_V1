
import 'package:flutter/material.dart';
import 'package:myfixer/src/presentation/screens/active_service_screen.dart';

enum ServiceStatus { active, upcoming, completed, canceled }

class ServiceHistory {
  final String serviceName;
  final String providerName;
  final DateTime date;
  final ServiceStatus status;
  final double price;

  ServiceHistory({
    required this.serviceName,
    required this.providerName,
    required this.date,
    required this.status,
    required this.price,
  });
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ServiceHistory> _history = [
    ServiceHistory(serviceName: 'Plomería', providerName: 'John Doe', date: DateTime.now(), status: ServiceStatus.active, price: 50.0),
    ServiceHistory(serviceName: 'Reparación Eléctrica', providerName: 'Jane Smith', date: DateTime.now().add(const Duration(days: 2)), status: ServiceStatus.upcoming, price: 75.0),
    ServiceHistory(serviceName: 'Limpieza del Hogar', providerName: 'Clean Co.', date: DateTime.now().subtract(const Duration(days: 5)), status: ServiceStatus.canceled, price: 100.0),
    ServiceHistory(serviceName: 'Pintura', providerName: 'Artistic Walls', date: DateTime.now().subtract(const Duration(days: 10)), status: ServiceStatus.completed, price: 250.0),
    ServiceHistory(serviceName: 'Jardinería', providerName: 'Green Thumb', date: DateTime.now().add(const Duration(days: 7)), status: ServiceStatus.upcoming, price: 60.0),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Actividad', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Activos'),
            Tab(text: 'Próximos'),
            Tab(text: 'Pasados'),
            Tab(text: 'Cancelados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryList(ServiceStatus.active),
          _buildHistoryList(ServiceStatus.upcoming),
          _buildHistoryList(ServiceStatus.completed),
          _buildHistoryList(ServiceStatus.canceled),
        ],
      ),
    );
  }

  Widget _buildHistoryList(ServiceStatus status) {
    final filteredList = _history.where((item) => item.status == status).toList();

    if (filteredList.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron servicios.',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(context, filteredList[index]);
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, ServiceHistory item) {
    IconData iconData;
    Color iconColor;

    switch (item.status) {
      case ServiceStatus.active:
        iconData = Icons.construction;
        iconColor = Colors.yellow;
        break;
      case ServiceStatus.upcoming:
        iconData = Icons.calendar_today;
        iconColor = Colors.blue;
        break;
      case ServiceStatus.completed:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case ServiceStatus.canceled:
        iconData = Icons.cancel;
        iconColor = Colors.red;
        break;
    }

    return InkWell(
      onTap: () {
        if (item.status == ServiceStatus.active) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ActiveServiceScreen()));
        }
      },
      child: Card(
        color: Colors.grey[900],
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withAlpha(51),
                child: Icon(iconData, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.serviceName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item.providerName, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('${item.date.day}/${item.date.month}/${item.date.year}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (item.status == ServiceStatus.canceled || item.status == ServiceStatus.completed)
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                      label: const Text('Reagendar', style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  if (item.status == ServiceStatus.upcoming)
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline, size: 18, color: Colors.white),
                      label: const Text('Detalles', style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  if (item.status == ServiceStatus.active)
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat, size: 18, color: Colors.white),
                      label: const Text('Chat', style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.purple[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
