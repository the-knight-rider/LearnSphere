import 'package:flutter/material.dart';
import 'package:learnsphere/repository/user_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false;
  String _errorMessage = '';

  // Login function
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset any previous error message
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter both email and password.';
      });
      return;
    }

    try {
      final user = await _userRepository.loginUser(email);
      if (user != null && user['password'] == password) {
        // Login successful, navigate to another screen (e.g., home)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid email or password.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error logging in. Please try again later.';
      });
    }
  }

  // Navigate to Register Screen
  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        // backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
  padding: EdgeInsets.symmetric(vertical: 40),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blueAccent, Colors.purpleAccent], // A more engaging gradient
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // image: DecorationImage(
    //   image: AssetImage('assets/images/learnsphere_background.png'), // Add a custom image background (optional)
    //   fit: BoxFit.cover, // Ensure the background image covers the entire container
    //   opacity: 0.2, // Adjust image opacity for a softer effect
    // ),
    borderRadius: BorderRadius.circular(20), // Rounded corners for a modern look
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Add a dynamic and interactive icon, such as an AI-related one
      Icon(
        Icons.school, // You can replace with another icon or image as needed
        size: 80,
        color: Colors.white,
      ),
      SizedBox(height: 20),
      Text(
        'Welcome to LearnSphere', // Replace with your app's name
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(blurRadius: 10, color: Colors.black45, offset: Offset(2, 2)), // Add shadow for emphasis
          ],
        ),
      ),
      SizedBox(height: 10),
      Text(
        'Your Personalized Learning Hub', // Subtext for more context
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    ],
  ),
),

              SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New user?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: Text(
                      'Register here',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
