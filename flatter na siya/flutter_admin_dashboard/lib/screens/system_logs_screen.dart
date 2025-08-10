import 'package:flutter/material.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  // Filter and Search Variables
  String _logSearchQuery = '';
  String _selectedUserFilter = 'All Users';
  String _selectedCategoryFilter = 'All Categories';
  String _selectedStatusFilter = 'All Status';
  DateTimeRange? _selectedDateRange;
  
  // Sorting Variables
  String _logSortBy = 'date';
  bool _logSortAscending = false;

  final List<Map<String, dynamic>> systemLogs = [
    {
      'id': '1',
      'dateTime': DateTime(2025, 1, 15, 14, 30),
      'user': 'CDRRMO Admin',
      'action': 'User Login',
      'category': 'Authentication',
      'status': 'Success',
      'details': 'Admin successfully logged into the system',
      'ipAddress': '192.168.1.100',
      'userAgent': 'Chrome 120.0.6099.199',
    },
    {
      'id': '2',
      'dateTime': DateTime(2025, 1, 15, 14, 35),
      'user': 'CDRRMO Admin',
      'action': 'Notification Posted',
      'category': 'Content Management',
      'status': 'Success',
      'details': 'Posted emergency alert: Flash flood warning for Barangay Central',
      'ipAddress': '192.168.1.100',
      'userAgent': 'Chrome 120.0.6099.199',
    },
    {
      'id': '3',
      'dateTime': DateTime(2025, 1, 15, 13, 20),
      'user': 'System Admin',
      'action': 'User Account Created',
      'category': 'User Management',
      'status': 'Success',
      'details': 'New user account created for Maria Santos',
      'ipAddress': '192.168.1.101',
      'userAgent': 'Firefox 121.0',
    },
    {
      'id': '4',
      'dateTime': DateTime(2025, 1, 15, 12, 15),
      'user': 'System Admin',
      'action': 'Emergency Hotline Updated',
      'category': 'System Configuration',
      'status': 'Success',
      'details': 'Updated Fire Department hotline: 117 -> 911-FIRE',
      'ipAddress': '192.168.1.101',
      'userAgent': 'Firefox 121.0',
    },
    {
      'id': '5',
      'dateTime': DateTime(2025, 1, 15, 11, 45),
      'user': 'Guest User',
      'action': 'Failed Login Attempt',
      'category': 'Security',
      'status': 'Failed',
      'details': 'Invalid credentials for username: admin123',
      'ipAddress': '192.168.1.205',
      'userAgent': 'Chrome 119.0.6045.199',
    },
    {
      'id': '6',
      'dateTime': DateTime(2025, 1, 15, 11, 30),
      'user': 'CDRRMO Admin',
      'action': 'System Backup',
      'category': 'System Maintenance',
      'status': 'Success',
      'details': 'Automated daily backup completed successfully',
      'ipAddress': '192.168.1.100',
      'userAgent': 'System Process',
    },
    {
      'id': '7',
      'dateTime': DateTime(2025, 1, 15, 10, 20),
      'user': 'System Admin',
      'action': 'User Account Deactivated',
      'category': 'User Management',
      'status': 'Success',
      'details': 'Deactivated account for inactive user: john.doe@email.com',
      'ipAddress': '192.168.1.101',
      'userAgent': 'Firefox 121.0',
    },
    {
      'id': '8',
      'dateTime': DateTime(2025, 1, 15, 9, 50),
      'user': 'CDRRMO Admin',
      'action': 'Emergency Alert Sent',
      'category': 'Emergency Response',
      'status': 'Success',
      'details': 'Mass SMS alert sent to 1,247 registered users about typhoon warning',
      'ipAddress': '192.168.1.100',
      'userAgent': 'Chrome 120.0.6099.199',
    },
    {
      'id': '9',
      'dateTime': DateTime(2025, 1, 15, 9, 15),
      'user': 'System',
      'action': 'Database Maintenance',
      'category': 'System Maintenance',
      'status': 'In Progress',
      'details': 'Weekly database optimization and cleanup in progress',
      'ipAddress': 'localhost',
      'userAgent': 'System Process',
    },
    {
      'id': '10',
      'dateTime': DateTime(2025, 1, 15, 8, 30),
      'user': 'Data Manager',
      'action': 'Report Generated',
      'category': 'Reports',
      'status': 'Success',
      'details': 'Monthly disaster response report generated and exported',
      'ipAddress': '192.168.1.102',
      'userAgent': 'Edge 120.0.2210.144',
    },
    {
      'id': '11',
      'dateTime': DateTime(2025, 1, 14, 18, 45),
      'user': 'CDRRMO Admin',
      'action': 'User Logout',
      'category': 'Authentication',
      'status': 'Success',
      'details': 'Admin logged out of the system',
      'ipAddress': '192.168.1.100',
      'userAgent': 'Chrome 120.0.6099.199',
    },
    {
      'id': '12',
      'dateTime': DateTime(2025, 1, 14, 16, 20),
      'user': 'Unknown',
      'action': 'Suspicious Activity',
      'category': 'Security',
      'status': 'Warning',
      'details': 'Multiple failed login attempts detected from IP: 203.194.112.45',
      'ipAddress': '203.194.112.45',
      'userAgent': 'Unknown',
    },
  ];

  // Get unique values for filters
  List<String> get _uniqueUsers {
    final users = systemLogs.map((log) => log['user'] as String).toSet().toList();
    users.sort();
    return ['All Users', ...users];
  }

  List<String> get _uniqueCategories {
    final categories = systemLogs.map((log) => log['category'] as String).toSet().toList();
    categories.sort();
    return ['All Categories', ...categories];
  }

  List<String> get _uniqueStatuses {
    final statuses = systemLogs.map((log) => log['status'] as String).toSet().toList();
    statuses.sort();
    return ['All Status', ...statuses];
  }

  // Apply filters and sorting
  List<Map<String, dynamic>> _applyLogFiltersAndSorting() {
    var filteredLogs = systemLogs.where((log) {
      final matchesSearch = _logSearchQuery.isEmpty ||
          (log['user'] as String).toLowerCase().contains(_logSearchQuery.toLowerCase()) ||
          (log['action'] as String).toLowerCase().contains(_logSearchQuery.toLowerCase()) ||
          (log['details'] as String).toLowerCase().contains(_logSearchQuery.toLowerCase());

      final matchesUser = _selectedUserFilter == 'All Users' ||
          log['user'] == _selectedUserFilter;

      final matchesCategory = _selectedCategoryFilter == 'All Categories' ||
          log['category'] == _selectedCategoryFilter;

      final matchesStatus = _selectedStatusFilter == 'All Status' ||
          log['status'] == _selectedStatusFilter;

      final matchesDateRange = _selectedDateRange == null ||
          ((log['dateTime'] as DateTime).isAfter(_selectedDateRange!.start) &&
              (log['dateTime'] as DateTime).isBefore(_selectedDateRange!.end.add(const Duration(days: 1))));

      return matchesSearch && matchesUser && matchesCategory && matchesStatus && matchesDateRange;
    }).toList();

    // Sort the filtered logs
    filteredLogs.sort((a, b) {
      int comparison = 0;
      switch (_logSortBy) {
        case 'date':
          comparison = (a['dateTime'] as DateTime).compareTo(b['dateTime'] as DateTime);
          break;
        case 'user':
          comparison = (a['user'] as String).compareTo(b['user'] as String);
          break;
        case 'action':
          comparison = (a['action'] as String).compareTo(b['action'] as String);
          break;
        case 'status':
          comparison = (a['status'] as String).compareTo(b['status'] as String);
          break;
      }
      return _logSortAscending ? comparison : -comparison;
    });

    return filteredLogs;
  }

  // Helper methods
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Authentication':
        return Colors.blue;
      case 'Security':
        return Colors.red;
      case 'User Management':
        return Colors.purple;
      case 'Content Management':
        return Colors.green;
      case 'System Configuration':
        return Colors.orange;
      case 'System Maintenance':
        return Colors.indigo;
      case 'Emergency Response':
        return Colors.pink;
      case 'Reports':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getUserColor(String user) {
    switch (user.toLowerCase()) {
      case 'system admin':
        return Colors.purple;
      case 'cdrrmo admin':
        return Colors.green;
      case 'data manager':
        return Colors.teal;
      case 'system':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Authentication':
        return Icons.login;
      case 'Security':
        return Icons.security;
      case 'User Management':
        return Icons.people;
      case 'Content Management':
        return Icons.edit_note;
      case 'System Configuration':
        return Icons.settings;
      case 'System Maintenance':
        return Icons.build;
      case 'Emergency Response':
        return Icons.emergency;
      case 'Reports':
        return Icons.assessment;
      default:
        return Icons.info;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _applyLogFiltersAndSorting();
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF13b464), Color(0xFF16d174)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF13b464).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Activity Logs',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Monitor and audit all system activities in real-time',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _exportLogs(filteredLogs),
                    icon: const Icon(Icons.download),
                    label: const Text('Export'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF13b464),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary Cards
            Row(
              children: [
                _buildSummaryCard(
                  'Total Logs',
                  systemLogs.length.toString(),
                  Icons.list_alt,
                  Colors.blue,
                  filteredLogs.length != systemLogs.length ? '(${filteredLogs.length} filtered)' : '',
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  'Security Events',
                  systemLogs.where((log) => log['category'] == 'Security').length.toString(),
                  Icons.security,
                  Colors.red,
                  '',
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  'User Actions',
                  systemLogs.where((log) => log['category'] == 'User Management').length.toString(),
                  Icons.people,
                  Colors.purple,
                  '',
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  'System Tasks',
                  systemLogs.where((log) => log['category'] == 'System Maintenance').length.toString(),
                  Icons.build,
                  Colors.orange,
                  '',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search and Filter Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF13b464)),
                        const SizedBox(width: 8),
                        const Text(
                          'Search & Filter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _clearAllFilters,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear All'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by user, action, or details...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _logSearchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Filter Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('User', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedUserFilter,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: _uniqueUsers.map((user) {
                                  return DropdownMenuItem(value: user, child: Text(user));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUserFilter = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedCategoryFilter,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: _uniqueCategories.map((category) {
                                  return DropdownMenuItem(value: category, child: Text(category));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategoryFilter = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedStatusFilter,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: _uniqueStatuses.map((status) {
                                  return DropdownMenuItem(value: status, child: Text(status));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStatusFilter = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date Range', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final DateTimeRange? picked = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                    initialDateRange: _selectedDateRange,
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDateRange = picked;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.date_range),
                                label: Text(_selectedDateRange == null 
                                    ? 'Select Range' 
                                    : '${_selectedDateRange!.start.month}/${_selectedDateRange!.start.day} - ${_selectedDateRange!.end.month}/${_selectedDateRange!.end.day}'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logs Table
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    // Table Header with Sorting
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF13b464), Color(0xFF16d174)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildSortableHeader('Date/Time', 'date', 2),
                          _buildSortableHeader('User', 'user', 2),
                          _buildSortableHeader('Action', 'action', 3),
                          _buildSortableHeader('Status', 'status', 1),
                          const Expanded(
                            flex: 3,
                            child: Text(
                              'Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Table Content
                    Expanded(
                      child: filteredLogs.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: filteredLogs.length,
                            itemBuilder: (context, index) {
                              return _buildEnhancedLogRow(filteredLogs[index], index);
                            },
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

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
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
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortableHeader(String title, String sortKey, int flex) {
    final isActive = _logSortBy == sortKey;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          setState(() {
            if (_logSortBy == sortKey) {
              _logSortAscending = !_logSortAscending;
            } else {
              _logSortBy = sortKey;
              _logSortAscending = true;
            }
          });
        },
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: isActive ? TextDecoration.underline : null,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(
                _logSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedLogRow(Map<String, dynamic> log, int index) {
    final isEven = index % 2 == 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven ? Colors.grey[50] : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Date/Time
          Expanded(
            flex: 2,
            child: Text(
              _formatDateTime(log['dateTime'] as DateTime),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // User with colored badge
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getUserColor(log['user'] as String),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    log['user'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Action with category icon
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(log['category'] as String).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getCategoryIcon(log['category'] as String),
                    size: 16,
                    color: _getCategoryColor(log['category'] as String),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log['action'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        log['category'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Status badge
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(log['status'] as String),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                log['status'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          // Details
          Expanded(
            flex: 3,
            child: Text(
              log['details'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      case 'Warning':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No logs found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search criteria',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _logSearchQuery = '';
      _selectedUserFilter = 'All Users';
      _selectedCategoryFilter = 'All Categories';
      _selectedStatusFilter = 'All Status';
      _selectedDateRange = null;
    });
  }

  void _exportLogs(List<Map<String, dynamic>> logs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Logs'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performExport('CSV', logs);
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performExport('PDF', logs);
            },
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performExport('TXT', logs);
            },
            child: const Text('TXT'),
          ),
        ],
      ),
    );
  }

  void _performExport(String format, List<Map<String, dynamic>> logs) {
    // In a real app, this would generate and download the file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${logs.length} logs as $format...'),
        backgroundColor: const Color(0xFF13b464),
      ),
    );
  }
}
