import 'package:flutter/material.dart';
import 'package:learnsphere/database/database_helper.dart';
import 'package:learnsphere/screens/login_screen.dart';
import 'package:learnsphere/screens/register_screen.dart';
// import 'package:learnsphere/screens/home_screen.dart';
import 'screens/home_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Offline Education',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeDashboard(),
      },
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AI Offline Education'),
//       ),
//       body: Center(
//         child: Text('hii welcome toe app'),
//       ),
//     );
//   }
// }
