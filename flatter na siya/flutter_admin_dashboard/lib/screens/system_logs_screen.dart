import 'package:flutter/material.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  String selectedFilter = 'all';
  
  final List<Map<String, String>> systemLogs = [
    {
      'dateTime': '2025-07-14 09:12',
      'event': 'Admin logged in',
      'user': 'CDRRMO',
      'type': 'login',
    },
    {
      'dateTime': '2025-07-14 09:15',
      'event': 'Posted notification: Water Interruption',
      'user': 'CDRRMO',
      'type': 'posting',
    },
    {
      'dateTime': '2025-07-13 17:40',
      'event': 'User account activated: Mark Cruz',
      'user': 'Admin',
      'type': 'activation',
    },
    {
      'dateTime': '2025-07-14 17:00',
      'event': 'Admin logged out',
      'user': 'CDRRMO',
      'type': 'logout',
    },
    {
      'dateTime': '2025-07-14 08:30',
      'event': 'Emergency hotline added: Fire Department',
      'user': 'CDRRMO',
      'type': 'posting',
    },
    {
      'dateTime': '2025-07-13 16:20',
      'event': 'User deleted: Test User',
      'user': 'Admin',
      'type': 'activation',
    },
  ];

  List<Map<String, String>> get filteredLogs {
    if (selectedFilter == 'all') {
      return systemLogs;
    }
    return systemLogs.where((log) => log['type'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Logs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF13b464),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Below are recent system activities and events for audit and monitoring purposes.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Filter Section
          Row(
            children: [
              const Text(
                'Filter by Event:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: selectedFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'login', child: Text('Login')),
                  DropdownMenuItem(value: 'logout', child: Text('Logout')),
                  DropdownMenuItem(value: 'posting', child: Text('Posting')),
                  DropdownMenuItem(value: 'activation', child: Text('Activation')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Logs Table
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFb6fcd5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Date/Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Event',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'User',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Table Content
                    Expanded(
                      child: filteredLogs.isEmpty
                        ? const Center(
                            child: Text(
                              'No logs found for the selected filter.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredLogs.length,
                            itemBuilder: (context, index) {
                              final log = filteredLogs[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        log['dateTime']!,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getEventColor(log['type']!),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              _getEventIcon(log['type']!),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(log['event']!),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        log['user']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    'Total Logs',
                    systemLogs.length.toString(),
                    Icons.list_alt,
                    Colors.blue,
                  ),
                  _buildSummaryItem(
                    'Login Events',
                    systemLogs.where((log) => log['type'] == 'login').length.toString(),
                    Icons.login,
                    Colors.green,
                  ),
                  _buildSummaryItem(
                    'Logout Events',
                    systemLogs.where((log) => log['type'] == 'logout').length.toString(),
                    Icons.logout,
                    Colors.orange,
                  ),
                  _buildSummaryItem(
                    'System Actions',
                    systemLogs.where((log) => log['type'] == 'posting' || log['type'] == 'activation').length.toString(),
                    Icons.settings,
                    const Color(0xFF13b464),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'login':
        return Colors.green.shade100;
      case 'logout':
        return Colors.orange.shade100;
      case 'posting':
        return Colors.blue.shade100;
      case 'activation':
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  String _getEventIcon(String type) {
    switch (type) {
      case 'login':
        return '🔐';
      case 'logout':
        return '🚪';
      case 'posting':
        return '📢';
      case 'activation':
        return '⚙️';
      default:
        return '📝';
    }
  }
}
