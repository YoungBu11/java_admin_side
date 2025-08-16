
import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(
        selectedIndex: 3,
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        onItemSelected: (index) {
          if (index == 3) return; // Already on Settings
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/users');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/notifications');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/system-logs');
              break;
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2d5f3f),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.settings, color: Colors.white),
            SizedBox(width: 10),
            Text('Settings', style: TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Center(
              child: Text(
                'Welcome, CDRRMO',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF4FAF4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  // Left: Settings Cards
                  Expanded(
                    flex: 2,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.2,
                      children: const [
                        _SettingsCard(
                          icon: Icons.group,
                          iconColor: Colors.red,
                          title: 'Emergency Contacts',
                          buttonColor: Colors.red,
                        ),
                        _SettingsCard(
                          icon: Icons.cloud_upload,
                          iconColor: Colors.green,
                          title: 'System Backup',
                          buttonColor: Colors.green,
                        ),
                        _SettingsCard(
                          icon: Icons.security,
                          iconColor: Colors.purple,
                          title: 'Admin Permissions',
                          buttonColor: Colors.purple,
                        ),
                        _SettingsCard(
                          icon: Icons.phone_iphone,
                          iconColor: Colors.teal,
                          title: 'Mobile App Config',
                          buttonColor: Colors.teal,
                        ),
                        _SettingsCard(
                          icon: Icons.wifi,
                          iconColor: Colors.blue,
                          title: 'Network Settings',
                          buttonColor: Colors.blue,
                        ),
                        _SettingsCard(
                          icon: Icons.shield,
                          iconColor: Colors.deepOrange,
                          title: 'Security Settings',
                          buttonColor: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right: Empty Container
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color buttonColor;

  const _SettingsCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text('Configure'),
            ),
          ],
        ),
      ),
    );
  }
}
