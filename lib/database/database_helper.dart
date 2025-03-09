import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    print(
        'Opening existing database or creating a new one if it doesn\'t exist');
    return await openDatabase(
      path,
      version: 2, // Keep version number for future upgrades
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Handle database upgrades - keep this for future schema changes
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop the existing table and recreate with new schema
      await db.execute('DROP TABLE IF EXISTS users');
      await _createDB(db, newVersion);
    }
  }

  // Create the 'users' table
  Future _createDB(Database db, int version) async {
    print('Creating new database with updated schema...');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        class TEXT CHECK(class IN ('11', '12')) NOT NULL
      )
    ''');

    print('Database table "users" created with new schema.');
  }

  // Validate email
  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Validate password (minimum 6 characters for this example)
  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Insert a user into the database
  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      print('Starting user registration process...');
      print('Validating user data: $user');

      if (!isValidEmail(user['email'])) {
        print('Invalid email format: ${user['email']}');
        throw 'Invalid email format';
      }
      if (!isValidPassword(user['password'])) {
        print('Invalid password: less than 6 characters');
        throw 'Password must be at least 6 characters';
      }
      if (!['11', '12'].contains(user['class'])) {
        print('Invalid class selected: ${user['class']}');
        throw 'Invalid class selected';
      }
      if (user['name']?.toString().trim().isEmpty ?? true) {
        print('Name is empty or null');
        throw 'Name is required';
      }

      final db = await instance.database;

      // Check if email already exists
      print('Checking for existing user with email: ${user['email']}');
      final existingUser = await getUser(user['email']);
      if (existingUser != null) {
        print('Email already registered: ${user['email']}');
        throw 'Email is already registered';
      }

      print('All validations passed, inserting user into database');
      final result = await db.insert('users', user);
      print('User successfully inserted with id: $result');
      return result;
    } catch (e) {
      print('Error in insertUser: $e');
      if (e is String) {
        throw e;
      } else if (e is DatabaseException) {
        print('Database error: ${e.toString()}');
        if (e.toString().contains('UNIQUE constraint failed')) {
          throw 'Email is already registered';
        }
      }
      throw 'Failed to register user. Please try again. Error: ${e.toString()}';
    }
  }

  // Get a user by email
  Future<Map<String, dynamic>?> getUser(String email) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error getting user: $e');
      throw 'Failed to get user information';
    }
  }

  // Get all users (for admin purposes)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  // Update user information
  Future<int> updateUser(Map<String, dynamic> user) async {
    if (!isValidEmail(user['email'])) {
      throw 'Invalid email format.';
    }
    if (!isValidPassword(user['password'])) {
      throw 'Password must be at least 6 characters.';
    }

    final db = await instance.database;

    // Log the update attempt
    print('Updating user: $user');

    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // Delete user by ID
  Future<int> deleteUser(int id) async {
    final db = await instance.database;

    // Log the delete attempt
    print('Deleting user with id: $id');

    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// Widget for user role selection (for UI)
class RoleSelectionWidget extends StatelessWidget {
  final ValueChanged<String> onRoleSelected;

  RoleSelectionWidget({required this.onRoleSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('Select Role'),
      onChanged: (value) {
        onRoleSelected(value ?? 'student'); // default to 'student' if null
      },
      items: <String>['student', 'teacher']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
