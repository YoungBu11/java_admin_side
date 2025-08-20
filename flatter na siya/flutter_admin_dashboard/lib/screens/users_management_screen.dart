import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/admin_drawer.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Removed duplicate build method. Only the latest build method with sidebar/drawer and AppBar remains.
  // --- User Management Helper Methods (from dashboard_screen.dart) ---
  void _applyFiltersAndSorting() {
    List<Map<String, String>> filtered = List.from(_users);
    if (_userSearchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user['name']!.toLowerCase().contains(
              _userSearchQuery.toLowerCase(),
            ) ||
            user['contact']!.toLowerCase().contains(
              _userSearchQuery.toLowerCase(),
            ) ||
            user['address']!.toLowerCase().contains(
              _userSearchQuery.toLowerCase(),
            );
      }).toList();
    }
    // Only filter by role once, using _selectedRoleFilter
    if (_selectedRoleFilter != 'All') {
      filtered = filtered.where((user) => user['role'] == _selectedRoleFilter).toList();
    }
    if (_selectedStatusFilter != 'All') {
      filtered = filtered
          .where((user) => user['status'] == _selectedStatusFilter)
          .toList();
    }
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
    setState(() {
      _filteredUsers = filtered;
    });
  }

  void _showAddUserDialog({String? preselectRole}) {
    _clearForm();
    _editingUserId = null;
    if (preselectRole != null) {
      // Support both 'Emergency Responder' and 'Emergency Responder' as preselectRole
      if (preselectRole == 'Emergency Responder' || preselectRole == 'Emergency Responder') {
        _selectedRole = 'Emergency Responder';
      } else {
        _selectedRole = preselectRole;
      }
    } else {
      _selectedRole = '';
    }
    _showUserDialog('Add Mobile User');
  }

  void _showEditUserDialog(Map<String, String> user) {
    _parseFullNameToFields(user['name']!);
    _contactController.text = user['contact']!;
    _addressController.text = user['address']!;
    _selectedRole = user['role']!;
    _editingUserId = user['id'];
    _showUserDialog('Edit Mobile User');
  }

  void _showUserDialog(String title) {
    // Add error state variables for each field
    String? firstNameError;
    String? lastNameError;
    String? middleNameError;
    String? suffixError;
    String? contactError;
    String? addressError;
    bool showAllErrors = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Helper to validate and set errors
            void validateFields() {
              setDialogState(() {
                firstNameError = null;
                lastNameError = null;
                middleNameError = null;
                suffixError = null;
                contactError = null;
                addressError = null;

                if (_firstNameController.text.trim().isEmpty) {
                  firstNameError = 'First Name is required';
                } else if (!_isValidName(_firstNameController.text.trim())) {
                  firstNameError =
                      'Only letters, spaces, dashes, and Ñ are allowed';
                }
                if (_lastNameController.text.trim().isEmpty) {
                  lastNameError = 'Last Name is required';
                } else if (!_isValidName(_lastNameController.text.trim())) {
                  lastNameError =
                      'Only letters, spaces, dashes, and Ñ are allowed';
                }
                if (_middleNameController.text.trim().isNotEmpty &&
                    !_isValidName(_middleNameController.text.trim())) {
                  middleNameError =
                      'Only letters, spaces, dashes, and Ñ are allowed';
                }
                if (_suffixController.text.trim().isNotEmpty &&
                    !_isValidName(_suffixController.text.trim())) {
                  suffixError =
                      'Only letters, spaces, dashes, and Ñ are allowed';
                }
                if (_contactController.text.trim().isEmpty) {
                  contactError = 'Contact Number is required';
                } else if (!_contactController.text.startsWith('09')) {
                  contactError = 'Must start with 09 (e.g., 09123456789)';
                } else if (_contactController.text.length != 11) {
                  contactError = 'Must be exactly 11 digits';
                } else if (!RegExp(
                  r'^[0-9]+$',
                ).hasMatch(_contactController.text)) {
                  contactError = 'Must contain only numbers';
                } else if (_users.any(
                  (user) =>
                      user['contact'] == _contactController.text &&
                      user['id'] != _editingUserId,
                )) {
                  contactError = 'This mobile number is already registered';
                }
                if (_addressController.text.trim().isEmpty) {
                  addressError = 'Complete Address is required';
                } else if (_addressController.text.trim().length < 10) {
                  addressError =
                      'Please provide a complete address (min 10 chars)';
                }
              });
            }

            void showAllFieldErrors() {
              setDialogState(() {
                showAllErrors = true;
              });
              validateFields();
            }

            // Trigger validation immediately when the dialog is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              validateFields();
            });

            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 600,
                height: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _firstNameController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: InputDecoration(
                                labelText: 'First Name *',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.person),
                                errorText:
                                    (showAllErrors ||
                                        _firstNameController.text.isNotEmpty)
                                    ? firstNameError
                                    : null,
                              ),
                              onChanged: (_) => validateFields(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _lastNameController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: InputDecoration(
                                labelText: 'Last Name *',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.person_outline),
                                errorText:
                                    (showAllErrors ||
                                        _lastNameController.text.isNotEmpty)
                                    ? lastNameError
                                    : null,
                              ),
                              onChanged: (_) => validateFields(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _middleNameController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: InputDecoration(
                                labelText: 'Middle Name (Optional)',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.person_2),
                                errorText:
                                    (showAllErrors ||
                                        _middleNameController.text.isNotEmpty)
                                    ? middleNameError
                                    : null,
                              ),
                              onChanged: (_) => validateFields(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _suffixController,
                              inputFormatters: [_nameInputFormatter],
                              decoration: InputDecoration(
                                labelText: 'Suffix (Optional)',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.text_fields),
                                hintText: 'Jr., Sr., III, etc.',
                                errorText:
                                    (showAllErrors ||
                                        _suffixController.text.isNotEmpty)
                                    ? suffixError
                                    : null,
                              ),
                              onChanged: (_) => validateFields(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        decoration: InputDecoration(
                          labelText: 'Contact Number (09XXXXXXXXX) *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.phone),
                          hintText: 'Enter 11-digit mobile number',
                          helperText:
                              'Must start with 09 and be 11 digits total',
                          errorText:
                              (showAllErrors ||
                                  _contactController.text.isNotEmpty)
                              ? contactError
                              : null,
                          counterText: '',
                        ),
                        onChanged: (_) => validateFields(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Complete Address *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.location_on),
                          hintText: 'Block/Lot, Street, Barangay, San Pedro',
                          helperText:
                              'Include complete address for emergency response',
                          errorText:
                              (showAllErrors ||
                                  _addressController.text.isNotEmpty)
                              ? addressError
                              : null,
                        ),
                        onChanged: (_) => validateFields(),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: (['Emergency Responder', 'Community Leader', 'Users'].contains(_selectedRole)) ? _selectedRole : null,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.work),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Emergency Responder',
                            child: Text('Emergency Responder'),
                          ),
                          DropdownMenuItem(
                            value: 'Community Leader',
                            child: Text('Community Leader'),
                          ),
                          DropdownMenuItem(
                            value: 'Users',
                            child: Text('Users'),
                          ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black87,
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
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            showAllFieldErrors();
                            _validateAndSaveUser(context, setDialogState);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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

  void _validateAndSaveUser(
    BuildContext dialogContext,
    StateSetter setDialogState,
  ) {
    String? errorMessage;
    if (_firstNameController.text.trim().isEmpty) {
      errorMessage =
          '❌ First Name is required - Please enter the user\'s first name';
    } else if (!_isValidName(_firstNameController.text.trim())) {
      errorMessage =
          '❌ Invalid First Name - Only letters, spaces, dashes, and Ñ are allowed';
    } else if (_lastNameController.text.trim().isEmpty) {
      errorMessage =
          '❌ Last Name is required - Please enter the user\'s last name';
    } else if (!_isValidName(_lastNameController.text.trim())) {
      errorMessage =
          '❌ Invalid Last Name - Only letters, spaces, dashes, and Ñ are allowed';
    } else if (_middleNameController.text.trim().isNotEmpty &&
        !_isValidName(_middleNameController.text.trim())) {
      errorMessage =
          '❌ Invalid Middle Name - Only letters, spaces, dashes, and Ñ are allowed';
    } else if (_suffixController.text.trim().isNotEmpty &&
        !_isValidName(_suffixController.text.trim())) {
      errorMessage =
          '❌ Invalid Suffix - Only letters, spaces, dashes, and Ñ are allowed';
    } else if (_contactController.text.trim().isEmpty) {
      errorMessage =
          '❌ Contact Number is required - Please enter a valid mobile number';
    } else if (!_contactController.text.startsWith('09')) {
      errorMessage =
          '❌ Invalid Contact Number - Must start with 09 (e.g., 09123456789)';
    } else if (_contactController.text.length != 11) {
      errorMessage =
          '❌ Invalid Contact Number - Must be exactly 11 digits (09XXXXXXXXX)';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(_contactController.text)) {
      errorMessage = '❌ Invalid Contact Number - Must contain only numbers';
    } else if (_addressController.text.trim().isEmpty) {
      errorMessage =
          '❌ Complete Address is required - Please enter the user\'s full address';
    } else if (_addressController.text.trim().length < 10) {
      errorMessage =
          '❌ Incomplete Address - Please provide a complete address (minimum 10 characters)';
    } else if (_users.any(
      (user) =>
          user['contact'] == _contactController.text &&
          user['id'] != _editingUserId,
    )) {
      errorMessage =
          '❌ Duplicate Contact Number - This mobile number is already registered in the system';
    }
    if (errorMessage != null) {
      // Error states are now shown inline in the form fields, no need for SnackBar.
      return;
    }
    _saveValidatedUser();
    Navigator.of(dialogContext).pop();
  }

  void _saveValidatedUser() {
    String fullName = _constructFullName();
    setState(() {
      if (_editingUserId == null) {
        final newId = (_users.length + 1).toString();
        _users.add({
          'id': newId,
          'name': fullName,
          'contact': _contactController.text,
          'address': _addressController.text,
          'role': _selectedRole,
          'status': 'Active',
        });
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
        final userIndex = _users.indexWhere(
          (user) => user['id'] == _editingUserId,
        );
        if (userIndex != -1) {
          _users[userIndex] = {
            'id': _editingUserId!,
            'name': fullName,
            'contact': _contactController.text,
            'address': _addressController.text,
            'role': _selectedRole,
            'status': _users[userIndex]['status']!,
          };
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
    _applyFiltersAndSorting(); // <-- Ensure table updates after add/edit
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
    _applyFiltersAndSorting(); // <-- Ensure table updates after delete
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
    _selectedRole = 'Emergency Responder';
  }

  void _parseFullNameToFields(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.isNotEmpty) {
      _firstNameController.text = nameParts[0];
      if (nameParts.length >= 2) {
        _lastNameController.text = nameParts.last;
        String lastPart = nameParts.last.toLowerCase();
        if (lastPart == 'jr.' ||
            lastPart == 'jr' ||
            lastPart == 'sr.' ||
            lastPart == 'sr' ||
            lastPart == 'iii' ||
            lastPart == 'iv' ||
            lastPart == 'ii' ||
            lastPart == 'v') {
          _suffixController.text = nameParts.last;
          if (nameParts.length >= 3) {
            _lastNameController.text = nameParts[nameParts.length - 2];
          }
        }
        if (nameParts.length >= 3 && _suffixController.text.isEmpty) {
          _middleNameController.text = nameParts
              .sublist(1, nameParts.length - 1)
              .join(' ');
        } else if (nameParts.length >= 4) {
          _middleNameController.text = nameParts
              .sublist(1, nameParts.length - 2)
              .join(' ');
        }
      }
    }
  }

  String _constructFullName() {
    List<String> nameParts = [];
    nameParts.add(_firstNameController.text.trim());
    if (_middleNameController.text.trim().isNotEmpty) {
      nameParts.add(_middleNameController.text.trim());
    }
    nameParts.add(_lastNameController.text.trim());
    if (_suffixController.text.trim().isNotEmpty) {
      nameParts.add(_suffixController.text.trim());
    }
    return nameParts.join(' ');
  }

  bool _isValidName(String name) {
    final namePattern = RegExp(r'^[a-zA-ZñÑ\s\-]+$');
    return namePattern.hasMatch(name.trim()) && name.trim().isNotEmpty;
  }

  TextInputFormatter get _nameInputFormatter {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZñÑ\s\-]'));
  }

  void _exportUsers(String format) {
    String message;
    switch (format) {
      case 'xlsx':
        message = 'Users exported as XLSX file successfully!';
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
              format == 'xlsx'
                  ? Icons.table_chart
                  : format == 'pdf'
                  ? Icons.picture_as_pdf
                  : Icons.code,
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

  // User Management CRUD State - Mobile Users Only
  final List<Map<String, String>> _users = [
    {
      'id': '1',
      'name': 'John Doe',
      'contact': '09123456789',
      'address': 'Block 1 Lot 5, San Antonio Village, San Pedro',
      'role': 'Emergency Responder',
      'status': 'Active',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'contact': '09987654321',
      'address': 'Unit 205, Greenfield Heights, San Pedro',
      'role': 'Community Leader',
      'status': 'Active',
    },
    {
      'id': '4',
      'name': 'Sarah Wilson',
      'contact': '09321654987',
      'address': 'Block 8 Lot 12, Villa Maria Subdivision, San Pedro',
      'role': 'Emergency Responder',
      'status': 'Active',
    },
    {
      'id': '5',
      'name': 'David Brown',
      'contact': '09876543210',
      'address': '456 Rizal Avenue, San Pedro',
      'role': 'Community Leader',
      'status': 'Active',
    },
    {
      'id': '7',
      'name': 'Robert Martinez',
      'contact': '09345678901',
      'address': '789 Sampaguita Street, San Pedro',
      'role': 'Emergency Responder',
      'status': 'Active',
    },
    {
      'id': '8',
      'name': 'Lisa Anderson',
      'contact': '09567890123',
      'address': 'Unit 102, Pacific Plaza, San Pedro',
      'role': 'Community Leader',
      'status': 'Active',
    },
    {
      'id': '10',
      'name': 'Anna Torres',
      'contact': '09789012345',
      'address': '321 Mabini Street, San Pedro',
      'role': 'Emergency Responder',
      'status': 'Active',
    },
    {
      'id': '11',
      'name': 'James Wilson',
      'contact': '09890123456',
      'address': 'Block 7 Lot 20, New Manila Heights, San Pedro',
      'role': 'Community Leader',
      'status': 'Active',
    },
  ];

  // Controllers for user form
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedRole = '';
  String? _editingUserId;

  // Filter and Sort State Variables
  String _userSearchQuery = '';
  String _selectedRoleFilter = 'All';
  String _selectedStatusFilter = 'All';
  String _sortBy = 'name'; // name, contact, address, role
  bool _sortAscending = true;
  List<Map<String, String>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = List.from(_users);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        // Handle role filter for Emergency Responders
        if (args['filterRole'] != null && args['filterRole'] is String) {
          setState(() {
            _selectedRoleFilter = args['filterRole'];
            _applyFiltersAndSorting();
          });
        }
        // Show add user modal and preselect role if provided
        if (args['showAddUser'] == true) {
          final preselectRole = args['preselectRole'] is String
              ? args['preselectRole'] as String
              : null;
          _showAddUserDialog(preselectRole: preselectRole);
        }
      }
    });
  }
  bool _isSuperadmin = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (args['filterRole'] == 'Emergency Responder' || args['filterRole'] == 'Emergency Responder') {
        setState(() {
          _selectedRoleFilter = 'Emergency Responder';
        });
      }
      // Always set _isSuperadmin if role is superadmin
      _isSuperadmin = args['role'] == 'superadmin';
    }
    _applyFiltersAndSorting();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(
        selectedIndex: 1,
        role: _isSuperadmin ? 'superadmin' : null,
        onItemSelected: (index) {
          if (index == 1) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, _isSuperadmin ? '/superadmin-dashboard' : '/dashboard', arguments: _isSuperadmin ? {'role': 'superadmin'} : null);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, _isSuperadmin ? '/superadmin-notifications' : '/notifications', arguments: _isSuperadmin ? {'role': 'superadmin'} : null);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, _isSuperadmin ? '/superadmin-settings' : '/settings', arguments: _isSuperadmin ? {'role': 'superadmin'} : null);
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/system-logs', arguments: _isSuperadmin ? {'role': 'superadmin'} : null);
              break;
          }
        },
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: const Color(0xFF2d5f3f),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Centered Title with Icon
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_alt_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Mobile App Users Management',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu button (left)
              Positioned(
                left: 0,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              // Welcome text (right)
              const Positioned(
                right: 24,
                child: Text(
                  'Welcome, CDRRMO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mobile App Users Management',
                      style: TextStyle(
                        fontSize: 22, // Match dashboard font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2d5f3f),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keep your community organized and secure',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                // Export/Add buttons only (no Welcome pill)
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
                            value: 'xlsx',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.table_chart,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                SizedBox(width: 12),
                                Text('Export as XLSX'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'pdf',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 12),
                                Text('Export as PDF'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'xml',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.code,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                SizedBox(width: 12),
                                Text('Export as XML'),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Export Users',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                                size: 16,
                              ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2d5f3f),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF2d5f3f).withOpacity(0.3),
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 18,
                              ),
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
            const SizedBox(height: 24),
            // Search, filter, and sort row
            Row(
              children: [
                // Search
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search users by name, contact, or address...',
                      filled: true,
                      fillColor: Colors.green[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _userSearchQuery = value;
                        _applyFiltersAndSorting();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Role filter
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: (['All', 'Emergency Responder', 'Community Leader', 'Users'].contains(_selectedRoleFilter)) ? _selectedRoleFilter : 'All',
                    decoration: InputDecoration(
                      labelText: 'Filter by Role',
                      filled: true,
                      fillColor: Colors.green[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'All', child: Text('All Roles')),
                      ...[
                        'Emergency Responder',
                        'Community Leader',
                        'Users',
                      ].map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRoleFilter = value!;
                        _applyFiltersAndSorting();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Status filter
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: (['All', 'Active', 'Inactive'].contains(_selectedStatusFilter)) ? _selectedStatusFilter : 'All',
                    decoration: InputDecoration(
                      labelText: 'Filter by Status',
                      filled: true,
                      fillColor: Colors.green[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'All', child: Text('All Status')),
                      DropdownMenuItem(value: 'Active', child: Text('Active')),
                      DropdownMenuItem(
                        value: 'Inactive',
                        child: Text('Inactive'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatusFilter = value!;
                        _applyFiltersAndSorting();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // User count
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_filteredUsers.length} of ${_users.length} users',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sort row
            Row(
              children: [
                Text('Sort by:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: (['name', 'contact', 'address', 'role'].contains(_sortBy)) ? _sortBy : 'name',
                    underline: const SizedBox(),
                    dropdownColor: Colors.white,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                    items: const [
                      DropdownMenuItem(value: 'name', child: Text('Name')),
                      DropdownMenuItem(
                        value: 'contact',
                        child: Text('Contact Number'),
                      ),
                      DropdownMenuItem(
                        value: 'address',
                        child: Text('Address'),
                      ),
                      DropdownMenuItem(value: 'role', child: Text('Role')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                        _applyFiltersAndSorting();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  onPressed: () {
                    setState(() {
                      _sortAscending = !_sortAscending;
                      _applyFiltersAndSorting();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // User table
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFF2d5f3f),
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      dataRowMinHeight: 56,
                      dataRowMaxHeight: 72,
                      columnSpacing: 32,
                      horizontalMargin: 24,
                      dataRowColor: WidgetStateProperty.resolveWith<Color?>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green[100];
                        }
                        return Colors.white;
                      }),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Contact Number',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Role',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: _filteredUsers.map((user) {
                        final isActive = user['status'] == 'Active';
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF2d5f3f),
                                    foregroundColor: Colors.white,
                                    radius: 22,
                                    child: Text(
                                      user['name']![0].toUpperCase(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    user['name'] ?? '',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                user['contact'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            DataCell(
                              Text(
                                user['address'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            DataCell(
                              Text(
                                user['role'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green[50]
                                      : Colors.red[50],
                                  border: Border.all(
                                    color: isActive ? Colors.green : Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 12,
                                      color: isActive
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user['status'] ?? '',
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 22,
                                    ),
                                    tooltip: 'Edit',
                                    onPressed: () => _showEditUserDialog(user),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    tooltip: 'Delete',
                                    onPressed: () =>
                                        _showDeleteConfirmation(user),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
