import 'package:flutter/material.dart';
import '../pdf_viewer/chapter_selection_screen.dart';
import '../pdf_viewer/chemistry_chapter_selection_screen.dart';
import '../pdf_viewer/math_chapter_selection_screen.dart';
import '../repository/user_repository.dart';
import 'performance_review_screen.dart';
import 'games_hub_screen.dart';
import 'study_roadmap_screen.dart';

class HomeDashboard extends StatefulWidget {
  final String userEmail;

  const HomeDashboard({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;
  String _userName = '';
  String _userClass = '';
  final UserRepository _userRepository = UserRepository();

  // Move dashboardItems inside the class to access widget
  late final List<Map<String, dynamic>> _dashboardItems;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _initDashboardItems();
  }

  void _initDashboardItems() {
    _dashboardItems = [
      {
        'title': 'Physics',
        'icon': Icons.emoji_objects,
        'color': Colors.orange,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChapterSelectionScreen(),
            ),
          );
        },
      },
      {
        'title': 'Chemistry',
        'icon': Icons.local_drink,
        'color': Colors.blue,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChemistryChapterSelectionScreen(),
            ),
          );
        },
      },
      {
        'title': 'Maths',
        'icon': Icons.calculate,
        'color': Colors.green,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MathChapterSelectionScreen(),
            ),
          );
        },
      },
      {
        'title': 'Quizzes & Games',
        'icon': Icons.quiz,
        'color': Colors.pink,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamesHubScreen(userEmail: widget.userEmail),
            ),
          );
        },
      },
      {
        'title': 'Study Roadmap',
        'icon': Icons.map_outlined,
        'color': Colors.purple,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StudyRoadmapScreen(userEmail: widget.userEmail),
            ),
          );
        },
      },
      {
        'title': 'Performance Review',
        'icon': Icons.bar_chart_rounded,
        'color': Colors.red,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PerformanceReviewScreen(userEmail: widget.userEmail),
            ),
          );
        },
      },
      {
        'title': 'Personalized Learning',
        'icon': Icons.school,
        'color': Colors.teal,
        'onTap': (BuildContext context) {
          // Navigate to Personalized Learning
        },
      },
      {
        'title': 'Teacher Interaction',
        'icon': Icons.chat_bubble_outline,
        'color': Colors.amber,
        'onTap': (BuildContext context) {
          // Navigate to Teacher Interaction
        },
      },
      {
        'title': 'My Content',
        'icon': Icons.folder,
        'color': Colors.brown,
        'onTap': (BuildContext context) {
          // Navigate to My Content
        },
      },
    ];
  }

  Future<void> _loadUserDetails() async {
    final name = await _userRepository.getCurrentUserName(widget.userEmail);
    final userClass =
        await _userRepository.getCurrentUserClass(widget.userEmail);
    if (mounted) {
      setState(() {
        _userName = name ?? '';
        _userClass = userClass ?? '';
      });
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $_userName!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Class ${_userClass}th',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Explore your learning journey:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[600],
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _dashboardItems.length,
                itemBuilder: (context, index) {
                  final item = _dashboardItems[index];
                  return _buildDashboardCard(
                    context: context,
                    title: item['title']!,
                    icon: item['icon'] as IconData,
                    color: item['color'] as Color,
                    onTap: () => item['onTap'](context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade800,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Class ${_userClass}th',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                // Handle settings tap
              },
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                // Handle help tap
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Logout',
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade800),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  // Logout the user and clear session
  void _logout() {
    // Simply navigate to login screen
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'LearnSphere' : 'Profile',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        elevation: 4,
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : _buildProfileContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
