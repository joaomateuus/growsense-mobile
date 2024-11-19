import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Define quantos cards por linha
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildNavigationCard(
              context,
              title: 'Plantas',
              icon: Icons.nature,
              color: Colors.green,
              route: '/plants',
            ),
            _buildNavigationCard(
              context,
              title: 'Cultivos',
              icon: Icons.agriculture,
              color: Colors.brown,
              route: '/cultivation',
            ),
            _buildNavigationCard(
              context,
              title: 'Devices',
              icon: Icons.device_hub,
              color: Colors.blue,
              route: '/devices',
            ),
            _buildNavigationCard(
              context,
              title: 'Perfil',
              icon: Icons.person,
              color: Colors.grey,
              route: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
