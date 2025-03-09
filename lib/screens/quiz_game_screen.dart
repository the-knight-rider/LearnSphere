import 'package:flutter/material.dart';
import 'dart:math';

class QuizGameScreen extends StatefulWidget {
  final String userEmail;

  const QuizGameScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _QuizGameScreenState createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int? _selectedOptionIndex;
  bool _quizCompleted = false;
  late List<Map<String, dynamic>> _questions;
  String _selectedSubject = 'Physics';

  final Map<String, List<Map<String, dynamic>>> _allQuestions = {
    'Physics': [
      {
        'question': 'What is the SI unit of force?',
        'options': ['Newton', 'Joule', 'Watt', 'Pascal'],
        'correctIndex': 0,
        'explanation':
            'The SI unit of force is the Newton (N), named after Sir Isaac Newton.'
      },
      {
        'question': 'Which of the following is a vector quantity?',
        'options': ['Mass', 'Temperature', 'Velocity', 'Energy'],
        'correctIndex': 2,
        'explanation':
            'Velocity is a vector quantity as it has both magnitude and direction.'
      },
      {
        'question': 'What is the formula for kinetic energy?',
        'options': ['KE = mgh', 'KE = 1/2mv²', 'KE = mv', 'KE = ma'],
        'correctIndex': 1,
        'explanation':
            'The formula for kinetic energy is KE = 1/2mv², where m is mass and v is velocity.'
      },
      {
        'question':
            'Which law of motion states that for every action, there is an equal and opposite reaction?',
        'options': [
          'First Law',
          'Second Law',
          'Third Law',
          'Law of Conservation of Energy'
        ],
        'correctIndex': 2,
        'explanation':
            'Newton\'s Third Law states that for every action, there is an equal and opposite reaction.'
      },
      {
        'question': 'What is the unit of electrical resistance?',
        'options': ['Watt', 'Volt', 'Ampere', 'Ohm'],
        'correctIndex': 3,
        'explanation': 'The unit of electrical resistance is the Ohm (Ω).'
      },
    ],
    'Chemistry': [
      {
        'question': 'What is the chemical symbol for gold?',
        'options': ['Go', 'Au', 'Ag', 'Gd'],
        'correctIndex': 1,
        'explanation':
            'The chemical symbol for gold is Au, derived from its Latin name, Aurum.'
      },
      {
        'question': 'Which of the following is a noble gas?',
        'options': ['Hydrogen', 'Carbon Dioxide', 'Helium', 'Chlorine'],
        'correctIndex': 2,
        'explanation':
            'Helium is a noble gas, which means it has a full outer shell of electrons and is chemically inert.'
      },
      {
        'question': 'What is the pH of a neutral solution?',
        'options': ['0', '7', '10', '14'],
        'correctIndex': 1,
        'explanation':
            'The pH of a neutral solution is 7. Values below 7 indicate acidity, while values above 7 indicate alkalinity.'
      },
      {
        'question': 'Which of these is NOT a state of matter?',
        'options': ['Solid', 'Liquid', 'Gas', 'Energy'],
        'correctIndex': 3,
        'explanation':
            'Energy is not a state of matter. The traditional states of matter are solid, liquid, and gas, with plasma often considered the fourth state.'
      },
      {
        'question':
            'What type of bond is formed when electrons are shared between atoms?',
        'options': [
          'Ionic bond',
          'Covalent bond',
          'Hydrogen bond',
          'Metallic bond'
        ],
        'correctIndex': 1,
        'explanation':
            'A covalent bond is formed when electrons are shared between atoms.'
      },
    ],
    'Mathematics': [
      {
        'question': 'What is the value of π (pi) to two decimal places?',
        'options': ['3.14', '3.41', '3.12', '3.21'],
        'correctIndex': 0,
        'explanation': 'The value of π to two decimal places is 3.14.'
      },
      {
        'question': 'What is the derivative of x²?',
        'options': ['x³', '2x', 'x/2', '2x²'],
        'correctIndex': 1,
        'explanation':
            'The derivative of x² is 2x, following the power rule where d/dx(x^n) = nx^(n-1).'
      },
      {
        'question': 'What is the formula for the area of a circle?',
        'options': ['A = πr²', 'A = 2πr', 'A = πd', 'A = πr³'],
        'correctIndex': 0,
        'explanation':
            'The formula for the area of a circle is A = πr², where r is the radius of the circle.'
      },
      {
        'question': 'Which of the following is not a prime number?',
        'options': ['2', '3', '5', '9'],
        'correctIndex': 3,
        'explanation':
            '9 is not a prime number as it can be divided by 3. A prime number is only divisible by 1 and itself.'
      },
      {
        'question': 'What is the value of log₁₀(100)?',
        'options': ['1', '2', '10', '100'],
        'correctIndex': 1,
        'explanation': 'The value of log₁₀(100) is 2, as 10² = 100.'
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _questions = [..._allQuestions[_selectedSubject]!];
    _questions.shuffle(Random());
  }

  void _selectOption(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      _isCorrect = index == _questions[_currentQuestionIndex]['correctIndex'];

      if (_isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOptionIndex = null;
      } else {
        _quizCompleted = true;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isAnswered = false;
      _selectedOptionIndex = null;
      _quizCompleted = false;
      _questions = [..._allQuestions[_selectedSubject]!];
      _questions.shuffle(Random());
    });
  }

  void _changeSubject(String subject) {
    setState(() {
      _selectedSubject = subject;
      _restartQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Game'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeSubject,
            itemBuilder: (BuildContext context) {
              return {'Physics', 'Chemistry', 'Mathematics'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.subject),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: _quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_selectedSubject Quiz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              currentQuestion['question'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: (currentQuestion['options'] as List).length,
            itemBuilder: (context, index) {
              final option = currentQuestion['options'][index];
              final isSelected = _selectedOptionIndex == index;
              final isCorrect = currentQuestion['correctIndex'] == index;

              Color? backgroundColor;
              if (_isAnswered) {
                if (isSelected) {
                  backgroundColor =
                      isCorrect ? Colors.green[100] : Colors.red[100];
                } else if (isCorrect) {
                  backgroundColor = Colors.green[100];
                }
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: backgroundColor,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? (isCorrect ? Colors.green : Colors.red)
                        : Colors.blue.shade700,
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    option,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () => _selectOption(index),
                ),
              );
            },
          ),
        ),
        if (_isAnswered) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isCorrect ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isCorrect ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isCorrect ? 'Correct!' : 'Incorrect',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentQuestion['explanation'],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _nextQuestion,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentQuestionIndex < _questions.length - 1
                  ? 'Next Question'
                  : 'See Results',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / _questions.length) * 100;
    String message;
    Color messageColor;

    if (percentage >= 80) {
      message = 'Excellent!';
      messageColor = Colors.green;
    } else if (percentage >= 60) {
      message = 'Good job!';
      messageColor = Colors.blue;
    } else if (percentage >= 40) {
      message = 'Keep practicing!';
      messageColor = Colors.orange;
    } else {
      message = 'Try again!';
      messageColor = Colors.red;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 100,
            color: Colors.amber,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: messageColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You scored',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_score/${_questions.length}',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 24,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _restartQuiz,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Play Again',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Back to Games',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
