import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

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
  List<Map<String, String>> _users = [
    {'id': '1', 'name': 'John Doe', 'contact': '09123456789', 'role': 'Emergency Responder', 'status': 'Active'},
    {'id': '2', 'name': 'Jane Smith', 'contact': '09987654321', 'role': 'Community Leader', 'status': 'Active'},
    {'id': '3', 'name': 'Mike Johnson', 'contact': '09456789123', 'role': 'Volunteer', 'status': 'Inactive'},
    {'id': '4', 'name': 'Sarah Wilson', 'contact': '09321654987', 'role': 'Emergency Responder', 'status': 'Active'},
    {'id': '5', 'name': 'David Brown', 'contact': '09876543210', 'role': 'Community Leader', 'status': 'Active'},
  ];

  // Controllers for user form
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  String _selectedRole = 'Volunteer';
  String _selectedStatus = 'Active';
  String? _editingUserId;

  // Emergency Contacts CRUD State - For Mobile App Display
  List<Map<String, String>> _emergencyContacts = [
    {'id': '1', 'name': 'San Pedro CDRRMO Hotline', 'number': '09171234567', 'type': 'Primary'},
    {'id': '2', 'name': 'Fire Department', 'number': '09987654321', 'type': 'Emergency'},
    {'id': '3', 'name': 'Police Station', 'number': '09456789123', 'type': 'Security'},
    {'id': '4', 'name': 'Medical Response Team', 'number': '09321654987', 'type': 'Health'},
    {'id': '5', 'name': 'Rescue Team', 'number': '09876543210', 'type': 'Rescue'},
  ];

  // Controllers for emergency contact form
  final _hotlineNameController = TextEditingController();
  final _hotlineNumberController = TextEditingController();
  String _selectedContactType = 'Primary';
  String? _editingContactId;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _hotlineNameController.dispose();
    _hotlineNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2d5f3f),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Text(_titles[_selectedIndex]),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'ADMIN PANEL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
        return _buildSystemLogs();
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
            // Welcome Header - Fixed height
            Container(
              height: 120,
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
              child: const Row(
                children: [
                  Icon(Icons.shield, size: 50, color: Color(0xFF2d5f3f)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CDRRMO Admin Dashboard',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2d5f3f),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Disaster Risk Reduction & Management Office',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Quick Access Section
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2d5f3f),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Add User',
                          Icons.person_add,
                          Colors.blue,
                          () => _quickAddUser(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Approve Users',
                          Icons.verified_user,
                          Colors.green,
                          () => _quickApproveUsers(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Send Alert',
                          Icons.emergency,
                          Colors.red,
                          () => _quickSendAlert(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Stats Cards - Fixed proportions
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double cardHeight = (constraints.maxHeight - 40) / 2; // Account for more spacing
                  return Column(
                    children: [
                      // First row of cards
                      SizedBox(
                        height: cardHeight,
                        child: Row(
                          children: [
                            Expanded(child: _buildStatsCard('Total Users', '1,247', Icons.people, Colors.blue)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStatsCard('Active Alerts', '12', Icons.warning, Colors.orange)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Second row of cards
                      SizedBox(
                        height: cardHeight,
                        child: Row(
                          children: [
                            Expanded(child: _buildStatsCard('System Status', 'Online', Icons.check_circle, Colors.green)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStatsCard('Reports Today', '34', Icons.report, Colors.purple)),
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
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
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
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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

  void _quickApproveUsers() {
    // Show pending users for approval
    _showPendingUsersDialog();
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

  void _showPendingUsersDialog() {
    // Create a local list to manage pending users that can be modified
    List<Map<String, String>> pendingUsers = [
      {'id': '1', 'name': 'Alex Rodriguez', 'contact': '09567890123', 'role': 'Volunteer'},
      {'id': '2', 'name': 'Maria Santos', 'contact': '09876543210', 'role': 'Community Leader'},
      {'id': '3', 'name': 'Carlos Mendoza', 'contact': '09456789012', 'role': 'Emergency Responder'},
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pending_actions, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Pending User Approvals'),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${pendingUsers.length} pending',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                              'Review and approve new mobile app user registrations',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: pendingUsers.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                                  SizedBox(height: 16),
                                  Text(
                                    'No pending approvals',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'All user registrations have been processed',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: pendingUsers.length,
                              itemBuilder: (context, index) {
                                final user = pendingUsers[index];
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey.withValues(alpha: 0.3),
                                        child: Text(user['name']![0]),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user['name']!,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              user['contact']!,
                                              style: const TextStyle(color: Colors.grey, fontFamily: 'monospace'),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                user['role']!,
                                                style: const TextStyle(fontSize: 12, color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Approve user - add to main users list and remove from pending
                                              _approveUser(user);
                                              setDialogState(() {
                                                pendingUsers.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                                            tooltip: 'Approve User',
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // Reject user - just remove from pending list
                                              setDialogState(() {
                                                pendingUsers.removeAt(index);
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('${user['name']} registration rejected')),
                                              );
                                            },
                                            icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
                                            tooltip: 'Reject User',
                                          ),
                                        ],
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                if (pendingUsers.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      // Approve all pending users
                      for (var user in List.from(pendingUsers)) {
                        _approveUser(user);
                      }
                      setDialogState(() {
                        pendingUsers.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All pending users approved successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2d5f3f),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Approve All'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // Add this method to handle user approval
  void _approveUser(Map<String, String> pendingUser) {
    setState(() {
      // Add to main users list with Active status
      final newId = (_users.length + 1).toString();
      _users.add({
        'id': newId,
        'name': pendingUser['name']!,
        'contact': pendingUser['contact']!,
        'role': pendingUser['role']!,
        'status': 'Active',
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pendingUser['name']} approved and added to mobile users!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildUserManagement() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Add User Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mobile App Users Management',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddUserDialog,
                icon: const Icon(Icons.person_add),
                label: const Text('Add Mobile User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2d5f3f),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
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
                        Expanded(child: Text('Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  // User Rows
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return _buildUserRow(user);
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

  Widget _buildUserRow(Map<String, String> user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
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
                Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(user['contact']!, style: const TextStyle(fontSize: 12, fontFamily: 'monospace'))),
          Expanded(child: Text(user['role']!)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user['status'] == 'Active' ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user['status']!,
                style: TextStyle(
                  color: user['status'] == 'Active' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
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
    _nameController.text = user['name']!;
    _contactController.text = user['contact']!;
    _selectedRole = user['role']!;
    _selectedStatus = user['status']!;
    _editingUserId = user['id'];
    _showUserDialog('Edit Mobile User');
  }

  void _showUserDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number (09XXXXXXXXX)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        hintText: '09123456789',
                        helperText: 'Must start with 09 and be 11 digits total',
                      ),
                      onChanged: (value) {
                        // Real-time validation feedback
                        if (value.isNotEmpty && (!value.startsWith('09') || value.length != 11)) {
                          // You can add visual feedback here if needed
                        }
                      },
                    ),
                    const SizedBox(height: 16),
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
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.toggle_on),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Active', child: Text('Active')),
                        DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveUser();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2d5f3f),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_editingUserId == null ? 'Add Mobile User' : 'Update Mobile User'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveUser() {
    // Validation
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    if (_contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a contact number')),
      );
      return;
    }

    // Contact number validation: must start with 09 and be exactly 11 digits
    if (!_contactController.text.startsWith('09')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact number must start with 09')),
      );
      return;
    }

    if (_contactController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact number must be exactly 11 digits')),
      );
      return;
    }

    // Check if contact number contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(_contactController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact number must contain only numbers')),
      );
      return;
    }

    // Check for duplicate contact numbers (except when editing the same user)
    bool isDuplicate = _users.any((user) => 
      user['contact'] == _contactController.text && 
      user['id'] != _editingUserId
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This contact number is already registered')),
      );
      return;
    }

    setState(() {
      if (_editingUserId == null) {
        // Add new user
        final newId = (_users.length + 1).toString();
        _users.add({
          'id': newId,
          'name': _nameController.text,
          'contact': _contactController.text,
          'role': _selectedRole,
          'status': _selectedStatus,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mobile user added successfully!')),
        );
      } else {
        // Update existing user
        final userIndex = _users.indexWhere((user) => user['id'] == _editingUserId);
        if (userIndex != -1) {
          _users[userIndex] = {
            'id': _editingUserId!,
            'name': _nameController.text,
            'contact': _contactController.text,
            'role': _selectedRole,
            'status': _selectedStatus,
          };
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mobile user updated successfully!')),
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
    _contactController.clear();
    _selectedRole = 'Volunteer';
    _selectedStatus = 'Active';
  }

  Widget _buildNotifications() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Post Emergency Notifications',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                        const Text(
                          'Create New Alert',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        
                        // Alert Type
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Alert Type',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'emergency', child: Text('Emergency Alert')),
                            DropdownMenuItem(value: 'warning', child: Text('Warning')),
                            DropdownMenuItem(value: 'info', child: Text('Information')),
                          ],
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),
                        
                        // Title
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Alert Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Message
                        const Expanded(
                          child: TextField(
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              labelText: 'Alert Message',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Send Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Alert sent to mobile app user successfully!')),
                              );
                            },
                            icon: const Icon(Icons.send),
                            label: const Text('Send Alert'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Recent Alerts
                Expanded(
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
                        const Text(
                          'Recent Alerts',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildAlertItem('Flood Warning', 'Emergency', '2 hours ago'),
                              _buildAlertItem('Road Closure', 'Warning', '5 hours ago'),
                              _buildAlertItem('Weather Update', 'Information', '1 day ago'),
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
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: TextStyle(color: typeColor, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
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

  Widget _buildSystemLogs() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'System Activity Logs',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logs exported successfully!')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Export Logs'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2d5f3f),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
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
                        Expanded(child: Text('Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(child: Text('User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  // Log Entries
                  Expanded(
                    child: ListView(
                      children: [
                        _buildLogRow('14:30:25', 'admin', 'User login attempt', 'Success'),
                        _buildLogRow('14:28:12', 'john.doe', 'Emergency alert sent', 'Success'),
                        _buildLogRow('14:25:45', 'jane.smith', 'User profile updated', 'Success'),
                        _buildLogRow('14:22:33', 'system', 'Backup completed', 'Success'),
                        _buildLogRow('14:20:18', 'mike.johnson', 'Failed login attempt', 'Failed'),
                        _buildLogRow('14:15:07', 'admin', 'System settings changed', 'Success'),
                        _buildLogRow('14:10:44', 'sarah.wilson', 'Report generated', 'Success'),
                        _buildLogRow('14:05:22', 'system', 'Automatic data cleanup', 'Success'),
                      ],
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

  Widget _buildLogRow(String time, String user, String action, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(time, style: const TextStyle(fontFamily: 'monospace'))),
          Expanded(child: Text(user, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Text(action)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == 'Success' ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: status == 'Success' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
