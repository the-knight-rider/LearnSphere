import 'package:learnsphere/database/database_helper.dart';

class UserRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Register a new user
  Future<void> registerUser(
      String name, String email, String password, String studentClass) async {
    try {
      print('UserRepository: Starting user registration');
      print('UserRepository: Preparing user data');

      final user = {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'class': studentClass,
      };

      print('UserRepository: Calling database to insert user');
      await dbHelper.insertUser(user);
      print('UserRepository: User registration successful');
    } catch (e) {
      print('UserRepository: Error during registration: $e');
      // Rethrow the error with the original message
      throw e.toString();
    }
  }

  // Login user by email
  Future<Map<String, dynamic>?> loginUser(String email) async {
    // Get user details by email
    final user = await dbHelper.getUser(email);

    // Log the fetched user
    print('User fetched from database: $user');

    return user;
  }

  // Get current user's name
  Future<String?> getCurrentUserName(String email) async {
    final user = await dbHelper.getUser(email);
    return user?['name'];
  }

  // Get current user's class
  Future<String?> getCurrentUserClass(String email) async {
    final user = await dbHelper.getUser(email);
    return user?['class'];
  }

  // Get all user details
  Future<Map<String, dynamic>?> getUserDetails(String email) async {
    return await dbHelper.getUser(email);
  }

  // Fetch all users (For admin, for example)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await dbHelper.getAllUsers();
  }

  // Update user information
  Future<void> updateUser(Map<String, dynamic> user) async {
    await dbHelper.updateUser(user);
  }

  // Delete user by ID
  Future<void> deleteUser(int id) async {
    await dbHelper.deleteUser(id);
  }
}
