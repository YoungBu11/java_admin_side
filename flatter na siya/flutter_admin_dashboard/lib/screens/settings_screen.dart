import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkModeEnabled = false;
  bool emailNotifications = true;
  bool smsNotifications = false;
  
  List<Map<String, String>> emergencyHotlines = [];

  final _hotlineNameController = TextEditingController();
  final _hotlineNumberController = TextEditingController();

  @override
  void dispose() {
    _hotlineNameController.dispose();
    _hotlineNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admin Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF13b464),
            ),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView(
              children: [
                // Dark Mode Setting
                _buildSettingsCard(
                  title: 'Display Settings',
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Dark Mode'),
                      value: darkModeEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          darkModeEnabled = value;
                        });
                      },
                      activeColor: const Color(0xFF13b464),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Password Change
                _buildSettingsCard(
                  title: 'Change Password',
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password updated successfully!'),
                            backgroundColor: Color(0xFF13b464),
                          ),
                        );
                      },
                      child: const Text('Update Password'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Notification Preferences
                _buildSettingsCard(
                  title: 'Notification Preferences',
                  children: [
                    SwitchListTile(
                      title: const Text('Email Notifications'),
                      value: emailNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          emailNotifications = value;
                        });
                      },
                      activeColor: const Color(0xFF13b464),
                    ),
                    SwitchListTile(
                      title: const Text('SMS Notifications'),
                      value: smsNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          smsNotifications = value;
                        });
                      },
                      activeColor: const Color(0xFF13b464),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Emergency Hotlines
                _buildSettingsCard(
                  title: 'Emergency Hotlines',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _hotlineNameController,
                            decoration: const InputDecoration(
                              labelText: 'Hotline Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _hotlineNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Hotline Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _addHotline,
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Hotlines Table
                    if (emergencyHotlines.isNotEmpty) ...[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFb6fcd5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFb6fcd5),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(flex: 2, child: Text('Number', style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(flex: 1, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                            // Table Content
                            ...emergencyHotlines.asMap().entries.map((entry) {
                              final index = entry.key;
                              final hotline = entry.value;
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: index < emergencyHotlines.length - 1
                                      ? const BorderSide(color: Color(0xFFb6fcd5))
                                      : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(hotline['name']!)),
                                    Expanded(flex: 2, child: Text(hotline['number']!)),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => _editHotline(index),
                                            icon: const Icon(Icons.edit, color: Color(0xFF13b464)),
                                            tooltip: 'Edit',
                                          ),
                                          IconButton(
                                            onPressed: () => _deleteHotline(index),
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            tooltip: 'Delete',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'No emergency hotlines added yet',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Profile Information
                _buildSettingsCard(
                  title: 'Profile Information',
                  children: [
                    _buildProfileItem('Admin:', 'CDRRMO'),
                    _buildProfileItem('Email:', 'admin@cdrrmo.gov'),
                    _buildProfileItem('Role:', 'Super Admin'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13b464),
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF13b464),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _addHotline() {
    final name = _hotlineNameController.text.trim();
    final number = _hotlineNumberController.text.trim();

    if (name.isNotEmpty && number.isNotEmpty) {
      setState(() {
        emergencyHotlines.add({
          'name': name,
          'number': number,
        });
      });

      _hotlineNameController.clear();
      _hotlineNumberController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hotline added successfully!'),
          backgroundColor: Color(0xFF13b464),
        ),
      );
    }
  }

  void _editHotline(int index) {
    final hotline = emergencyHotlines[index];
    final nameController = TextEditingController(text: hotline['name']);
    final numberController = TextEditingController(text: hotline['number']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Hotline'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Hotline Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Hotline Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final number = numberController.text.trim();

              if (name.isNotEmpty && number.isNotEmpty) {
                setState(() {
                  emergencyHotlines[index] = {
                    'name': name,
                    'number': number,
                  };
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hotline updated successfully!'),
                    backgroundColor: Color(0xFF13b464),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteHotline(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hotline'),
        content: Text('Are you sure you want to delete ${emergencyHotlines[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                emergencyHotlines.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hotline deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
