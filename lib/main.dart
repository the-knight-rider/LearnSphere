import 'package:flutter/material.dart';
import 'package:learnsphere/database/database_helper.dart';
import 'package:learnsphere/screens/login_screen.dart';
import 'package:learnsphere/screens/register_screen.dart';

// import 'package:learnsphere/screens/home_screen.dart';
import 'screens/home_dashboard.dart';
import 'package:flutter/material.dart';

// import 'package:learnsphere/aihelpers/ai_helper.dart';
import 'package:learnsphere/aihelpers/ai_helper.dart'; // Ensure this path is correct and AIHelper class is defined in this file



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final aiHelper = AIHelper();
//   await aiHelper.loadModel();
//
//   runApp(MyApp(aiHelper: aiHelper));
// }
//
// class MyApp extends StatelessWidget {
//   final AIHelper aiHelper;
//   MyApp({required this.aiHelper});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(aiHelper: aiHelper),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   final AIHelper aiHelper;
//   HomeScreen({required this.aiHelper});
//
//   Future<void> getPrediction() async {
//     List<double> sampleInput = [0.7, 0.5, 0.3];  // Example input values
//     List<double> result = await aiHelper.runInference(sampleInput);
//     print("📢 AI Prediction: ${result[0]}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("AI Learning App")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: getPrediction,
//           child: Text("Get AI Recommendation"),
//         ),
//       ),
//     );
//   }
// }
// jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
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
// jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
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
