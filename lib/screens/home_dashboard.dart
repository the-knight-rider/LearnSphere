import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LearnSphere Dashboard'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, [Student Name]!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'What would you like to do today?',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    title: 'Personalized Learning',
                    icon: Icons.school,
                    color: Colors.blue,
                    onTap: () {
                      // Navigate to Personalized Learning screen
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Quizzes & Games',
                    icon: Icons.quiz,
                    color: Colors.green,
                    onTap: () {
                      // Navigate to Quizzes & Games screen
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Study Roadmap',
                    icon: Icons.map,
                    color: Colors.orange,
                    onTap: () {
                      // Navigate to Study Roadmap screen
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Performance Review',
                    icon: Icons.bar_chart,
                    color: Colors.purple,
                    onTap: () {
                      // Navigate to Performance Review screen
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Teacher Interactions',
                    icon: Icons.people,
                    color: Colors.red,
                    onTap: () {
                      // Navigate to Teacher Interactions screen
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Offline Resources',
                    icon: Icons.download,
                    color: Colors.teal,
                    onTap: () {
                      // Navigate to Offline Resources screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          // Handle navigation between dashboard, profile, and settings
        },
      ),
    );
  }

  // Helper to build dashboard cards
  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
