import 'package:flutter/material.dart';
import '../repository/user_repository.dart';

class StudyRoadmapScreen extends StatefulWidget {
  final String userEmail;

  const StudyRoadmapScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  State<StudyRoadmapScreen> createState() => _StudyRoadmapScreenState();
}

class _StudyRoadmapScreenState extends State<StudyRoadmapScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserRepository _userRepository = UserRepository();
  String _userName = '';
  String _userClass = '';
  bool _isLoading = true;

  // Sample data for roadmap
  final Map<String, List<SubjectTopic>> _subjectsData = {
    'Physics': [
      SubjectTopic(
        name: 'Electric Charges and Fields',
        status: TopicStatus.completed,
        progress: 100,
        difficulty: 3,
      ),
      SubjectTopic(
        name: 'Electrostatic Potential',
        status: TopicStatus.inProgress,
        progress: 65,
        difficulty: 4,
      ),
      SubjectTopic(
        name: 'Current Electricity',
        status: TopicStatus.upcoming,
        progress: 0,
        difficulty: 4,
      ),
      SubjectTopic(
        name: 'Moving Charges and Magnetism',
        status: TopicStatus.upcoming,
        progress: 0,
        difficulty: 5,
      ),
    ],
    'Chemistry': [
      SubjectTopic(
        name: 'Basic Concepts of Chemistry',
        status: TopicStatus.completed,
        progress: 100,
        difficulty: 2,
      ),
      SubjectTopic(
        name: 'Structure of Atom',
        status: TopicStatus.completed,
        progress: 100,
        difficulty: 3,
      ),
      SubjectTopic(
        name: 'Classification of Elements',
        status: TopicStatus.inProgress,
        progress: 35,
        difficulty: 3,
      ),
      SubjectTopic(
        name: 'Chemical Bonding',
        status: TopicStatus.upcoming,
        progress: 0,
        difficulty: 4,
      ),
    ],
    'Mathematics': [
      SubjectTopic(
        name: 'Relations and Functions',
        status: TopicStatus.completed,
        progress: 100,
        difficulty: 2,
      ),
      SubjectTopic(
        name: 'Inverse Trigonometric Functions',
        status: TopicStatus.inProgress,
        progress: 80,
        difficulty: 4,
      ),
      SubjectTopic(
        name: 'Matrices',
        status: TopicStatus.upcoming,
        progress: 0,
        difficulty: 3,
      ),
      SubjectTopic(
        name: 'Determinants',
        status: TopicStatus.upcoming,
        progress: 0,
        difficulty: 4,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    final name = await _userRepository.getCurrentUserName(widget.userEmail);
    final userClass =
        await _userRepository.getCurrentUserClass(widget.userEmail);

    if (mounted) {
      setState(() {
        _userName = name ?? '';
        _userClass = userClass ?? '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study Roadmap',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple.shade800,
        elevation: 4,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Physics'),
            Tab(text: 'Chemistry'),
            Tab(text: 'Mathematics'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // User progress summary
                _buildProgressSummary(),

                // Tab content with roadmap
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSubjectRoadmap('Physics'),
                      _buildSubjectRoadmap('Chemistry'),
                      _buildSubjectRoadmap('Mathematics'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProgressSummary() {
    // Calculate overall progress
    int totalTopics = 0;
    int completedTopics = 0;
    int inProgressTopics = 0;

    _subjectsData.forEach((subject, topics) {
      totalTopics += topics.length;
      completedTopics +=
          topics.where((topic) => topic.status == TopicStatus.completed).length;
      inProgressTopics += topics
          .where((topic) => topic.status == TopicStatus.inProgress)
          .length;
    });

    final double overallProgress = totalTopics > 0
        ? ((completedTopics + (inProgressTopics * 0.5)) / totalTopics) * 100
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.purple.shade100,
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $_userName!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Class ${_userClass}th',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Overall Progress',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${overallProgress.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: overallProgress / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade800),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusCard(
                title: 'Completed',
                count: completedTopics,
                color: Colors.green,
                icon: Icons.check_circle_outline,
              ),
              _buildStatusCard(
                title: 'In Progress',
                count: inProgressTopics,
                color: Colors.blue,
                icon: Icons.pending_outlined,
              ),
              _buildStatusCard(
                title: 'Upcoming',
                count: totalTopics - completedTopics - inProgressTopics,
                color: Colors.orange,
                icon: Icons.schedule,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 18,
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

  Widget _buildSubjectRoadmap(String subject) {
    final topics = _subjectsData[subject] ?? [];

    return topics.isEmpty
        ? Center(
            child: Text(
              'No roadmap available for $subject yet.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return _buildTopicCard(topic, index, topics.length);
            },
          );
  }

  Widget _buildTopicCard(SubjectTopic topic, int index, int totalTopics) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (topic.status) {
      case TopicStatus.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        statusIcon = Icons.check_circle;
        break;
      case TopicStatus.inProgress:
        statusColor = Colors.blue;
        statusText = 'In Progress';
        statusIcon = Icons.pending;
        break;
      case TopicStatus.upcoming:
        statusColor = Colors.orange;
        statusText = 'Upcoming';
        statusIcon = Icons.schedule;
        break;
    }

    return Column(
      children: [
        Row(
          children: [
            // Timeline connector
            Container(
              width: 30,
              height: double.infinity,
              child: Column(
                children: [
                  // Line before circle (not for first item)
                  if (index > 0)
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.grey.shade300,
                    ),

                  // Circle indicator
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: statusColor, width: 2),
                    ),
                    child: Icon(
                      statusIcon,
                      size: 12,
                      color: statusColor,
                    ),
                  ),

                  // Line after circle (not for last item)
                  if (index < totalTopics - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            ),

            // Topic card
            Expanded(
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              topic.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 14,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Difficulty level
                          Row(
                            children: [
                              Icon(
                                Icons.signal_cellular_alt,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Difficulty: ${topic.difficulty}/5',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Estimated time
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${topic.difficulty * 2} hours',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (topic.status != TopicStatus.upcoming) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: topic.progress / 100,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      statusColor),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${topic.progress}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (topic.status != TopicStatus.completed)
                        ElevatedButton(
                          onPressed: () {
                            // Handle "Start Learning" action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Navigate to ${topic.name} content'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: statusColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                topic.status == TopicStatus.inProgress
                                    ? Icons.play_arrow
                                    : Icons.school,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                topic.status == TopicStatus.inProgress
                                    ? 'Continue Learning'
                                    : 'Start Learning',
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum TopicStatus {
  completed,
  inProgress,
  upcoming,
}

class SubjectTopic {
  final String name;
  final TopicStatus status;
  final int progress; // 0-100
  final int difficulty; // 1-5

  SubjectTopic({
    required this.name,
    required this.status,
    required this.progress,
    required this.difficulty,
  });
}
