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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the 'users' table
  Future _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT CHECK(role IN ('student', 'teacher')) NOT NULL
      );
    ''');

    // Log the creation of the table
    print('Database table "users" created.');
  }

  // Validate email
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Validate password (minimum 6 characters for this example)
  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Insert a user into the database
  Future<int> insertUser(Map<String, dynamic> user) async {
    if (!isValidEmail(user['email'])) {
      throw 'Invalid email format.';
    }
    if (!isValidPassword(user['password'])) {
      throw 'Password must be at least 6 characters.';
    }

    final db = await instance.database;

    // Log the user being inserted
    print('Inserting user: $user');

    return await db.insert('users', user);
  }

  // Get a user by email
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    
    // Log the query result
    print('Query result for email $email: $result');
    
    return result.isNotEmpty ? result.first : null;
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
        onRoleSelected(value ?? 'student');  // default to 'student' if null
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
