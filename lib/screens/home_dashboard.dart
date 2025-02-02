import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LearnSphere',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Settings navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore your learning journey:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[600],
                  ),
                ),
                SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true, // Allows GridView to shrink to fit its content
                  physics: NeverScrollableScrollPhysics(), // Prevents independent scrolling
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _dashboardItems.length,
                  itemBuilder: (context, index) {
                    final item = _dashboardItems[index];
                    return _buildDashboardCard(
                      title: item['title']!,
                      icon: item['icon'] as IconData,
                      color: item['color'] as Color,
                      onTap: item['onTap'] as VoidCallback,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey[900],
        selectedItemColor: const Color.fromARGB(255, 150, 151, 230),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
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
            icon: Icon(Icons.smart_toy_rounded),
            label: 'AI',
          ),
        ],
        onTap: (index) {
          // Handle navigation actions
        },
      ),
    );
  }

  // Helper to build a single dashboard card
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
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(157, 185, 184, 184),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 70, color: color), // Increased icon size
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashboard items list for better scalability and modularity
final List<Map<String, dynamic>> _dashboardItems = [
  {
    'title': 'Physics',
    'icon': Icons.emoji_objects,
    'color': Colors.orange,
    'onTap': () {
      // Navigate to Physics
    },
  },
  {
    'title': 'Chemistry',
    'icon': Icons.local_drink,
    'color': Colors.blue,
    'onTap': () {
      // Navigate to Chemistry
    },
  },
  {
    'title': 'Maths',
    'icon': Icons.calculate,
    'color': Colors.green,
    'onTap': () {
      // Navigate to Maths
    },
  },
  {
    'title': 'Quizzes & Games',
    'icon': Icons.quiz,
    'color': Colors.pink,
    'onTap': () {
      // Navigate to Quizzes
    },
  },
  {
    'title': 'Study Roadmap',
    'icon': Icons.map_outlined,
    'color': Colors.purple,
    'onTap': () {
      // Navigate to Study Roadmap
    },
  },
  {
    'title': 'Performance Review',
    'icon': Icons.bar_chart_rounded,
    'color': Colors.red,
    'onTap': () {
      // Navigate to Performance Review
    },
  },
  {
    'title': 'Personalized Learning',
    'icon': Icons.school,
    'color': Colors.teal,
    'onTap': () {
      // Navigate to Personalized Learning
    },
  },
  {
    'title': 'Teacher Interaction',
    'icon': Icons.chat_bubble_outline,
    'color': Colors.amber,
    'onTap': () {
      // Navigate to Teacher Interaction
    },
  },
  {
    'title': 'My Content',
    'icon': Icons.folder,
    'color': Colors.brown,
    'onTap': () {
      // Navigate to My Content
    },
  },
];
