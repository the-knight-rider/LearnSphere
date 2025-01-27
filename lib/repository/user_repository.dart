import 'package:learnsphere/database/database_helper.dart';

class UserRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Register a new user
  Future<void> registerUser(String name, String email, String password, String role) async {
    final user = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };

    // Insert user into the database
    await dbHelper.insertUser(user);
  }

  // Login user by email
  Future<Map<String, dynamic>?> loginUser(String email) async {
    // Get user details by email
    final user = await dbHelper.getUser(email);
    
    // Log the fetched user
    print('User fetched from database: $user');
    
    return user;
  }

  // Fetch all users (For admin, for example)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await dbHelper.getAllUsers();
  }

  // Update user information (e.g., update password or role)
  Future<void> updateUser(Map<String, dynamic> user) async {
    // Update user details in the database
    await dbHelper.updateUser(user);
  }

  // Delete user by ID (e.g., admin functionality)
  Future<void> deleteUser(int id) async {
    // Delete user from the database
    await dbHelper.deleteUser(id);
  }
}
