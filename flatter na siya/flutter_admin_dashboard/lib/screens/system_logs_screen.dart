import 'package:flutter/material.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  // Comprehensive sample log data combining both versions
  final List<Map<String, dynamic>> _systemLogs = [
    {
      'dateTime': '2025-01-15 14:35',
      'user': 'CDRRMO Admin',
      'action': 'Notification Posted',
      'category': 'Content Management',
      'status': 'Success',
      'details': 'Posted emergency alert: Flash flood warning for Barangay Central',
      'icon': Icons.notifications,
      'color': Colors.green,
      'severity': 'High',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-15 14:30',
      'user': 'CDRRMO Admin',
      'action': 'User Login',
      'category': 'Authentication',
      'status': 'Success',
      'details': 'Admin successfully logged into the system',
      'icon': Icons.login,
      'color': Colors.blue,
      'severity': 'Medium',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-15 13:20',
      'user': 'System Admin',
      'action': 'User Account Created',
      'category': 'User Management',
      'status': 'Success',
      'details': 'New user account created for Maria Santos',
      'icon': Icons.person_add,
      'color': Colors.purple,
      'severity': 'Medium',
      'ipAddress': '192.168.1.45',
    },
    {
      'dateTime': '2025-01-15 12:15',
      'user': 'System Admin',
      'action': 'Emergency Hotline Updated',
      'category': 'System Configuration',
      'status': 'Success',
      'details': 'Updated Fire Department hotline: 117 -> 911-FIRE',
      'icon': Icons.phone,
      'color': Colors.orange,
      'severity': 'High',
      'ipAddress': '192.168.1.45',
    },
    {
      'dateTime': '2025-01-15 11:45',
      'user': 'CDRRMO Admin',
      'action': 'Alert Deactivated',
      'category': 'Content Management',
      'status': 'Success',
      'details': 'Deactivated weather advisory alert',
      'icon': Icons.notifications_off,
      'color': Colors.grey,
      'severity': 'Medium',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-15 11:20',
      'user': 'System Admin',
      'action': 'User Role Updated',
      'category': 'User Management',
      'status': 'Success',
      'details': 'Changed John Doe role from Volunteer to Emergency Responder',
      'icon': Icons.security,
      'color': Colors.indigo,
      'severity': 'Medium',
      'ipAddress': '192.168.1.45',
    },
    {
      'dateTime': '2025-01-15 10:30',
      'user': 'CDRRMO Admin',
      'action': 'Mass Notification Sent',
      'category': 'Content Management',
      'status': 'Success',
      'details': 'Emergency evacuation notice sent to 1,247 mobile users',
      'icon': Icons.campaign,
      'color': Colors.red,
      'severity': 'Critical',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-15 09:15',
      'user': 'System Admin',
      'action': 'Database Backup',
      'category': 'System Maintenance',
      'status': 'Success',
      'details': 'Automatic daily backup completed successfully (2.4GB)',
      'icon': Icons.backup,
      'color': Colors.green,
      'severity': 'Low',
      'ipAddress': 'SYSTEM',
    },
    {
      'dateTime': '2025-01-15 08:45',
      'user': 'CDRRMO Admin',
      'action': 'Login Attempt Failed',
      'category': 'Authentication',
      'status': 'Failed',
      'details': 'Invalid password attempt from IP: 192.168.1.100',
      'icon': Icons.error,
      'color': Colors.red,
      'severity': 'Critical',
      'ipAddress': '192.168.1.100',
    },
    {
      'dateTime': '2025-01-15 08:00',
      'user': 'System Admin',
      'action': 'System Restart',
      'category': 'System Maintenance',
      'status': 'Success',
      'details': 'System successfully restarted for maintenance updates',
      'icon': Icons.restart_alt,
      'color': Colors.blue,
      'severity': 'High',
      'ipAddress': 'SYSTEM',
    },
    {
      'dateTime': '2025-01-14 23:30',
      'user': 'Auto System',
      'action': 'Data Synchronization',
      'category': 'System Maintenance',
      'status': 'Success',
      'details': 'Mobile app data synchronized with central database',
      'icon': Icons.sync,
      'color': Colors.teal,
      'severity': 'Low',
      'ipAddress': 'SYSTEM',
    },
    {
      'dateTime': '2025-01-14 22:15',
      'user': 'CDRRMO Admin',
      'action': 'Emergency Contact Added',
      'category': 'System Configuration',
      'status': 'Success',
      'details': 'Added new emergency contact: Rescue Team Alpha (09123456789)',
      'icon': Icons.contact_emergency,
      'color': Colors.orange,
      'severity': 'Medium',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-14 21:45',
      'user': 'System Admin',
      'action': 'User Account Deleted',
      'category': 'User Management',
      'status': 'Success',
      'details': 'Deleted inactive user account: John Smith',
      'icon': Icons.person_remove,
      'color': Colors.red,
      'severity': 'Medium',
      'ipAddress': '192.168.1.45',
    },
    {
      'dateTime': '2025-01-14 20:30',
      'user': 'CDRRMO Admin',
      'action': 'Alert Template Created',
      'category': 'Content Management',
      'status': 'Success',
      'details': 'Created new alert template for typhoon warnings',
      'icon': Icons.edit_notifications,
      'color': Colors.purple,
      'severity': 'Medium',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-14 19:15',
      'user': 'System Admin',
      'action': 'Permission Updated',
      'category': 'User Management',
      'status': 'Success',
      'details': 'Updated admin permissions for CDRRMO Admin',
      'icon': Icons.admin_panel_settings,
      'color': Colors.green,
      'severity': 'High',
      'ipAddress': '192.168.1.45',
    },
    {
      'dateTime': '2025-01-14 18:00',
      'user': 'Auto System',
      'action': 'Log Cleanup',
      'category': 'System Maintenance',
      'status': 'Success',
      'details': 'Cleaned up old system logs (30 days+)',
      'icon': Icons.cleaning_services,
      'color': Colors.blue,
      'severity': 'Low',
      'ipAddress': 'SYSTEM',
    },
    {
      'dateTime': '2025-01-14 17:45',
      'user': 'CDRRMO Admin',
      'action': 'User Export',
      'category': 'User Management',
      'status': 'Success',
      'details': 'Exported user list to CSV format (250 users)',
      'icon': Icons.download,
      'color': Colors.green,
      'severity': 'Low',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-14 16:30',
      'user': 'System Admin',
      'action': 'Security Scan',
      'category': 'System Maintenance',
      'status': 'Warning',
      'details': 'Completed automated security vulnerability scan - 2 minor issues found',
      'icon': Icons.security,
      'color': Colors.orange,
      'severity': 'Medium',
      'ipAddress': 'SYSTEM',
    },
    {
      'dateTime': '2025-01-14 15:15',
      'user': 'CDRRMO Admin',
      'action': 'Notification Scheduled',
      'category': 'Content Management',
      'status': 'Success',
      'details': 'Scheduled weather update notification for tomorrow 6AM',
      'icon': Icons.schedule_send,
      'color': Colors.orange,
      'severity': 'Medium',
      'ipAddress': '192.168.1.50',
    },
    {
      'dateTime': '2025-01-14 14:00',
      'user': 'System Admin',
      'action': 'Configuration Update',
      'category': 'System Configuration',
      'status': 'Success',
      'details': 'Updated mobile app configuration settings',
      'icon': Icons.settings,
      'color': Colors.grey,
      'severity': 'Low',
      'ipAddress': '192.168.1.45',
    },
    {
      'dateTime': '2025-01-14 13:30',
      'user': 'Unknown User',
      'action': 'Unauthorized Access Attempt',
      'category': 'Security',
      'status': 'Failed',
      'details': 'Failed login attempt with invalid credentials',
      'icon': Icons.warning,
      'color': Colors.red,
      'severity': 'Critical',
      'ipAddress': '192.168.1.999',
    },
    {
      'dateTime': '2025-01-14 12:45',
      'user': 'Auto System',
      'action': 'Performance Monitor',
      'category': 'System Maintenance',
      'status': 'Warning',
      'details': 'CPU usage exceeded 85% threshold for 10 minutes',
      'icon': Icons.monitor,
      'color': Colors.orange,
      'severity': 'Medium',
      'ipAddress': 'SYSTEM',
    },
  ];

  // Enhanced filter variables - ALL FEATURES COMBINED
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';
  String _selectedSeverity = 'All';
  String _selectedDateRange = 'All Time';
  bool _isCompactView = true; // Toggle between compact and detailed view

  // Filtered logs
  List<Map<String, dynamic>> _filteredLogs = [];

  @override
  void initState() {
    super.initState();
    _filteredLogs = List.from(_systemLogs);
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_systemLogs);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((log) {
        return log['user'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               log['action'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               log['details'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               log['category'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((log) => log['category'] == _selectedCategory).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All') {
      filtered = filtered.where((log) => log['status'] == _selectedStatus).toList();
    }

    // Apply severity filter
    if (_selectedSeverity != 'All') {
      filtered = filtered.where((log) => log['severity'] == _selectedSeverity).toList();
    }

    // Apply date range filter
    if (_selectedDateRange == 'Today') {
      filtered = filtered.where((log) => log['dateTime'].contains('2025-01-15')).toList();
    } else if (_selectedDateRange == 'Yesterday') {
      filtered = filtered.where((log) => log['dateTime'].contains('2025-01-14')).toList();
    }

    setState(() {
      _filteredLogs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Header with View Toggle & Refresh Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'System Activity Logs',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // View Toggle Switch
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isCompactView ? Icons.view_compact : Icons.view_comfortable,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isCompactView ? 'Compact' : 'Detailed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _isCompactView,
                            onChanged: (value) {
                              setState(() {
                                _isCompactView = value;
                              });
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Refresh Button
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _filteredLogs = List.from(_systemLogs);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logs refreshed successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Refresh', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2d5f3f),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Enhanced Filter Section with READABLE font sizes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // First row of filters
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        flex: 2,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                            _applyFilters();
                          },
                          decoration: InputDecoration(
                            hintText: 'Search logs by user, action, details...',
                            hintStyle: const TextStyle(fontSize: 14), // Readable hint
                            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                      _applyFilters();
                                    },
                                    icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // More padding
                            isDense: false, // Allow normal height
                          ),
                          style: const TextStyle(fontSize: 14), // Readable input text
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Date Range Filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedDateRange,
                          decoration: InputDecoration(
                            labelText: 'Date Range',
                            labelStyle: const TextStyle(fontSize: 14), // Readable label
                            prefixIcon: const Icon(Icons.date_range, color: Colors.grey, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            isDense: false,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'All Time', child: Text('All Time', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Today', child: Text('Today', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Yesterday', child: Text('Yesterday', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Last 7 Days', child: Text('Last 7 Days', style: TextStyle(fontSize: 14))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedDateRange = value!;
                            });
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Severity Filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSeverity,
                          decoration: InputDecoration(
                            labelText: 'Severity',
                            labelStyle: const TextStyle(fontSize: 14), // Readable label
                            prefixIcon: const Icon(Icons.priority_high, color: Colors.grey, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            isDense: false,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All Severity', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Critical', child: Text('Critical', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'High', child: Text('High', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Medium', child: Text('Medium', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Low', child: Text('Low', style: TextStyle(fontSize: 14))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSeverity = value!;
                            });
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Second row of filters
                  Row(
                    children: [
                      // Category Filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: const TextStyle(fontSize: 14), // Readable label
                            prefixIcon: const Icon(Icons.category, color: Colors.grey, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            isDense: false,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All Categories', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Authentication', child: Text('Authentication', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Content Management', child: Text('Content Management', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'User Management', child: Text('User Management', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'System Configuration', child: Text('System Configuration', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'System Maintenance', child: Text('System Maintenance', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Security', child: Text('Security', style: TextStyle(fontSize: 14))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Status Filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            labelStyle: const TextStyle(fontSize: 14), // Readable label
                            prefixIcon: const Icon(Icons.check_circle, color: Colors.grey, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            isDense: false,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All Status', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Success', child: Text('Success', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Failed', child: Text('Failed', style: TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: 'Warning', child: Text('Warning', style: TextStyle(fontSize: 14))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                            _applyFilters();
                          },
                        ),
                      ),
                      
                      // Spacer for alignment
                      Expanded(child: Container()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Results summary with enhanced statistics (READABLE)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Results count with quick stats
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2d5f3f).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${_filteredLogs.length} of ${_systemLogs.length} logs',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2d5f3f),
                                fontSize: 14, // Readable size
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Success count badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 16, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(
                                  '${_filteredLogs.where((log) => log['status'] == 'Success').length} Success',
                                  style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Failed count badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error, size: 16, color: Colors.red),
                                const SizedBox(width: 6),
                                Text(
                                  '${_filteredLogs.where((log) => log['status'] == 'Failed').length} Failed',
                                  style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Enhanced Action buttons with readable text
                      Row(
                        children: [
                          if (_searchQuery.isNotEmpty || 
                              _selectedCategory != 'All' || 
                              _selectedStatus != 'All' ||
                              _selectedSeverity != 'All' ||
                              _selectedDateRange != 'All Time')
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _selectedCategory = 'All';
                                  _selectedStatus = 'All';
                                  _selectedSeverity = 'All';
                                  _selectedDateRange = 'All Time';
                                });
                                _applyFilters();
                              },
                              icon: const Icon(Icons.clear_all, size: 16),
                              label: const Text('Clear All', style: TextStyle(fontSize: 13)), // Readable
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[600],
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                          const SizedBox(width: 12),
                          // Enhanced Export Dropdown Button
                          PopupMenuButton<String>(
                            onSelected: (String format) {
                              _exportLogs(format);
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'csv',
                                child: Row(
                                  children: [
                                    Icon(Icons.table_chart, size: 18, color: Colors.green),
                                    const SizedBox(width: 8),
                                    const Text('Export as CSV', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'pdf',
                                child: Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf, size: 18, color: Colors.red),
                                    const SizedBox(width: 8),
                                    const Text('Export as PDF', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'xml',
                                child: Row(
                                  children: [
                                    Icon(Icons.code, size: 18, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    const Text('Export as XML', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.download, size: 16, color: Colors.white),
                                  const SizedBox(width: 6),
                                  const Text('Export', style: TextStyle(fontSize: 13, color: Colors.white)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // BALANCED Logs Table - More logs than original, but readable text
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table Header with READABLE fonts
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2d5f3f),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: _isCompactView ? [
                          // Compact view headers - READABLE
                          SizedBox(width: 120, child: const Text('Date/Time ↓', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 140, child: const Text('User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 170, child: const Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 90, child: const Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          const Expanded(child: Text('Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        ] : [
                          // Detailed view headers - READABLE
                          SizedBox(width: 120, child: const Text('Date/Time ↓', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 120, child: const Text('User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 150, child: const Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 90, child: const Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 80, child: const Text('Severity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          SizedBox(width: 110, child: const Text('IP Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          const Expanded(child: Text('Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        ],
                      ),
                    ),
                    
                    // BALANCED Table Body - More logs but readable
                    Expanded(
                      child: _filteredLogs.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text('No logs found', style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  Text('Try adjusting your search or filter criteria', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredLogs.length,
                              itemBuilder: (context, index) {
                                final log = _filteredLogs[index];
                                return _isCompactView 
                                    ? _buildReadableCompactLogRow(log, index)
                                    : _buildReadableDetailedLogRow(log, index);
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

  // READABLE Compact log row - Shows ~10-12 logs per screen with normal text
  Widget _buildReadableCompactLogRow(Map<String, dynamic> log, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Comfortable padding
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          // Date/Time (readable)
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(log['dateTime'].split(' ')[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(log['dateTime'].split(' ')[1], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          // User (with status dot)
          SizedBox(
            width: 140,
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: log['color'], shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(log['user'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          // Action
          SizedBox(
            width: 170,
            child: Row(
              children: [
                Icon(log['icon'], size: 18, color: log['color']),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(log['action'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                      Text(log['category'], style: TextStyle(fontSize: 11, color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Status
          SizedBox(
            width: 90,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: log['status'] == 'Success' ? Colors.green.withValues(alpha: 0.1) 
                     : log['status'] == 'Failed' ? Colors.red.withValues(alpha: 0.1) 
                     : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: log['status'] == 'Success' ? Colors.green 
                       : log['status'] == 'Failed' ? Colors.red 
                       : Colors.orange, 
                  width: 1
                ),
              ),
              child: Text(
                log['status'],
                style: TextStyle(
                  color: log['status'] == 'Success' ? Colors.green 
                       : log['status'] == 'Failed' ? Colors.red 
                       : Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Details
          Expanded(child: Text(log['details'], style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis, maxLines: 2)),
        ],
      ),
    );
  }

  // READABLE Detailed log row with all information
  Widget _buildReadableDetailedLogRow(Map<String, dynamic> log, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // More comfortable padding
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          // Date/Time
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(log['dateTime'].split(' ')[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(log['dateTime'].split(' ')[1], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          // User
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: log['color'], shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(log['user'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          // Action
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(log['icon'], size: 18, color: log['color']),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(log['action'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                      Text(log['category'], style: TextStyle(fontSize: 11, color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Status
          SizedBox(
            width: 90,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: log['status'] == 'Success' ? Colors.green.withValues(alpha: 0.1) 
                     : log['status'] == 'Failed' ? Colors.red.withValues(alpha: 0.1) 
                     : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: log['status'] == 'Success' ? Colors.green 
                       : log['status'] == 'Failed' ? Colors.red 
                       : Colors.orange, 
                  width: 1
                ),
              ),
              child: Text(
                log['status'],
                style: TextStyle(
                  color: log['status'] == 'Success' ? Colors.green 
                       : log['status'] == 'Failed' ? Colors.red 
                       : Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Severity
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: _getSeverityColor(log['severity']).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _getSeverityColor(log['severity']), width: 1),
              ),
              child: Text(
                log['severity'],
                style: TextStyle(
                  color: _getSeverityColor(log['severity']),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // IP Address
          SizedBox(
            width: 110,
            child: Text(
              log['ipAddress'],
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Details
          Expanded(child: Text(log['details'], style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.blue;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  // Enhanced Export Function with Multiple Formats
  void _exportLogs(String format) {
    String message;
    Color backgroundColor;
    IconData icon;
    
    switch (format) {
      case 'csv':
        message = '${_filteredLogs.length} logs exported to CSV successfully!';
        backgroundColor = Colors.green;
        icon = Icons.table_chart;
        break;
      case 'pdf':
        message = '${_filteredLogs.length} logs exported to PDF successfully!';
        backgroundColor = Colors.red;
        icon = Icons.picture_as_pdf;
        break;
      case 'xml':
        message = '${_filteredLogs.length} logs exported to XML successfully!';
        backgroundColor = Colors.orange;
        icon = Icons.code;
        break;
      default:
        message = 'Export completed successfully!';
        backgroundColor = Colors.blue;
        icon = Icons.download;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Here you would implement actual file viewing logic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${format.toUpperCase()} file...'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
