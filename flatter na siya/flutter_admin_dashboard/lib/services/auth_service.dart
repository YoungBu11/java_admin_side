import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login with email and password
  static Future<AuthResult> login(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Check if user has admin privileges
        final bool isAdmin = await _checkAdminPrivileges(
          userCredential.user!.uid,
        );

        if (isAdmin) {
          // Update last login timestamp
          await _updateLastLogin(userCredential.user!.uid);

          return AuthResult.success(
            user: userCredential.user!,
            message: 'Login successful',
          );
        } else {
          // Sign out if not admin
          await _auth.signOut();
          return AuthResult.failure(
            'Access denied. Admin privileges required.',
          );
        }
      }

      return AuthResult.failure('Login failed');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure(
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Check admin privileges
  static Future<bool> _checkAdminPrivileges(String uid) async {
    try {
      final DocumentSnapshot adminDoc = await _firestore
          .collection('admin_users')
          .doc(uid)
          .get();

      if (adminDoc.exists) {
        final data = adminDoc.data() as Map<String, dynamic>;
        return data['is_active'] == true && data['role'] == 'admin';
      }

      return false;
    } catch (e) {
      print('Error checking admin privileges: $e');
      return false;
    }
  }

  // Get user admin info
  static Future<AdminUser?> getAdminUserInfo(String uid) async {
    try {
      final DocumentSnapshot adminDoc = await _firestore
          .collection('admin_users')
          .doc(uid)
          .get();

      if (adminDoc.exists) {
        return AdminUser.fromFirestore(adminDoc);
      }

      return null;
    } catch (e) {
      print('Error getting admin user info: $e');
      return null;
    }
  }

  // Update last login timestamp
  static Future<void> _updateLastLogin(String uid) async {
    try {
      await _firestore.collection('admin_users').doc(uid).update({
        'last_login': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Create admin user (for initial setup)
  static Future<AuthResult> createAdminUser({
    required String email,
    required String password,
    required String fullName,
    String role = 'admin',
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Create admin document in Firestore
        await _firestore
            .collection('admin_users')
            .doc(userCredential.user!.uid)
            .set({
              'uid': userCredential.user!.uid,
              'email': email,
              'full_name': fullName,
              'role': role,
              'is_active': true,
              'created_at': FieldValue.serverTimestamp(),
              'updated_at': FieldValue.serverTimestamp(),
              'last_login': null,
              'permissions': _getDefaultPermissions(role),
            });

        // Update display name
        await userCredential.user!.updateDisplayName(fullName);

        return AuthResult.success(
          user: userCredential.user!,
          message: 'Admin user created successfully',
        );
      }

      return AuthResult.failure('Failed to create admin user');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure(
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Get default permissions based on role
  static Map<String, bool> _getDefaultPermissions(String role) {
    switch (role) {
      case 'super_admin':
        return {
          'manage_users': true,
          'manage_categories': true,
          'manage_tips': true,
          'manage_measures': true,
          'view_analytics': true,
          'system_settings': true,
        };
      case 'admin':
        return {
          'manage_users': false,
          'manage_categories': true,
          'manage_tips': true,
          'manage_measures': true,
          'view_analytics': true,
          'system_settings': false,
        };
      case 'editor':
        return {
          'manage_users': false,
          'manage_categories': false,
          'manage_tips': true,
          'manage_measures': true,
          'view_analytics': false,
          'system_settings': false,
        };
      default:
        return {
          'manage_users': false,
          'manage_categories': false,
          'manage_tips': false,
          'manage_measures': false,
          'view_analytics': false,
          'system_settings': false,
        };
    }
  }

  // Reset password
  static Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success(message: 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  // Convert Firebase Auth error codes to user-friendly messages
  static String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled';
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-credential':
        return 'Invalid login credentials';
      default:
        return 'Login failed. Please check your credentials and try again';
    }
  }
}

// Auth result class
class AuthResult {
  final bool isSuccess;
  final String message;
  final User? user;

  AuthResult._({required this.isSuccess, required this.message, this.user});

  factory AuthResult.success({User? user, String message = 'Success'}) {
    return AuthResult._(isSuccess: true, message: message, user: user);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, message: message);
  }
}

// Admin user model
class AdminUser {
  final String uid;
  final String email;
  final String fullName;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  final Map<String, bool> permissions;

  AdminUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    required this.permissions,
  });

  factory AdminUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AdminUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      fullName: data['full_name'] ?? '',
      role: data['role'] ?? 'admin',
      isActive: data['is_active'] ?? false,
      createdAt: data['created_at']?.toDate(),
      updatedAt: data['updated_at']?.toDate(),
      lastLogin: data['last_login']?.toDate(),
      permissions: Map<String, bool>.from(data['permissions'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'full_name': fullName,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'last_login': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'permissions': permissions,
    };
  }

  // Check if user has specific permission
  bool hasPermission(String permission) {
    return permissions[permission] == true;
  }

  // Check if user is super admin
  bool get isSuperAdmin => role == 'super_admin';

  // Check if user can manage users
  bool get canManageUsers => hasPermission('manage_users');

  // Check if user can manage categories
  bool get canManageCategories => hasPermission('manage_categories');

  // Check if user can manage tips
  bool get canManageTips => hasPermission('manage_tips');

  // Check if user can manage measures
  bool get canManageMeasures => hasPermission('manage_measures');

  // Check if user can view analytics
  bool get canViewAnalytics => hasPermission('view_analytics');

  // Check if user can access system settings
  bool get canAccessSystemSettings => hasPermission('system_settings');
}
