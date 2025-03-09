import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceReviewScreen extends StatefulWidget {
  final String userEmail;

  const PerformanceReviewScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _PerformanceReviewScreenState createState() =>
      _PerformanceReviewScreenState();
}

class _PerformanceReviewScreenState extends State<PerformanceReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Color> gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Review'),
        backgroundColor: Colors.blue.shade800,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Subjects'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildSubjectsTab(),
          _buildProgressTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceCard(),
          const SizedBox(height: 20),
          _buildRecentActivitiesCard(),
          const SizedBox(height: 20),
          _buildWeeklyProgressCard(),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Performance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPerformanceMetric('Average Score', '85%', Colors.blue),
                _buildPerformanceMetric('Completion', '72%', Colors.green),
                _buildPerformanceMetric('Accuracy', '78%', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(String label, String value, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                value: double.parse(value.replaceAll('%', '')) / 100,
                backgroundColor: Colors.grey[200],
                color: color,
                strokeWidth: 8,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivitiesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              'Physics Quiz',
              'Score: 90%',
              Icons.emoji_objects,
              Colors.blue,
            ),
            _buildActivityItem(
              'Chemistry Chapter 3',
              'Completed',
              Icons.science,
              Colors.green,
            ),
            _buildActivityItem(
              'Math Practice',
              'In Progress',
              Icons.calculate,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String status, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(status),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildWeeklyProgressCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          if (value >= 0 && value < days.length) {
                            return Text(days[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 4),
                        const FlSpot(2, 3.5),
                        const FlSpot(3, 5),
                        const FlSpot(4, 4),
                        const FlSpot(5, 4.5),
                        const FlSpot(6, 5),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(colors: gradientColors),
                      barWidth: 5,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors
                              .map((color) => color.withOpacity(0.3))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSubjectCard(
          'Physics',
          85,
          Colors.blue,
          Icons.emoji_objects,
          [
            {'topic': 'Mechanics', 'progress': 0.9},
            {'topic': 'Thermodynamics', 'progress': 0.7},
            {'topic': 'Optics', 'progress': 0.8},
          ],
        ),
        _buildSubjectCard(
          'Chemistry',
          78,
          Colors.green,
          Icons.science,
          [
            {'topic': 'Organic Chemistry', 'progress': 0.8},
            {'topic': 'Inorganic Chemistry', 'progress': 0.6},
            {'topic': 'Physical Chemistry', 'progress': 0.7},
          ],
        ),
        _buildSubjectCard(
          'Mathematics',
          92,
          Colors.orange,
          Icons.calculate,
          [
            {'topic': 'Algebra', 'progress': 0.95},
            {'topic': 'Calculus', 'progress': 0.85},
            {'topic': 'Geometry', 'progress': 0.9},
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectCard(String subject, int score, Color color,
      IconData icon, List<Map<String, dynamic>> topics) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$score%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...topics.map((topic) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(topic['topic']),
                        const Spacer(),
                        Text('${(topic['progress'] * 100).toInt()}%'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: topic['progress'],
                      backgroundColor: Colors.grey[200],
                      color: color,
                    ),
                    const SizedBox(height: 12),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProgressCard(
          'Study Time',
          'Total hours spent learning',
          '124 hours',
          Icons.timer,
          Colors.purple,
          0.75,
        ),
        _buildProgressCard(
          'Chapters Completed',
          'Across all subjects',
          '24/30',
          Icons.book,
          Colors.blue,
          0.8,
        ),
        _buildProgressCard(
          'Quiz Performance',
          'Average score in all quizzes',
          '85%',
          Icons.quiz,
          Colors.orange,
          0.85,
        ),
        _buildProgressCard(
          'Attendance',
          'Online sessions attended',
          '90%',
          Icons.calendar_today,
          Colors.green,
          0.9,
        ),
      ],
    );
  }

  Widget _buildProgressCard(String title, String subtitle, String value,
      IconData icon, Color color, double progress) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
