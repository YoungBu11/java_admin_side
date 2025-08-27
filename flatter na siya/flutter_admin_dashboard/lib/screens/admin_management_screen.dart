import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';
import 'package:flutter/services.dart';

class AdminManagementScreen extends StatefulWidget {
  final String role;
  const AdminManagementScreen({super.key, this.role = 'admin'});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  @override
  void initState() {
    super.initState();
    _applyFiltersAndSorting();
  }
  // Admin Management CRUD State
  // ...existing code...

  bool _handledInitialArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_handledInitialArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        if (args['showAddUser'] == true || args['showAddAdmin'] == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAddAdminDialog();
          });
        }
      }
      _handledInitialArgs = true;
    }
  }

  final List<Map<String, String>> _admins = [
    {
      'id': '1',
      'name': 'CDRRMO_NICO',
      'contact': '09123456780',
      'address': 'CDRRMO Office, San Pedro',
      'role': 'Superadmin',
      'status': 'Active',
    },
    {
      'id': '2',
      'name': 'CDRRMO_PAT',
      'contact': '09123456781',
      'address': 'CDRRMO Office, San Pedro',
      'role': 'Admin',
      'status': 'Active',
    },
    {
      'id': '3',
      'name': 'PUP_CHARLES',
      'contact': '09123456782',
      'address': 'PUP San Pedro',
      'role': 'Admin',
      'status': 'Active',
    },
    {
      'id': '4',
      'name': 'PUP_FAYE',
      'contact': '09123456783',
      'address': 'PUP San Pedro',
      'role': 'Admin',
      'status': 'Active',
    },
    {
      'id': '5',
      'name': 'PUP_ZAMUEL',
      'contact': '09123456784',
      'address': 'PUP San Pedro',
      'role': 'Admin',
      'status': 'Active',
    },
    {
      'id': '6',
      'name': 'PUP_ARIANNE',
      'contact': '09123456785',
      'address': 'PUP San Pedro',
      'role': 'Admin',
      'status': 'Active',
    },
  ];

  // Controllers for admin form
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedRole = 'Admin';
  String? _editingAdminId;

  // Filter and Sort State Variables
  String _adminSearchQuery = '';
  String _selectedRoleFilter = 'All';
  String _selectedStatusFilter = 'All';
  String _sortBy = 'name';
  bool _sortAscending = true;
  List<Map<String, String>> _filteredAdmins = [];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSorting() {
    List<Map<String, String>> filtered = List.from(_admins);
    if (_adminSearchQuery.isNotEmpty) {
      filtered = filtered.where((admin) {
        return admin['name']!.toLowerCase().contains(
              _adminSearchQuery.toLowerCase(),
            ) ||
            admin['contact']!.toLowerCase().contains(
              _adminSearchQuery.toLowerCase(),
            ) ||
            admin['address']!.toLowerCase().contains(
              _adminSearchQuery.toLowerCase(),
            );
      }).toList();
    }
    if (_selectedRoleFilter != 'All') {
      filtered = filtered
          .where((admin) => admin['role'] == _selectedRoleFilter)
          .toList();
    }
    if (_selectedStatusFilter != 'All') {
      filtered = filtered
          .where((admin) => admin['status'] == _selectedStatusFilter)
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
      _filteredAdmins = filtered;
    });
  }

  void _showAddAdminDialog() {
    _clearForm();
    _editingAdminId = null;
    _showAdminDialog('Add Admin');
  }

  void _showEditAdminDialog(Map<String, String> admin) {
    _nameController.text = admin['name']!;
    _contactController.text = admin['contact']!;
    _addressController.text = admin['address']!;
    _selectedRole = admin['role']!;
    _editingAdminId = admin['id'];
    _showAdminDialog('Edit Admin');
  }

  void _showAdminDialog(String title) {
    String? nameError;
    String? contactError;
    String? addressError;
    bool showAllErrors = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void validateFields() {
              setDialogState(() {
                nameError = null;
                contactError = null;
                addressError = null;

                // ADMIN NAME VALIDATION: Only allow letters, spaces, hyphens and ñÑ
                if (_nameController.text.trim().isEmpty) {
                  nameError = 'Admin Name is required';
                } else if (!RegExp(
                  r'^[a-zA-ZñÑ\s\-]+$',
                ).hasMatch(_nameController.text.trim())) {
                  nameError = 'Name must only contain letters';
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
                } else if (_admins.any(
                  (admin) =>
                      admin['contact'] == _contactController.text &&
                      admin['id'] != _editingAdminId,
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

            WidgetsBinding.instance.addPostFrameCallback((_) {
              validateFields();
            });

            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 500,
                height: 320,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-ZñÑ\s\-]+$'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Admin Name *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                          errorText:
                              (showAllErrors || _nameController.text.isNotEmpty)
                              ? nameError
                              : null,
                        ),
                        onChanged: (_) => validateFields(),
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
                          hintText: 'Office, Building, City',
                          helperText:
                              'Include complete address for admin contact',
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
                        value: (['Admin', 'Superadmin'].contains(_selectedRole))
                            ? _selectedRole
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.work),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Superadmin',
                            child: Text('Superadmin'),
                          ),
                          DropdownMenuItem(
                            value: 'Admin',
                            child: Text('Admin'),
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
                        color: Color(0xFF2d5f3f),
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            showAllFieldErrors();
                            _validateAndSaveAdmin(context, setDialogState);
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

  void _validateAndSaveAdmin(
    BuildContext dialogContext,
    StateSetter setDialogState,
  ) {
    String? errorMessage;
    if (_nameController.text.trim().isEmpty) {
      errorMessage = '❌ Admin Name is required';
    } else if (_contactController.text.trim().isEmpty) {
      errorMessage = '❌ Contact Number is required';
    } else if (!_contactController.text.startsWith('09')) {
      errorMessage =
          '❌ Invalid Contact Number - Must start with 09 (e.g., 09123456789)';
    } else if (_contactController.text.length != 11) {
      errorMessage =
          '❌ Invalid Contact Number - Must be exactly 11 digits (09XXXXXXXXX)';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(_contactController.text)) {
      errorMessage = '❌ Invalid Contact Number - Must contain only numbers';
    } else if (_addressController.text.trim().isEmpty) {
      errorMessage = '❌ Complete Address is required';
    } else if (_addressController.text.trim().length < 10) {
      errorMessage =
          '❌ Incomplete Address - Please provide a complete address (minimum 10 characters)';
    } else if (_admins.any(
      (admin) =>
          admin['contact'] == _contactController.text &&
          admin['id'] != _editingAdminId,
    )) {
      errorMessage =
          '❌ Duplicate Contact Number - This mobile number is already registered in the system';
    }
    if (errorMessage != null) {
      return;
    }
    _saveValidatedAdmin();
    Navigator.of(dialogContext).pop();
  }

  void _saveValidatedAdmin() {
    setState(() {
      if (_editingAdminId == null) {
        final newId = (_admins.length + 1).toString();
        _admins.add({
          'id': newId,
          'name': _nameController.text.trim(),
          'contact': _contactController.text.trim(),
          'address': _addressController.text.trim(),
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
                    '✅ Success! Admin "${_nameController.text.trim()}" has been added to the system',
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
        final adminIndex = _admins.indexWhere(
          (admin) => admin['id'] == _editingAdminId,
        );
        if (adminIndex != -1) {
          _admins[adminIndex] = {
            'id': _editingAdminId!,
            'name': _nameController.text.trim(),
            'contact': _contactController.text.trim(),
            'address': _addressController.text.trim(),
            'role': _selectedRole,
            'status': _admins[adminIndex]['status']!,
          };
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '✅ Success! Admin "${_nameController.text.trim()}" has been updated successfully',
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
    _applyFiltersAndSorting();
    _clearForm();
  }

  void _showDeleteConfirmation(Map<String, String> admin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${admin['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteAdmin(admin['id']!);
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

  void _deleteAdmin(String adminId) {
    setState(() {
      _admins.removeWhere((admin) => admin['id'] == adminId);
    });
    _applyFiltersAndSorting();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Admin deleted successfully!')),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _contactController.clear();
    _addressController.clear();
    _selectedRole = 'Admin';
  }

  void _exportAdmins(String format) {
    String message;
    switch (format) {
      case 'xlsx':
        message = 'Admins exported as XLSX file successfully!';
        break;
      case 'pdf':
        message = 'Admins exported as PDF file successfully!';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(
        selectedIndex: 1,
        role: widget.role,
        onItemSelected: (index) {
          if (index == 1) {
            // Already on Admin Management, do nothing
            return;
          }
          switch (index) {
            case 0:
              if (widget.role == 'superadmin') {
                Navigator.pushReplacementNamed(
                  context,
                  '/superadmin-dashboard',
                  arguments: {'role': 'superadmin'},
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  '/dashboard',
                  arguments: {'role': widget.role},
                );
              }
              break;
            case 1:
              // Always go to admin management, not user management
              Navigator.pushReplacementNamed(
                context,
                '/admins',
                arguments: {'role': widget.role},
              );
              break;
            case 2:
              Navigator.pushReplacementNamed(
                context,
                widget.role == 'superadmin'
                    ? '/superadmin-notifications'
                    : '/notifications',
                arguments: {'role': widget.role},
              );
              break;
            case 3:
              Navigator.pushReplacementNamed(
                context,
                '/superadmin-settings',
                arguments: {'role': widget.role},
              );
              break;
            case 4:
              Navigator.pushReplacementNamed(
                context,
                '/superadmin-system-logs',
                arguments: {'role': widget.role},
              );
              break;
            case 5:
              Navigator.pushReplacementNamed(
                context,
                '/users',
                arguments: {'role': widget.role},
              );
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
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.admin_panel_settings, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Admin Management',
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
              Positioned(
                left: 0,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              const Positioned(
                right: 24,
                child: Text(
                  'Welcome, Superadmin',
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
                  children: const [
                    Text(
                      'Admin Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2d5f3f),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage admin accounts for the system',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: PopupMenuButton<String>(
                        onSelected: (String format) => _exportAdmins(format),
                        tooltip: 'Export Admins',
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
                                'Export Admins',
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
                        onTap: _showAddAdminDialog,
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
                                'Add Admin',
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
                      hintText: 'Search admins by name, contact, or address...',
                      filled: true,
                      fillColor: Colors.green[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _adminSearchQuery = value;
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
                    value: _selectedRoleFilter,
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
                      ...['Superadmin', 'Admin'].map(
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
                    value: _selectedStatusFilter,
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
                // Admin count
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
                    '${_filteredAdmins.length} of ${_admins.length} admins',
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
                    value: _sortBy,
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
            // Admin table
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
                      rows: _filteredAdmins.map((admin) {
                        final isActive = admin['status'] == 'Active';
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
                                      admin['name']![0].toUpperCase(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    admin['name'] ?? '',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                admin['contact'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            DataCell(
                              Text(
                                admin['address'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            DataCell(
                              Text(
                                admin['role'] ?? '',
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
                                      admin['status'] ?? '',
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
                                    onPressed: () =>
                                        _showEditAdminDialog(admin),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    tooltip: 'Delete',
                                    onPressed: () =>
                                        _showDeleteConfirmation(admin),
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
