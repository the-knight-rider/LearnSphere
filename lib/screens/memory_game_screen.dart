import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MemoryGameScreen extends StatefulWidget {
  final String userEmail;

  const MemoryGameScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<MemoryCard> _cards;
  int _score = 0;
  int _attempts = 0;
  MemoryCard? _selectedCard;
  bool _isProcessing = false;
  bool _gameCompleted = false;
  int _pairsMatched = 0;
  int _totalPairs = 8;
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _elapsedTime = '00:00';
  String _selectedSubject = 'Physics';

  final Map<String, List<Map<String, String>>> _allCards = {
    'Physics': [
      {'term': 'Newton', 'definition': 'Unit of Force'},
      {'term': 'Joule', 'definition': 'Unit of Energy'},
      {'term': 'Watt', 'definition': 'Unit of Power'},
      {'term': 'Ohm', 'definition': 'Unit of Resistance'},
      {'term': 'Velocity', 'definition': 'Rate of change of displacement'},
      {'term': 'Acceleration', 'definition': 'Rate of change of velocity'},
      {'term': 'Inertia', 'definition': 'Resistance to change in motion'},
      {'term': 'Mass', 'definition': 'Measure of amount of matter'},
    ],
    'Chemistry': [
      {'term': 'H₂O', 'definition': 'Water'},
      {'term': 'NaCl', 'definition': 'Salt'},
      {'term': 'CO₂', 'definition': 'Carbon Dioxide'},
      {'term': 'O₂', 'definition': 'Oxygen'},
      {'term': 'H₂SO₄', 'definition': 'Sulfuric Acid'},
      {'term': 'HCl', 'definition': 'Hydrochloric Acid'},
      {'term': 'CH₄', 'definition': 'Methane'},
      {'term': 'C₆H₁₂O₆', 'definition': 'Glucose'},
    ],
    'Mathematics': [
      {'term': 'π', 'definition': '3.14159...'},
      {'term': '√', 'definition': 'Square Root'},
      {'term': 'sin θ', 'definition': 'Opposite / Hypotenuse'},
      {'term': 'cos θ', 'definition': 'Adjacent / Hypotenuse'},
      {'term': 'dy/dx', 'definition': 'Derivative'},
      {'term': '∫', 'definition': 'Integral'},
      {'term': 'x²', 'definition': 'x squared'},
      {'term': 'n!', 'definition': 'Factorial'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initGame() {
    // Reset game state
    _score = 0;
    _attempts = 0;
    _selectedCard = null;
    _isProcessing = false;
    _gameCompleted = false;
    _pairsMatched = 0;

    // Create and shuffle cards
    _initCards();

    // Start timer
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          final minutes =
              _stopwatch.elapsed.inMinutes.toString().padLeft(2, '0');
          final seconds =
              (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
          _elapsedTime = '$minutes:$seconds';
        });
      }
    });
  }

  void _initCards() {
    // Create pairs of cards (terms and definitions)
    List<Map<String, String>> cardData = [..._allCards[_selectedSubject]!];
    List<MemoryCard> cards = [];

    // Create term cards
    for (int i = 0; i < cardData.length; i++) {
      cards.add(MemoryCard(
        id: i,
        content: cardData[i]['term']!,
        pairId: i,
        isFlipped: false,
        isMatched: false,
        type: CardType.term,
      ));
    }

    // Create definition cards
    for (int i = 0; i < cardData.length; i++) {
      cards.add(MemoryCard(
        id: i + cardData.length,
        content: cardData[i]['definition']!,
        pairId: i,
        isFlipped: false,
        isMatched: false,
        type: CardType.definition,
      ));
    }

    // Shuffle cards
    cards.shuffle(Random());

    setState(() {
      _cards = cards;
    });
  }

  void _selectCard(int index) {
    if (_isProcessing) return;
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_selectedCard == null) {
      // First card selected
      setState(() {
        _selectedCard = _cards[index];
      });
    } else {
      // Second card selected
      setState(() {
        _attempts++;
      });

      if (_selectedCard!.pairId == _cards[index].pairId) {
        // Cards match
        setState(() {
          _cards[index].isMatched = true;
          _selectedCard!.isMatched = true;
          _selectedCard = null;
          _score += 10;
          _pairsMatched++;
        });

        if (_pairsMatched == _totalPairs) {
          _endGame();
        }
      } else {
        // Cards don't match
        setState(() {
          _isProcessing = true;
        });

        // Wait briefly before flipping cards back
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _cards[index].isFlipped = false;
              _selectedCard!.isFlipped = false;
              _selectedCard = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  void _endGame() {
    _timer.cancel();
    _stopwatch.stop();
    setState(() {
      _gameCompleted = true;
    });
  }

  void _restartGame() {
    _timer.cancel();
    _stopwatch.stop();
    _initGame();
  }

  void _changeSubject(String subject) {
    setState(() {
      _selectedSubject = subject;
    });
    _restartGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        backgroundColor: Colors.green.shade700,
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
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: _gameCompleted ? _buildResultScreen() : _buildGameScreen(),
      ),
    );
  }

  Widget _buildGameScreen() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Attempts: $_attempts',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Time: $_elapsedTime',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Matched: $_pairsMatched/$_totalPairs',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              return _buildCard(_cards[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard(MemoryCard card, int index) {
    return GestureDetector(
      onTap: () => _selectCard(index),
      child: Card(
        elevation: 4,
        color: card.isMatched
            ? Colors.green.shade100
            : card.isFlipped
                ? (card.type == CardType.term
                    ? Colors.blue.shade50
                    : Colors.orange.shade50)
                : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: card.isMatched
                ? Colors.green
                : card.isFlipped
                    ? (card.type == CardType.term ? Colors.blue : Colors.orange)
                    : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: card.isFlipped || card.isMatched
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      card.content,
                      key: ValueKey<String>(card.content),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: card.type == CardType.term
                            ? Colors.blue.shade800
                            : Colors.orange.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const Icon(
                    Icons.question_mark,
                    size: 30,
                    color: Colors.grey,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    // Calculate final score based on time and attempts
    final minutes = _stopwatch.elapsed.inMinutes;
    final seconds = (_stopwatch.elapsed.inSeconds % 60);
    final timeScore =
        max(0, 300 - (minutes * 60 + seconds)); // Time bonus: max 300 points
    final attemptPenalty =
        (_attempts - _totalPairs) * 5; // Penalty for excess attempts
    final finalScore = _score + timeScore - attemptPenalty;

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
          const Text(
            'Game Complete!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 32),
          _buildResultItem('Total Score', '$finalScore pts'),
          _buildResultItem('Matching Points', '$_score pts'),
          _buildResultItem('Time Bonus', '+$timeScore pts'),
          _buildResultItem('Excess Attempts', '-$attemptPenalty pts'),
          _buildResultItem('Total Time', _elapsedTime),
          _buildResultItem('Total Attempts', '$_attempts'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _restartGame,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Colors.green.shade700,
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

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 100,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCard {
  final int id;
  final String content;
  final int pairId;
  bool isFlipped;
  bool isMatched;
  final CardType type;

  MemoryCard({
    required this.id,
    required this.content,
    required this.pairId,
    required this.isFlipped,
    required this.isMatched,
    required this.type,
  });
}

enum CardType {
  term,
  definition,
}
