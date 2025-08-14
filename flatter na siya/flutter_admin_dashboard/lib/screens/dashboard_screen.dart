import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/admin_drawer.dart';
import 'system_logs_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
  final List<String> _titles = [
    'Dashboard Home',
    'User Management',
    'Post Notification', 
    'Settings',
    'System Logs',
  ];

  // User Management CRUD State - Mobile Users Only
  final List<Map<String, String>> _users = [
    {'id': '1', 'name': 'John Doe', 'contact': '09123456789', 'address': 'Block 1 Lot 5, San Antonio Village, San Pedro', 'role': 'Emergency Responder', 'status': 'Active'},
    {'id': '2', 'name': 'Jane Smith', 'contact': '09987654321', 'address': 'Unit 205, Greenfield Heights, San Pedro', 'role': 'Community Leader', 'status': 'Active'},
    {'id': '3', 'name': 'Mike Johnson', 'contact': '09456789123', 'address': '123 Maharlika St., Poblacion, San Pedro', 'role': 'Volunteer', 'status': 'Inactive'},
    {'id': '4', 'name': 'Sarah Wilson', 'contact': '09321654987', 'address': 'Block 8 Lot 12, Villa Maria Subdivision, San Pedro', 'role': 'Emergency Responder', 'status': 'Active'},
    {'id': '5', 'name': 'David Brown', 'contact': '09876543210', 'address': '456 Rizal Avenue, San Pedro', 'role': 'Community Leader', 'status': 'Active'},
    {'id': '6', 'name': 'Maria Garcia', 'contact': '09234567890', 'address': 'Block 3 Lot 8, Golden City Subdivision, San Pedro', 'role': 'Volunteer', 'status': 'Active'},
    {'id': '7', 'name': 'Robert Martinez', 'contact': '09345678901', 'address': '789 Sampaguita Street, San Pedro', 'role': 'Emergency Responder', 'status': 'Active'},
    {'id': '8', 'name': 'Lisa Anderson', 'contact': '09567890123', 'address': 'Unit 102, Pacific Plaza, San Pedro', 'role': 'Community Leader', 'status': 'Active'},
    {'id': '9', 'name': 'Carlos Rodriguez', 'contact': '09678901234', 'address': 'Block 5 Lot 15, San Roque Village, San Pedro', 'role': 'Volunteer', 'status': 'Inactive'},
    {'id': '10', 'name': 'Anna Torres', 'contact': '09789012345', 'address': '321 Mabini Street, San Pedro', 'role': 'Emergency Responder', 'status': 'Active'},
    {'id': '11', 'name': 'James Wilson', 'contact': '09890123456', 'address': 'Block 7 Lot 20, New Manila Heights, San Pedro', 'role': 'Community Leader', 'status': 'Active'},
    {'id': '12', 'name': 'Elena Santos', 'contact': '09901234567', 'address': '654 Del Pilar Avenue, San Pedro', 'role': 'Volunteer', 'status': 'Active'},
  ];

  // Controllers for user form
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedRole = 'Volunteer';
  String? _editingUserId;

  // Filter and Sort State Variables
  String _userSearchQuery = '';
  String _selectedRoleFilter = 'All';
  String _selectedStatusFilter = 'All';
  String _sortBy = 'name'; // name, contact, address, role
  bool _sortAscending = true;
  List<Map<String, String>> _filteredUsers = [];

  // Emergency Contacts CRUD State - For Mobile App Display
  final List<Map<String, String>> _emergencyContacts = [
    {'id': '1', 'name': 'San Pedro CDRRMO Hotline', 'number': '09171234567', 'type': 'Primary'},
    {'id': '2', 'name': 'Fire Department', 'number': '09987654321', 'type': 'Emergency'},
    {'id': '3', 'name': 'Police Station', 'number': '09456789123', 'type': 'Security'},
    {'id': '4', 'name': 'Medical Response Team', 'number': '09321654987', 'type': 'Health'},
    {'id': '5', 'name': 'Rescue Team', 'number': '09876543210', 'type': 'Rescue'},
  ];

  // Controllers for emergency contact form
  final _hotlineNameController = TextEditingController();
  final _hotlineNumberController = TextEditingController();
  
  // Controllers for notification form with validation
  String? _selectedAlertType;
  final _alertTitleController = TextEditingController();
  final _alertMessageController = TextEditingController();

  // Notification CRUD data
  List<Map<String, String>> _notifications = [
    {
      'id': '1',
      'title': 'Flood Warning Alert',
      'message': 'Heavy rainfall expected in low-lying areas. Residents are advised to move to higher ground.',
      'type': 'emergency',
      'status': 'Active',
      'createdAt': '2025-01-15 08:30 AM',
      'sentTo': '250 users',
    },
    {
      'id': '2',
      'title': 'Road Closure Notice',
      'message': 'Main highway will be temporarily closed for emergency repairs from 2 PM to 6 PM today.',
      'type': 'warning',
      'status': 'Active',
      'createdAt': '2025-01-15 07:15 AM',
      'sentTo': '180 users',
    },
    {
      'id': '3',
      'title': 'Weather Update',
      'message': 'Clear skies expected for the next 3 days. Normal activities may resume.',
      'type': 'info',
      'status': 'Inactive',
      'createdAt': '2025-01-14 06:00 PM',
      'sentTo': '320 users',
    },
  ];

  String? _editingNotificationId;

  @override
  void initState() {
    super.initState();
    _filteredUsers = List.from(_users);
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Update the existing _validateAndSendAlert method
  void _validateAndSendAlert() {
    String? errorMessage = _validateNotificationForm();
    
    if (errorMessage != null) {
      _showErrorSnackbar(errorMessage);
      return;
    }

    // Add new notification to the list
    final newId = (_notifications.length + 1).toString();
    final currentTime = DateTime.now();
    final formattedTime = "${currentTime.year}-${currentTime.month.toString().padLeft(2, '0')}-${currentTime.day.toString().padLeft(2, '0')} ${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')} ${currentTime.hour >= 12 ? 'PM' : 'AM'}";
    
    setState(() {
      _notifications.insert(0, {
        'id': newId,
        'title': _alertTitleController.text.trim(),
        'message': _alertMessageController.text.trim(),
        'type': _selectedAlertType!,
        'status': 'Active',
        'createdAt': formattedTime,
        'sentTo': '${_users.length} users',
      });
    });

    _showSuccessSnackbar('${_selectedAlertType!.toUpperCase()} Alert "${_alertTitleController.text.trim()}" sent successfully to all ${_users.length} users!');
    _clearAlertForm();
  }

  // Update the existing _clearAlertForm method
  void _clearAlertForm() {
    setState(() {
      _selectedAlertType = null;
      _alertTitleController.clear();
      _alertMessageController.clear();
    });
    
    if (_editingNotificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.clear, color: Colors.white),
              SizedBox(width: 8),
              Text('Form cleared successfully.'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Show alert statistics
  Widget _showAlertStats() {
    return Column(
      children: [
        const Text(
          'Alert Statistics',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard('🚨', 'Emergency', '12', Colors.red),
            _buildStatCard('⚠️', 'Warning', '28', Colors.orange),
            _buildStatCard('ℹ️', 'Info', '45', Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String type, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(type, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _hotlineNameController.dispose();
    _hotlineNumberController.dispose();
    _alertTitleController.dispose();
    _alertMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2d5f3f),
        foregroundColor: Colors.white,
        title: Text(_titles[_selectedIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Text(
                  'Welcome, ',
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  'CDRRMO',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: AdminDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onLogout: _logout,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return _buildUserManagement();
      case 2:
        return _buildNotifications();
      case 3:
        return _buildSettings();
      case 4:
        return const SystemLogsScreen();
      default:
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/b.jpg'),
          fit: BoxFit.cover,
          opacity: 0.05,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Dashboard Header with larger icons and better readability
            Container(
              height: 140, // Increased height for better visibility
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2d5f3f),
                    Color(0xFF3a7a52),
                    Color(0xFF4a8b63),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Increased padding
                child: Row(
                  children: [
                    // Left Section (30%) - Enhanced Branding
                    Expanded(
                      flex: 30,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12), // Larger padding
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              size: 32, // Larger icon
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12), // Increased spacing
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CDRRMO',
                                  style: TextStyle(
                                    fontSize: 18, // Larger font
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'Warning System',
                                  style: TextStyle(
                                    fontSize: 12, // Readable size
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 4), // More spacing
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'ONLINE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16), // Increased spacing
                    
                    // Center Section (50%) - Enhanced Statistics with clickable icons
                    Expanded(
                      flex: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _showUsersModal(),
                            child: _buildLargerStatusItem(
                              icon: Icons.people_outline,
                              label: 'Users',
                              value: '${_users.length}',
                              color: Colors.lightBlue,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 1,
                            child: Container(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showEmergencyContactsModal(),
                            child: _buildLargerStatusItem(
                              icon: Icons.phone,
                              label: 'Emergency Contacts',
                              value: '${_emergencyContacts.length}',
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 1,
                            child: Container(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showAlertsModal(),
                            child: _buildLargerStatusItem(
                              icon: Icons.notifications_active,
                              label: 'Alerts',
                              value: '3',
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 1,
                            child: Container(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showEmergencyTeamsModal(),
                            child: _buildLargerStatusItem(
                              icon: Icons.security,
                              label: 'Emergency Response Teams',
                              value: '${_users.where((user) => user['role'] == 'Emergency Responder').length}',
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16), // Increased spacing
                    
                    // Right Section (20%) - Enhanced Admin Profile
                    Expanded(
                      flex: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20, // Larger avatar
                            backgroundColor: Colors.white.withValues(alpha: 0.15),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              size: 22, // Larger icon
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6), // More spacing
                          const Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12, // Readable size
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ONLINE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Combined User Management & Quick Actions Section (Enhanced)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // Container left empty as requested
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick Action Methods
  void _quickAddUser() {
    // Navigate to User Management and open Add User dialog
    setState(() {
      _selectedIndex = 1;
    });
    // Delay to allow navigation, then show dialog
    Future.delayed(const Duration(milliseconds: 300), () {
      _showAddUserDialog();
    });
  }

  void _quickSendAlert() {
    // Navigate to Notifications section
    setState(() {
      _selectedIndex = 2;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Switched to Post Notification section for quick alert'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildUserManagement() {
    // Apply filters and sorting
    _applyFiltersAndSorting();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Export Button and Add User Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mobile App Users Management',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  // Export Button with Dropdown
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (String format) => _exportUsers(format),
                      tooltip: 'Export Users',
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'csv',
                          child: Row(
                            children: [
                              Icon(Icons.table_chart, color: Colors.green, size: 18),
                              SizedBox(width: 12),
                              Text('Export as CSV'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'pdf',
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
                              SizedBox(width: 12),
                              Text('Export as PDF'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'xml',
                          child: Row(
                            children: [
                              Icon(Icons.code, color: Colors.orange, size: 18),
                              SizedBox(width: 12),
                              Text('Export as XML'),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.download, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Export Users',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: InkWell(
                      onTap: _showAddUserDialog,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2d5f3f),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2d5f3f).withValues(alpha: 0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_add, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Add Mobile User',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filter and Search Section
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
                // Search and Filter Row
                Row(
                  children: [
                    // Search Bar
                    Expanded(
                      flex: 2,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _userSearchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search users by name, contact, or address...',
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _userSearchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _userSearchQuery = '';
                                    });
                                  },
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Role Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRoleFilter,
                        decoration: InputDecoration(
                          labelText: 'Filter by Role',
                          prefixIcon: const Icon(Icons.work, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All Roles')),
                          DropdownMenuItem(value: 'Emergency Responder', child: Text('Emergency Responder')),
                          DropdownMenuItem(value: 'Community Leader', child: Text('Community Leader')),
                          DropdownMenuItem(value: 'Volunteer', child: Text('Volunteer')),
                          DropdownMenuItem(value: 'Citizen', child: Text('Citizen')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRoleFilter = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Status Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatusFilter,
                        decoration: InputDecoration(
                          labelText: 'Filter by Status',
                          prefixIcon: const Icon(Icons.circle, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All Status')),
                          DropdownMenuItem(value: 'Active', child: Text('Active')),
                          DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatusFilter = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Sort Options and Results Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sort Options
                    Row(
                      children: [
                        const Text(
                          'Sort by:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _sortBy,
                          underline: Container(),
                          items: const [
                            DropdownMenuItem(value: 'name', child: Text('Name')),
                            DropdownMenuItem(value: 'contact', child: Text('Contact')),
                            DropdownMenuItem(value: 'address', child: Text('Address')),
                            DropdownMenuItem(value: 'role', child: Text('Role')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _sortBy = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _sortAscending = !_sortAscending;
                            });
                          },
                          icon: Icon(
                            _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                            color: const Color(0xFF2d5f3f),
                          ),
                          tooltip: _sortAscending ? 'Sort Ascending' : 'Sort Descending',
                        ),
                      ],
                    ),
                    
                    // Results Summary and Clear Filters
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2d5f3f).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_filteredUsers.length} of ${_users.length} users',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2d5f3f),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_userSearchQuery.isNotEmpty || 
                            _selectedRoleFilter != 'All' || 
                            _selectedStatusFilter != 'All')
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _userSearchQuery = '';
                                _selectedRoleFilter = 'All';
                                _selectedStatusFilter = 'All';
                                _sortBy = 'name';
                                _sortAscending = true;
                              });
                            },
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Clear Filters'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[600],
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
          
          // User List
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
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2d5f3f),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 2, child: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('Contact Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 3, child: Text('Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  // User Rows
                  Expanded(
                    child: _filteredUsers.isEmpty
                        ? Center(
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
                                  'No users found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search or filter criteria',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return _buildUserRow(user, index);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFiltersAndSorting() {
    List<Map<String, String>> filtered = List.from(_users);

    // Apply search filter
    if (_userSearchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user['name']!.toLowerCase().contains(_userSearchQuery.toLowerCase()) ||
               user['contact']!.toLowerCase().contains(_userSearchQuery.toLowerCase()) ||
               user['address']!.toLowerCase().contains(_userSearchQuery.toLowerCase());
      }).toList();
    }

    // Apply role filter
    if (_selectedRoleFilter != 'All') {
      filtered = filtered.where((user) => user['role'] == _selectedRoleFilter).toList();
    }

    // Apply status filter
    if (_selectedStatusFilter != 'All') {
      filtered = filtered.where((user) => user['status'] == _selectedStatusFilter).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      String aValue = '';
      String bValue = '';
      
      switch (_sortBy) {
        case 'name':
          aValue = a['name']!;
          bValue = b['name']!;
          break;
        case 'contact':
          aValue = a['contact']!;
          bValue = b['contact']!;
          break;
        case 'address':
          aValue = a['address']!;
          bValue = b['address']!;
          break;
        case 'role':
          aValue = a['role']!;
          bValue = b['role']!;
          break;
      }

      int comparison = aValue.toLowerCase().compareTo(bValue.toLowerCase());
      return _sortAscending ? comparison : -comparison;
    });

    _filteredUsers = filtered;
  }

  Widget _buildUserRow(Map<String, String> user, int index) {
    // Get status color
    Color statusColor;
    switch (user['status']) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Inactive':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF2d5f3f),
                  child: Text(user['name']![0], style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              user['contact']!,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Tooltip(
              message: user['address']!,
              child: Text(
                user['address']!,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              user['role']!,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    color: statusColor,
                    size: 8,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user['status']!,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showEditUserDialog(user),
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  tooltip: 'Edit User',
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(user),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  tooltip: 'Delete User',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CRUD Operations
  void _showAddUserDialog() {
    _clearForm();
    _editingUserId = null;
    _showUserDialog('Add Mobile User');
  }

  void _showEditUserDialog(Map<String, String> user) {
    // Parse the full name into parts
    _parseFullNameToFields(user['name']!);
    
    _contactController.text = user['contact']!;
    _addressController.text = user['address']!;
    _selectedRole = user['role']!;
    _editingUserId = user['id'];
    _showUserDialog('Edit Mobile User');
  }

  void _showUserDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 600,
                height: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // First Name and Last Name Row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _firstNameController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: const InputDecoration(
                                labelText: 'First Name *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _lastNameController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: const InputDecoration(
                                labelText: 'Last Name *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Middle Name and Suffix Row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _middleNameController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: const InputDecoration(
                                labelText: 'Middle Name (Optional)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _suffixController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: const InputDecoration(
                                labelText: 'Suffix (Optional)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.text_fields),
                                hintText: 'Jr., Sr., III, etc.',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Contact Number
                      TextField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        decoration: const InputDecoration(
                          labelText: 'Contact Number (09XXXXXXXXX) *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Enter 11-digit mobile number',
                          helperText: 'Must start with 09 and be 11 digits total',
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Address Field
                      TextField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Complete Address *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                          hintText: 'Block/Lot, Street, Barangay, San Pedro',
                          helperText: 'Include complete address for emergency response',
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Role Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.work),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Emergency Responder', child: Text('Emergency Responder')),
                          DropdownMenuItem(value: 'Community Leader', child: Text('Community Leader')),
                          DropdownMenuItem(value: 'Volunteer', child: Text('Volunteer')),
                          DropdownMenuItem(value: 'Citizen', child: Text('Citizen')),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Validate and save - modal stays open if validation fails
                            _validateAndSaveUser(context, setDialogState);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2d5f3f),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2d5f3f).withValues(alpha: 0.3),
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _editingUserId == null ? 'Add Mobile User' : 'Update Mobile User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _validateAndSaveUser(BuildContext dialogContext, StateSetter setDialogState) {
    // Clear any previous error messages
    String? errorMessage;

    // Validation for required fields with specific error messages
    if (_firstNameController.text.trim().isEmpty) {
      errorMessage = '❌ First Name is required - Please enter the user\'s first name';
    }
    else if (!_isValidName(_firstNameController.text.trim())) {
      errorMessage = '❌ Invalid First Name - Only letters, spaces, dashes, and Ñ are allowed';
    }
    else if (_lastNameController.text.trim().isEmpty) {
      errorMessage = '❌ Last Name is required - Please enter the user\'s last name';
    }
    else if (!_isValidName(_lastNameController.text.trim())) {
      errorMessage = '❌ Invalid Last Name - Only letters, spaces, dashes, and Ñ are allowed';
    }
    // Validate optional middle name if provided
    else if (_middleNameController.text.trim().isNotEmpty && !_isValidName(_middleNameController.text.trim())) {
      errorMessage = '❌ Invalid Middle Name - Only letters, spaces, dashes, and Ñ are allowed';
    }
    // Validate optional suffix if provided
    else if (_suffixController.text.trim().isNotEmpty && !_isValidName(_suffixController.text.trim())) {
      errorMessage = '❌ Invalid Suffix - Only letters, spaces, dashes, and Ñ are allowed';
    }
    else if (_contactController.text.trim().isEmpty) {
      errorMessage = '❌ Contact Number is required - Please enter a valid mobile number';
    }
    else if (!_contactController.text.startsWith('09')) {
      errorMessage = '❌ Invalid Contact Number - Must start with 09 (e.g., 09123456789)';
    }
    else if (_contactController.text.length != 11) {
      errorMessage = '❌ Invalid Contact Number - Must be exactly 11 digits (09XXXXXXXXX)';
    }
    else if (!RegExp(r'^[0-9]+$').hasMatch(_contactController.text)) {
      errorMessage = '❌ Invalid Contact Number - Must contain only numbers';
    }
    else if (_addressController.text.trim().isEmpty) {
      errorMessage = '❌ Complete Address is required - Please enter the user\'s full address';
    }
    else if (_addressController.text.trim().length < 10) {
      errorMessage = '❌ Incomplete Address - Please provide a complete address (minimum 10 characters)';
    }
    // Check for duplicate contact numbers (except when editing the same user)
    else if (_users.any((user) => 
      user['contact'] == _contactController.text && 
      user['id'] != _editingUserId)) {
      errorMessage = '❌ Duplicate Contact Number - This mobile number is already registered in the system';
    }

    // If validation fails, show error and keep modal open
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  errorMessage,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      
      // Keep modal open - don't proceed with saving
      return;
    }

    // If validation passes, save the user and close modal
    _saveValidatedUser();
    Navigator.of(dialogContext).pop(); // Close modal only on success
  }

  void _saveValidatedUser() {
    // Construct full name from separated fields
    String fullName = _constructFullName();

    setState(() {
      if (_editingUserId == null) {
        // Add new user (all users are active by default)
        final newId = (_users.length + 1).toString();
        _users.add({
          'id': newId,
          'name': fullName,
          'contact': _contactController.text,
          'address': _addressController.text,
          'role': _selectedRole,
          'status': 'Active', // Default status for all users
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '✅ Success! Mobile user "$fullName" has been added to the system',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        // Update existing user
        final userIndex = _users.indexWhere((user) => user['id'] == _editingUserId);
        if (userIndex != -1) {
          _users[userIndex] = {
            'id': _editingUserId!,
            'name': fullName,
            'contact': _contactController.text,
            'address': _addressController.text,
            'role': _selectedRole,
            'status': _users[userIndex]['status']!, // Keep existing status
          };
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '✅ Success! Mobile user "$fullName" has been updated successfully',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    });
    _clearForm();
  }

  void _showDeleteConfirmation(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${user['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteUser(user['id']!);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(String userId) {
    setState(() {
      _users.removeWhere((user) => user['id'] == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mobile user deleted successfully!')),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _suffixController.clear();
    _contactController.clear();
    _addressController.clear();
    _selectedRole = 'Volunteer';
  }

  // Helper method to parse full name into separate fields
  void _parseFullNameToFields(String fullName) {
    List<String> nameParts = fullName.split(' ');
    
    if (nameParts.isNotEmpty) {
      _firstNameController.text = nameParts[0];
      
      if (nameParts.length >= 2) {
        _lastNameController.text = nameParts.last;
        
        // Check if last part is a suffix
        String lastPart = nameParts.last.toLowerCase();
        if (lastPart == 'jr.' || lastPart == 'jr' || lastPart == 'sr.' || 
            lastPart == 'sr' || lastPart == 'iii' || lastPart == 'iv' || 
            lastPart == 'ii' || lastPart == 'v') {
          _suffixController.text = nameParts.last;
          if (nameParts.length >= 3) {
            _lastNameController.text = nameParts[nameParts.length - 2];
          }
        }
        
        // Middle name (if more than 2 parts and not a suffix scenario)
        if (nameParts.length >= 3 && _suffixController.text.isEmpty) {
          _middleNameController.text = nameParts.sublist(1, nameParts.length - 1).join(' ');
        } else if (nameParts.length >= 4) {
          // If there's a suffix, middle names are in between
          _middleNameController.text = nameParts.sublist(1, nameParts.length - 2).join(' ');
        }
      }
    }
  }

  // Helper method to construct full name from separated fields
  String _constructFullName() {
    List<String> nameParts = [];
    
    // Add first name (required)
    nameParts.add(_firstNameController.text.trim());
    
    // Add middle name if provided
    if (_middleNameController.text.trim().isNotEmpty) {
      nameParts.add(_middleNameController.text.trim());
    }
    
    // Add last name (required)
    nameParts.add(_lastNameController.text.trim());
    
    // Add suffix if provided
    if (_suffixController.text.trim().isNotEmpty) {
      nameParts.add(_suffixController.text.trim());
    }
    
    return nameParts.join(' ');
  }

  // Name validation helper method
  bool _isValidName(String name) {
    // Allow letters (a-z, A-Z), spaces, dashes (-), and Ñ/ñ
    final namePattern = RegExp(r'^[a-zA-ZñÑ\s\-]+$');
    return namePattern.hasMatch(name.trim()) && name.trim().isNotEmpty;
  }

  // Input formatter for name fields
  TextInputFormatter get _nameInputFormatter {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZñÑ\s\-]'));
  }

  // Export Users Functionality
  void _exportUsers(String format) {
    String message;
    switch (format) {
      case 'csv':
        message = 'Users exported as CSV file successfully!';
        break;
      case 'pdf':
        message = 'Users exported as PDF file successfully!';
        break;
      case 'xml':
        message = 'Users exported as XML file successfully!';
        break;
      default:
        message = 'Export completed!';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              format == 'csv' ? Icons.table_chart :
              format == 'pdf' ? Icons.picture_as_pdf : Icons.code,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildNotifications() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Add Notification button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Post Emergency Notifications',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddNotificationDialog,
                icon: const Icon(Icons.add_alert),
                label: const Text('Create Alert'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: Row(
              children: [
                // Notification Form
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _editingNotificationId == null ? 'Create New Alert' : 'Edit Alert',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        
                        // Alert Type with validation
                        DropdownButtonFormField<String>(
                          value: _selectedAlertType,
                          decoration: const InputDecoration(
                            labelText: 'Alert Type *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.priority_high),
                            helperText: 'Select the urgency level of your alert',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'emergency', child: Text('🚨 Emergency Alert')),
                            DropdownMenuItem(value: 'warning', child: Text('⚠️ Warning')),
                            DropdownMenuItem(value: 'info', child: Text('ℹ️ Information')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedAlertType = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Alert Title with validation
                        TextField(
                          controller: _alertTitleController,
                          maxLength: 100,
                          decoration: const InputDecoration(
                            labelText: 'Alert Title *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                            hintText: 'Enter a clear, concise title',
                            helperText: 'Maximum 100 characters',
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Alert Message with validation
                        Expanded(
                          child: TextField(
                            controller: _alertMessageController,
                            maxLines: null,
                            expands: true,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              labelText: 'Alert Message *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.message),
                              alignLabelWithHint: true,
                              hintText: 'Provide detailed information about the alert...',
                              helperText: 'Maximum 500 characters',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Action buttons
                        Row(
                          children: [
                            // Send/Update Button
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _editingNotificationId == null ? _validateAndSendAlert : _updateNotification,
                                icon: Icon(_editingNotificationId == null ? Icons.send : Icons.update),
                                label: Text(_editingNotificationId == null ? 'Send Alert' : 'Update Alert'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _editingNotificationId == null ? Colors.orange : Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // Cancel/Clear Button
                            Expanded(
                              child: TextButton.icon(
                                onPressed: _editingNotificationId == null ? _clearAlertForm : _cancelEdit,
                                icon: Icon(_editingNotificationId == null ? Icons.clear : Icons.cancel),
                                label: Text(_editingNotificationId == null ? 'Clear Form' : 'Cancel Edit'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Notifications List (CRUD Table)
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Alert History',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_notifications.length} alerts',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Table Headers
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2d5f3f),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Expanded(flex: 3, child: Text('Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Type', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              Expanded(flex: 2, child: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              Expanded(flex: 2, child: Text('Sent To', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              Expanded(flex: 2, child: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                        
                        // Notifications List
                        Expanded(
                          child: _notifications.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No alerts created yet',
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = _notifications[index];
                                    return _buildNotificationRow(notification, index);
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
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String type, String time) {
    Color typeColor = type == 'Emergency' ? Colors.red : type == 'Warning' ? Colors.orange : Colors.blue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: typeColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const Spacer(),
              Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  // Add notification row builder for CRUD table
  Widget _buildNotificationRow(Map<String, String> notification, int index) {
    // Get type color and icon
    Color typeColor;
    IconData typeIcon;
    String typeDisplay;
    
    switch (notification['type']) {
      case 'emergency':
        typeColor = Colors.red;
        typeIcon = Icons.emergency;
        typeDisplay = 'Emergency';
        break;
      case 'warning':
        typeColor = Colors.orange;
        typeIcon = Icons.warning;
        typeDisplay = 'Warning';
        break;
      case 'info':
        typeColor = Colors.blue;
        typeIcon = Icons.info;
        typeDisplay = 'Info';
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.notifications;
        typeDisplay = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  notification['createdAt']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          // Type
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: typeColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(typeIcon, color: typeColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      typeDisplay,
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: notification['status'] == 'Active' ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  notification['status']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Sent To
          Expanded(
            flex: 2,
            child: Text(
              notification['sentTo']!,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          // Actions
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _editNotification(notification),
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                  tooltip: 'Edit Alert',
                ),
                IconButton(
                  onPressed: () => _toggleNotificationStatus(notification['id']!),
                  icon: Icon(
                    notification['status'] == 'Active' ? Icons.pause : Icons.play_arrow,
                    color: notification['status'] == 'Active' ? Colors.orange : Colors.green,
                    size: 18,
                  ),
                  tooltip: notification['status'] == 'Active' ? 'Deactivate' : 'Activate',
                ),
                IconButton(
                  onPressed: () => _deleteNotification(notification),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                  tooltip: 'Delete Alert',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CRUD methods for notifications
  void _showAddNotificationDialog() {
    _clearAlertForm();
    _editingNotificationId = null;
  }

  void _editNotification(Map<String, String> notification) {
    setState(() {
      _editingNotificationId = notification['id'];
      _selectedAlertType = notification['type'];
      _alertTitleController.text = notification['title']!;
      _alertMessageController.text = notification['message']!;
    });
  }

  void _updateNotification() {
    String? errorMessage = _validateNotificationForm();
    
    if (errorMessage != null) {
      _showErrorSnackbar(errorMessage);
      return;
    }

    setState(() {
      final notificationIndex = _notifications.indexWhere((n) => n['id'] == _editingNotificationId);
      if (notificationIndex != -1) {
        _notifications[notificationIndex] = {
          'id': _editingNotificationId!,
          'title': _alertTitleController.text.trim(),
          'message': _alertMessageController.text.trim(),
          'type': _selectedAlertType!,
          'status': _notifications[notificationIndex]['status']!, // Keep existing status
          'createdAt': _notifications[notificationIndex]['createdAt']!, // Keep original date
          'sentTo': _notifications[notificationIndex]['sentTo']!, // Keep existing count
        };
      }
    });

    _showSuccessSnackbar('Alert updated successfully! Changes will be reflected to mobile users.');
    _cancelEdit();
  }

  void _cancelEdit() {
    setState(() {
      _editingNotificationId = null;
    });
    _clearAlertForm();
  }

  void _toggleNotificationStatus(String notificationId) {
    setState(() {
      final notificationIndex = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (notificationIndex != -1) {
        final currentStatus = _notifications[notificationIndex]['status'];
        _notifications[notificationIndex]['status'] = currentStatus == 'Active' ? 'Inactive' : 'Active';
        
        final newStatus = _notifications[notificationIndex]['status'];
        final title = _notifications[notificationIndex]['title'];
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alert "$title" ${newStatus == 'Active' ? 'activated' : 'deactivated'} successfully'),
            backgroundColor: newStatus == 'Active' ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _deleteNotification(Map<String, String> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Alert'),
          content: Text('Are you sure you want to delete "${notification['title']}"?\n\nThis action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notifications.removeWhere((n) => n['id'] == notification['id']);
                });
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Alert "${notification['title']}" deleted successfully'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Update the existing validation method
  String? _validateNotificationForm() {
    if (_selectedAlertType == null || _selectedAlertType!.isEmpty) {
      return 'Please select an alert type.';
    }
    
    if (_alertTitleController.text.trim().isEmpty) {
      return 'Please enter an alert title.';
    }
    if (_alertTitleController.text.trim().length < 3) {
      return 'Alert title must be at least 3 characters long.';
    }
    if (_alertTitleController.text.trim().length > 100) {
      return 'Alert title cannot exceed 100 characters.';
    }
    
    if (_alertMessageController.text.trim().isEmpty) {
      return 'Please enter an alert message.';
    }
    if (_alertMessageController.text.trim().length < 10) {
      return 'Alert message must be at least 10 characters long.';
    }
    if (_alertMessageController.text.trim().length > 500) {
      return 'Alert message cannot exceed 500 characters.';
    }
    
    return null; // No errors
  }

  // Helper methods for showing messages
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildSettings() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double cardHeight = (constraints.maxHeight - 40) / 3; // 3 rows
                return Column(
                  children: [
                    // First row
                    SizedBox(
                      height: cardHeight,
                      child: Row(
                        children: [
                          Expanded(child: _buildSettingsCard('Emergency Contacts', Icons.contact_emergency, Colors.red)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildSettingsCard('System Backup', Icons.backup, Colors.green)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Second row
                    SizedBox(
                      height: cardHeight,
                      child: Row(
                        children: [
                          Expanded(child: _buildSettingsCard('Admin Permissions', Icons.admin_panel_settings, Colors.purple)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildSettingsCard('Mobile App Config', Icons.mobile_friendly, Colors.teal)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Third row
                    SizedBox(
                      height: cardHeight,
                      child: Row(
                        children: [
                          Expanded(child: _buildSettingsCard('Network Settings', Icons.network_check, Colors.indigo)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildSettingsCard('Security Settings', Icons.security, Colors.deepOrange)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(String title, IconData icon, Color color) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _handleSettingAction(title),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Configure', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _handleSettingAction(String settingTitle) {
    switch (settingTitle) {
      case 'User Management':
        setState(() {
          _selectedIndex = 1; // Navigate to User Management
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigated to User Management section')),
        );
        break;
      
      case 'Emergency Contacts':
        _showEmergencyContactsDialog();
        break;
      
      case 'Alert Templates':
        _showAlertTemplatesDialog();
        break;
      
      case 'System Backup':
        _showBackupDialog();
        break;
      
      case 'Admin Permissions':
        _showAdminPermissionsDialog();
        break;
      
      case 'Mobile App Config':
        _showMobileAppConfigDialog();
        break;
      
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$settingTitle configuration opened')),
        );
    }
  }

  void _showEmergencyContactsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.contact_emergency, color: Colors.red),
              SizedBox(width: 8),
              Text('Emergency Contacts'),
            ],
          ),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Manage emergency response team contacts and hotlines',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildContactItem('CDRRMO Hotline', '09171234567', 'Primary'),
                      _buildContactItem('Fire Department', '09987654321', 'Emergency'),
                      _buildContactItem('Police Station', '09456789123', 'Security'),
                      _buildContactItem('Medical Response', '09321654987', 'Health'),
                      _buildContactItem('Evacuation Team', '09876543210', 'Rescue'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Emergency contacts updated!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactItem(String name, String number, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            type == 'Primary' ? Icons.star : 
            type == 'Emergency' ? Icons.local_fire_department :
            type == 'Security' ? Icons.local_police :
            type == 'Health' ? Icons.local_hospital : Icons.group,
            color: Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(number, style: const TextStyle(color: Colors.grey)),
                Text(type, style: const TextStyle(fontSize: 12, color: Colors.red)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: 'Edit Contact',
          ),
        ],
      ),
    );
  }

  void _showAlertTemplatesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit_notifications, color: Colors.orange),
              SizedBox(width: 8),
              Text('Alert Templates'),
            ],
          ),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pre-configured alert templates for quick emergency notifications',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTemplateItem('Flood Warning', 'Weather Alert', 'Emergency'),
                      _buildTemplateItem('Earthquake Alert', 'Natural Disaster', 'Critical'),
                      _buildTemplateItem('Fire Emergency', 'Fire Incident', 'Emergency'),
                      _buildTemplateItem('Evacuation Notice', 'Safety Protocol', 'Warning'),
                      _buildTemplateItem('Weather Update', 'General Info', 'Information'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 2; // Navigate to notifications
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create New Alert'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTemplateItem(String title, String category, String priority) {
    Color priorityColor = priority == 'Critical' ? Colors.red : 
                          priority == 'Emergency' ? Colors.orange : 
                          priority == 'Warning' ? Colors.amber : Colors.blue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.announcement, color: priorityColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(category, style: const TextStyle(color: Colors.grey)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(color: priorityColor, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: 'Edit Template',
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.backup, color: Colors.green),
              SizedBox(width: 8),
              Text('System Backup'),
            ],
          ),
          content: const SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.cloud_upload, color: Colors.green),
                  title: Text('Automatic Backup'),
                  subtitle: Text('Last backup: Today at 3:00 AM'),
                  trailing: Switch(value: true, onChanged: null),
                ),
                ListTile(
                  leading: Icon(Icons.schedule, color: Colors.blue),
                  title: Text('Backup Schedule'),
                  subtitle: Text('Daily at 3:00 AM'),
                ),
                ListTile(
                  leading: Icon(Icons.storage, color: Colors.orange),
                  title: Text('Storage Usage'),
                  subtitle: Text('2.4 GB of 50 GB used'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Manual backup initiated!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Backup Now'),
            ),
          ],
        );
      },
    );
  }

  void _showAdminPermissionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.admin_panel_settings, color: Colors.purple),
              SizedBox(width: 8),
              Text('Admin Permissions'),
            ],
          ),
          content: const SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.people, color: Colors.blue),
                  title: Text('User Management'),
                  subtitle: Text('Full access to user CRUD operations'),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
                ListTile(
                  leading: Icon(Icons.emergency, color: Colors.red),
                  title: Text('Emergency Alerts'),
                  subtitle: Text('Authority to send emergency notifications'),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey),
                  title: Text('System Configuration'),
                  subtitle: Text('Modify system settings and preferences'),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
                ListTile(
                  leading: Icon(Icons.analytics, color: Colors.orange),
                  title: Text('Reports & Analytics'),
                  subtitle: Text('Access to system reports and logs'),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showMobileAppConfigDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.mobile_friendly, color: Colors.teal),
              SizedBox(width: 8),
              Text('Mobile App Configuration'),
            ],
          ),
          content: const SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.notification_important, color: Colors.orange),
                  title: Text('Push Notifications'),
                  subtitle: Text('Enable mobile app notifications'),
                  trailing: Switch(value: true, onChanged: null),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.red),
                  title: Text('Location Services'),
                  subtitle: Text('Track user locations for emergency response'),
                  trailing: Switch(value: true, onChanged: null),
                ),
                ListTile(
                  leading: Icon(Icons.update, color: Colors.blue),
                  title: Text('App Version'),
                  subtitle: Text('Current: v2.1.0 (Latest)'),
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.green),
                  title: Text('Active Users'),
                  subtitle: Text('1,247 mobile app users registered'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mobile app settings updated!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build larger status items for dashboard
  Widget _buildLargerStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Modal methods for dashboard quick access
  void _showUsersModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registered Users'),
          content: SizedBox(
            width: 400,
            height: 300,
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF2d5f3f),
                    child: Text(user['name']![0], style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(user['name']!),
                  subtitle: Text('${user['role']} - ${user['contact']}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: user['status'] == 'Active' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user['status']!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 1; // Navigate to User Management
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2d5f3f),
                foregroundColor: Colors.white,
              ),
              child: const Text('Manage Users'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyContactsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Contacts'),
          content: SizedBox(
            width: 400,
            height: 300,
            child: ListView.builder(
              itemCount: _emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = _emergencyContacts[index];
                return ListTile(
                  leading: const Icon(Icons.phone, color: Colors.red),
                  title: Text(contact['name']!),
                  subtitle: Text(contact['number']!),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      contact['type']!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 3; // Navigate to Settings
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Manage Contacts'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Active Alerts'),
          content: const SizedBox(
            width: 400,
            height: 200,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.warning, color: Colors.orange),
                  title: Text('Weather Advisory'),
                  subtitle: Text('Heavy rainfall expected'),
                  trailing: Text('2 hrs ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                ListTile(
                  leading: Icon(Icons.error, color: Colors.red),
                  title: Text('Road Closure'),
                  subtitle: Text('Highway 1 temporarily closed'),
                  trailing: Text('1 day ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.blue),
                  title: Text('Maintenance Notice'),
                  subtitle: Text('System maintenance scheduled'),
                  trailing: Text('3 hrs ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 2; // Navigate to Notifications
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Send Alert'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyTeamsModal() {
    final emergencyResponders = _users.where((user) => user['role'] == 'Emergency Responder').toList();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Response Teams'),
          content: SizedBox(
            width: 400,
            height: 300,
            child: emergencyResponders.isEmpty
                ? const Center(
                    child: Text(
                      'No emergency responders registered',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: emergencyResponders.length,
                    itemBuilder: (context, index) {
                      final responder = emergencyResponders[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.security, color: Colors.white),
                        ),
                        title: Text(responder['name']!),
                        subtitle: Text(responder['contact']!),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: responder['status'] == 'Active' ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            responder['status']!,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 1; // Navigate to User Management
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Manage Teams'),
            ),
          ],
        );
      },
    );
  }
}
