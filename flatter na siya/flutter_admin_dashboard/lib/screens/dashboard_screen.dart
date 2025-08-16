import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/user_role_pie_chart.dart';
import '../widgets/new_users_bar_chart.dart';
import '../widgets/notifications_line_chart.dart';
import '../widgets/post_category_pie_chart.dart';
import '../widgets/system_errors_bar_chart.dart';
import '../widgets/logins_timeline_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _onDrawerItemSelected(int index) {
    if (index == 0) return; // Already on dashboard
    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/users');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/system-logs');
        break;
    }
  }

  void _onLogout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(
        selectedIndex: 0,
        onItemSelected: _onDrawerItemSelected,
        onLogout: _onLogout,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.dashboard_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Dashboard Home',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Color(0xFF2d5f3f),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 24.0),
            child: Center(
              child: Text(
                'Welcome, CDRRMO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              color: const Color(0xFF2d5f3f),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 48),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'CDRRMO',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Warning System',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Chip(
                            label: Text('ONLINE', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Summary Cards Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard(
                  Icons.people, '12', 'Users',
                  onTap: () => _showCardModal('Users', icon: Icons.people, value: '12'),
                ),
                _buildSummaryCard(
                  Icons.contact_phone, '5', 'Emergency Contacts',
                  onTap: () => _showCardModal('Emergency Contacts', icon: Icons.contact_phone, value: '5'),
                ),
                _buildSummaryCard(
                  Icons.notifications_active, '3', 'Alerts',
                  onTap: () => _showCardModal('Alerts', icon: Icons.notifications_active, value: '3'),
                ),
                _buildSummaryCard(
                  Icons.group, '4', 'Emergency Response Teams',
                  onTap: () => _showCardModal('Emergency Response Teams', icon: Icons.group, value: '4'),
                ),
                _buildSummaryCard(Icons.admin_panel_settings, 'ONLINE', 'Admin'),
              ],
            ),
            const SizedBox(height: 16),
            // Quick snapshot text
            const Text(
              'A quick snapshot of everything that matters',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // User Roles & New Users Row
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Roles Pie Chart
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.pie_chart, color: Colors.black54),
                              SizedBox(width: 8),
                              Text('User Roles Distribution', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const UserRolePieChart(),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.grey[200],
                    ),
                    // New Users Bar Chart
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.bar_chart, color: Colors.black54),
                              SizedBox(width: 8),
                              Text('New Users Per Month', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const NewUsersBarChart(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Charts Row 1
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notifications Line Chart
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.show_chart, color: Colors.black54),
                              SizedBox(width: 8),
                              Text('Notifications Sent Over Time', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const NotificationsLineChart(),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.grey[200],
                    ),
                    // Post Category Pie Chart
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.pie_chart, color: Colors.black54),
                              SizedBox(width: 8),
                              Text('Post Category Distribution', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const PostCategoryPieChart(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Charts Row 2
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // System Errors by Type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.settings, color: Colors.black54),
                              SizedBox(width: 8),
                              Text('System Errors by Type', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const SystemErrorsBarChart(),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.grey[200],
                    ),
                    // Logins by Time of Day
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.show_chart, color: Colors.black54),
                              SizedBox(width: 8),
                              Text('Logins by Time of Day', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const LoginsTimelineChart(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String value, String label, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: const Color(0xFF43A047),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCardModal(String label, {IconData? icon, String? value}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            if (icon != null) Icon(icon, color: const Color(0xFF43A047)),
            if (icon != null) const SizedBox(width: 8),
            Text(label),
            if (value != null) ...[
              const Spacer(),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        content: const Text('Choose an action:'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToSection(label, 'view');
            },
            icon: const Icon(Icons.visibility, color: Color(0xFF43A047)),
            label: const Text('View', style: TextStyle(color: Color(0xFF43A047))),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToSection(label, 'add');
            },
            icon: const Icon(Icons.add, color: Color(0xFF43A047)),
            label: const Text('Add', style: TextStyle(color: Color(0xFF43A047))),
          ),
        ],
      ),
    );
  }

  void _navigateToSection(String label, String action) {
    if (label == 'Users') {
      if (action == 'view') {
        Navigator.pushNamed(context, '/users');
      } else if (action == 'add') {
        Navigator.pushNamed(context, '/users', arguments: {'showAddUser': true});
      }
    } else if (label == 'Emergency Contacts') {
      if (action == 'view') {
        Navigator.pushNamed(context, '/emergency-contacts');
      } else if (action == 'add') {
        Navigator.pushNamed(context, '/emergency-contacts/add');
      }
    } else if (label == 'Alerts') {
      if (action == 'view') {
        Navigator.pushNamed(context, '/notifications');
      } else if (action == 'add') {
        Navigator.pushNamed(context, '/notifications', arguments: {'showAddAlert': true});
      }
    } else if (label == 'Emergency Response Teams') {
      if (action == 'view') {
        Navigator.pushNamed(
          context,
          '/users',
          arguments: {'filterRole': 'Emergency Responder'},
        );
      } else if (action == 'add') {
        Navigator.pushNamed(
          context,
          '/users',
          arguments: {
            'showAddUser': true,
            'preselectRole': 'Emergency Responder',
          },
        );
      }
    }
  }
}