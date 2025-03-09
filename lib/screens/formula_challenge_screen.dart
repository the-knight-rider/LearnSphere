import 'package:flutter/material.dart';
import 'dart:math';

class FormulaChallengeScreen extends StatefulWidget {
  final String userEmail;

  const FormulaChallengeScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _FormulaChallengeScreenState createState() => _FormulaChallengeScreenState();
}

class _FormulaChallengeScreenState extends State<FormulaChallengeScreen> {
  final TextEditingController _answerController = TextEditingController();
  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  bool _quizCompleted = false;
  String _selectedSubject = 'Physics';
  String? _userAnswer;
  String _explanation = '';

  final Map<String, List<Map<String, dynamic>>> _allQuestions = {
    'Physics': [
      {
        'question':
            'Calculate the force (in N) when a mass of 5 kg is accelerated at 2 m/s².',
        'formula': 'F = m × a',
        'answer': '10',
        'explanation':
            'Using the formula F = m × a, we substitute m = 5 kg and a = 2 m/s². So F = 5 kg × 2 m/s² = 10 N.',
        'unit': 'N',
      },
      {
        'question':
            'Calculate the kinetic energy (in J) of a 2 kg object moving at 3 m/s.',
        'formula': 'KE = (1/2) × m × v²',
        'answer': '9',
        'explanation':
            'Using the formula KE = (1/2) × m × v², we substitute m = 2 kg and v = 3 m/s. So KE = (1/2) × 2 kg × (3 m/s)² = (1/2) × 2 kg × 9 m²/s² = 9 J.',
        'unit': 'J',
      },
      {
        'question':
            'Calculate the acceleration (in m/s²) when a force of 15 N is applied to a mass of 3 kg.',
        'formula': 'a = F ÷ m',
        'answer': '5',
        'explanation':
            'Using the formula a = F ÷ m, we substitute F = 15 N and m = 3 kg. So a = 15 N ÷ 3 kg = 5 m/s².',
        'unit': 'm/s²',
      },
      {
        'question':
            'Calculate the work done (in J) when a force of 8 N moves an object 4 meters in the direction of the force.',
        'formula': 'W = F × d',
        'answer': '32',
        'explanation':
            'Using the formula W = F × d, we substitute F = 8 N and d = 4 m. So W = 8 N × 4 m = 32 J.',
        'unit': 'J',
      },
      {
        'question':
            'Calculate the potential energy (in J) of a 2 kg object raised to a height of 5 meters on Earth (g = 9.8 m/s²).',
        'formula': 'PE = m × g × h',
        'answer': '98',
        'explanation':
            'Using the formula PE = m × g × h, we substitute m = 2 kg, g = 9.8 m/s², and h = 5 m. So PE = 2 kg × 9.8 m/s² × 5 m = 98 J.',
        'unit': 'J',
      },
    ],
    'Chemistry': [
      {
        'question':
            'If 2 moles of hydrogen gas reacts with 1 mole of oxygen gas, how many moles of water are produced?\n2H₂ + O₂ → 2H₂O',
        'formula': 'Balanced chemical equation: 2H₂ + O₂ → 2H₂O',
        'answer': '2',
        'explanation':
            'From the balanced equation 2H₂ + O₂ → 2H₂O, we can see that 2 moles of hydrogen gas and 1 mole of oxygen gas produce 2 moles of water.',
        'unit': 'mol',
      },
      {
        'question':
            'Calculate the pH of a solution with a hydrogen ion concentration [H⁺] of 1 × 10⁻⁵ mol/L.',
        'formula': 'pH = -log[H⁺]',
        'answer': '5',
        'explanation':
            'Using the formula pH = -log[H⁺], we substitute [H⁺] = 1 × 10⁻⁵ mol/L. So pH = -log(1 × 10⁻⁵) = -((-5)) = 5.',
        'unit': '',
      },
      {
        'question':
            'Calculate the molarity (M) of a solution containing 4 moles of solute in 2 liters of solution.',
        'formula': 'Molarity = moles of solute ÷ liters of solution',
        'answer': '2',
        'explanation':
            'Using the formula Molarity = moles of solute ÷ liters of solution, we substitute moles = 4 and liters = 2. So Molarity = 4 mol ÷ 2 L = 2 M.',
        'unit': 'M',
      },
      {
        'question':
            'Calculate the mass (in grams) of 3 moles of CO₂ (molecular weight of CO₂ = 44 g/mol).',
        'formula': 'Mass = moles × molecular weight',
        'answer': '132',
        'explanation':
            'Using the formula Mass = moles × molecular weight, we substitute moles = 3 and molecular weight = 44 g/mol. So Mass = 3 mol × 44 g/mol = 132 g.',
        'unit': 'g',
      },
      {
        'question':
            'Calculate the number of moles in 90 grams of water (molecular weight of H₂O = 18 g/mol).',
        'formula': 'Moles = mass ÷ molecular weight',
        'answer': '5',
        'explanation':
            'Using the formula Moles = mass ÷ molecular weight, we substitute mass = 90 g and molecular weight = 18 g/mol. So Moles = 90 g ÷ 18 g/mol = 5 mol.',
        'unit': 'mol',
      },
    ],
    'Mathematics': [
      {
        'question': 'Find the derivative of f(x) = 3x² + 2x with respect to x.',
        'formula': 'f\'(x) = d/dx[3x² + 2x]',
        'answer': '6x + 2',
        'explanation':
            'Using the power rule d/dx[x^n] = nx^(n-1), we get d/dx[3x²] = 3 · 2x¹ = 6x and d/dx[2x] = 2. So f\'(x) = 6x + 2.',
        'unit': '',
      },
      {
        'question': 'Calculate the area of a circle with radius 4 cm.',
        'formula': 'A = πr²',
        'answer': '16π',
        'explanation':
            'Using the formula A = πr², we substitute r = 4 cm. So A = π × (4 cm)² = π × 16 cm² = 16π cm².',
        'unit': 'cm²',
      },
      {
        'question': 'Solve for x: 2x + 5 = 11',
        'formula': '2x + 5 = 11',
        'answer': '3',
        'explanation':
            'Starting with 2x + 5 = 11, we subtract 5 from both sides: 2x = 6. Then we divide both sides by 2: x = 3.',
        'unit': '',
      },
      {
        'question': 'Calculate the volume of a sphere with radius 3 cm.',
        'formula': 'V = (4/3)πr³',
        'answer': '36π',
        'explanation':
            'Using the formula V = (4/3)πr³, we substitute r = 3 cm. So V = (4/3)π × (3 cm)³ = (4/3)π × 27 cm³ = 36π cm³.',
        'unit': 'cm³',
      },
      {
        'question': 'Find the value of x if log₁₀(x) = 2.',
        'formula': 'log₁₀(x) = 2',
        'answer': '100',
        'explanation': 'If log₁₀(x) = 2, then x = 10². So x = 100.',
        'unit': '',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _initQuiz();
  }

  void _initQuiz() {
    _questions = List.from(_allQuestions[_selectedSubject]!);
    _questions.shuffle(Random());
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _isAnswered = false;
    _isCorrect = false;
    _quizCompleted = false;
    _answerController.clear();
    _userAnswer = null;
    _explanation = '';
  }

  void _checkAnswer() {
    String userInput = _answerController.text.trim();

    if (userInput.isEmpty) return;

    // Store user's answer for displaying later
    _userAnswer = userInput;

    // Check if answer is correct (allow for different formats)
    bool isCorrect = false;

    // Get the correct answer from the question
    String correctAnswer =
        _questions[_currentQuestionIndex]['answer'].toString();

    // Handle special cases for math answers
    if (_selectedSubject == 'Mathematics') {
      // Remove spaces and convert to lowercase for comparison
      userInput = userInput.replaceAll(' ', '').toLowerCase();
      correctAnswer = correctAnswer.replaceAll(' ', '').toLowerCase();

      // Direct comparison
      isCorrect = userInput == correctAnswer;
    } else {
      // For physics and chemistry, try to parse as numbers if possible
      try {
        // Try to parse as double for numeric comparison
        double userValue = double.parse(userInput);
        double correctValue = double.parse(correctAnswer);

        // Allow for slight rounding errors
        isCorrect = (userValue - correctValue).abs() < 0.01;
      } catch (e) {
        // If parsing fails, do direct string comparison
        isCorrect = userInput == correctAnswer;
      }
    }

    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
      _explanation = _questions[_currentQuestionIndex]['explanation'];

      if (isCorrect) {
        _correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _isCorrect = false;
        _answerController.clear();
        _userAnswer = null;
        _explanation = '';
      } else {
        _quizCompleted = true;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _initQuiz();
    });
  }

  void _changeSubject(String subject) {
    setState(() {
      _selectedSubject = subject;
      _initQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formula Challenge'),
        backgroundColor: Colors.orange.shade700,
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
              Colors.orange.shade50,
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
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_selectedSubject Challenge',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion['question'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.functions,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Formula: ${currentQuestion['formula']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (!_isAnswered)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Your Answer' +
                      (currentQuestion['unit'] != ''
                          ? ' (${currentQuestion['unit']})'
                          : ''),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _checkAnswer,
                  ),
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _checkAnswer(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Answer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
                Row(
                  children: [
                    Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: _isCorrect ? Colors.green : Colors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCorrect ? 'Correct!' : 'Incorrect',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Your answer: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '$_userAnswer' +
                          (currentQuestion['unit'] != ''
                              ? ' ${currentQuestion['unit']}'
                              : ''),
                      style: TextStyle(
                        fontSize: 16,
                        color: _isCorrect
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                if (!_isCorrect) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Correct answer: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${currentQuestion['answer']}' +
                            (currentQuestion['unit'] != ''
                                ? ' ${currentQuestion['unit']}'
                                : ''),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Explanation:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _explanation,
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
              backgroundColor: Colors.orange.shade700,
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
    final score = _correctAnswers / _questions.length * 100;
    String message;
    Color messageColor;

    if (score >= 80) {
      message = 'Formula Master!';
      messageColor = Colors.green;
    } else if (score >= 60) {
      message = 'Good Understanding!';
      messageColor = Colors.blue;
    } else if (score >= 40) {
      message = 'Keep Practicing!';
      messageColor = Colors.orange;
    } else {
      message = 'Need More Practice!';
      messageColor = Colors.red;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.functions,
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
            'You got',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_correctAnswers/${_questions.length}',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
          ),
          Text(
            '${score.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 24,
              color: Colors.orange.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _restartQuiz,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Colors.orange.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Try Again',
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

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
