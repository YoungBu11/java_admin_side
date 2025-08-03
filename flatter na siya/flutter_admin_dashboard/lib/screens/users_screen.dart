import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Map<String, dynamic>> users = [
    {'id': '001', 'name': 'Jane Doe', 'number': '09171234567', 'status': 'Active'},
    {'id': '002', 'name': 'John Smith', 'number': '09981234567', 'status': 'Inactive'},
    {'id': '003', 'name': 'Mary Lee', 'number': '09181234567', 'status': 'Active'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'User Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF13b464),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(),
                icon: const Icon(Icons.person_add),
                label: const Text('Add User'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
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
                          Expanded(flex: 1, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text('Number', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    
                    // Table Content
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
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
                                Expanded(flex: 1, child: Text(user['id'])),
                                Expanded(flex: 3, child: Text(user['name'])),
                                Expanded(flex: 3, child: Text(user['number'])),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: user['status'] == 'Active' 
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      user['status'],
                                      style: TextStyle(
                                        color: user['status'] == 'Active' 
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _showEditUserDialog(user, index),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF13b464),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        ),
                                        child: const Text('Edit', style: TextStyle(fontSize: 12)),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () => _deleteUser(index),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        ),
                                        child: const Text('Delete', style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
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
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    String status = 'Active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Active', 'Inactive'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
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
              if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                _addUser(nameController.text, numberController.text, status);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user, int index) {
    final nameController = TextEditingController(text: user['name']);
    final numberController = TextEditingController(text: user['number']);
    String status = user['status'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Active', 'Inactive'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
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
              if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                _editUser(index, nameController.text, numberController.text, status);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addUser(String name, String number, String status) {
    setState(() {
      final newId = (users.length + 1).toString().padLeft(3, '0');
      users.add({
        'id': newId,
        'name': name,
        'number': number,
        'status': status,
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User added successfully!'),
        backgroundColor: Color(0xFF13b464),
      ),
    );
  }

  void _editUser(int index, String name, String number, String status) {
    setState(() {
      users[index]['name'] = name;
      users[index]['number'] = number;
      users[index]['status'] = status;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User updated successfully!'),
        backgroundColor: Color(0xFF13b464),
      ),
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${users[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                users.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User deleted successfully!'),
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
