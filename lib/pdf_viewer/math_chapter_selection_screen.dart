import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'pdf_viewer_screen.dart';

class ChapterInfo {
  final int number;
  final String title;
  final String assetPath;

  ChapterInfo({
    required this.number,
    required this.title,
    required this.assetPath,
  });
}

class MathChapterSelectionScreen extends StatefulWidget {
  const MathChapterSelectionScreen({super.key});

  @override
  State<MathChapterSelectionScreen> createState() =>
      _MathChapterSelectionScreenState();
}

class _MathChapterSelectionScreenState
    extends State<MathChapterSelectionScreen> {
  final List<ChapterInfo> _chapters = [
    ChapterInfo(
      number: 1,
      title: 'Relations and Functions',
      assetPath: 'assets/maths/maths_chapter1.pdf',
    ),
    ChapterInfo(
      number: 2,
      title: 'Inverse Trigonometric Functions',
      assetPath: 'assets/maths/maths_chapter2.pdf',
    ),
    ChapterInfo(
      number: 3,
      title: 'Matrices',
      assetPath: 'assets/maths/maths_chapter3.pdf',
    ),
    ChapterInfo(
      number: 4,
      title: 'Determinants',
      assetPath: 'assets/maths/maths_chapter4.pdf',
    ),
    ChapterInfo(
      number: 5,
      title: 'Continuity and Differentiability',
      assetPath: 'assets/maths/maths_chapter5.pdf',
    ),
    ChapterInfo(
      number: 6,
      title: 'Application of Derivatives',
      assetPath: 'assets/maths/maths_chapter6.pdf',
    ),
    ChapterInfo(
      number: 7,
      title: 'Integrals',
      assetPath: 'assets/maths/maths_chapter7.pdf',
    ),
    ChapterInfo(
      number: 8,
      title: 'Application of Integrals',
      assetPath: 'assets/maths/maths_chapter8.pdf',
    ),
    ChapterInfo(
      number: 9,
      title: 'Differential Equations',
      assetPath: 'assets/maths/maths_chapter9.pdf',
    ),
    ChapterInfo(
      number: 10,
      title: 'Vector Algebra',
      assetPath: 'assets/maths/maths_chapter10.pdf',
    ),
    ChapterInfo(
      number: 11,
      title: 'Three Dimensional Geometry',
      assetPath: 'assets/maths/maths_chapter11.pdf',
    ),
    ChapterInfo(
      number: 12,
      title: 'Linear Programming',
      assetPath: 'assets/maths/maths_chapter12.pdf',
    ),
    ChapterInfo(
      number: 13,
      title: 'Probability',
      assetPath: 'assets/maths/maths_chapter13.pdf',
    ),
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Map<String, bool> _assetExistence = {};
  bool _isVerifyingAssets = true;
  bool _hasHistory = false;
  Map<String, dynamic> _readingHistory = {};

  @override
  void initState() {
    super.initState();
    _verifyAllAssets();
    _loadReadingHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load reading history to show last read position
  Future<void> _loadReadingHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString('reading_history');
      if (historyString != null) {
        setState(() {
          _readingHistory = json.decode(historyString);
          _hasHistory = true;
        });
      }
    } catch (e) {
      print('Error loading reading history: $e');
    }
  }

  // Save reading history when opening a chapter
  Future<void> _saveReadingHistory(String filePath, int pageNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> history = _readingHistory;
      history[filePath] = {
        'lastRead': DateTime.now().toIso8601String(),
        'pageNumber': pageNumber,
      };
      await prefs.setString('reading_history', json.encode(history));
    } catch (e) {
      print('Error saving reading history: $e');
    }
  }

  // Verify if all PDF assets exist
  Future<void> _verifyAllAssets() async {
    setState(() {
      _isVerifyingAssets = true;
    });

    Map<String, bool> results = {};
    for (var chapter in _chapters) {
      try {
        ByteData data = await rootBundle.load(chapter.assetPath);
        results[chapter.assetPath] = data.lengthInBytes > 0;
      } catch (e) {
        results[chapter.assetPath] = false;
        print('Asset verification error for ${chapter.assetPath}: $e');
      }
    }

    if (mounted) {
      setState(() {
        _assetExistence = results;
        _isVerifyingAssets = false;
      });
    }
  }

  // Filter chapters based on search query
  List<ChapterInfo> get _filteredChapters {
    if (_searchQuery.isEmpty) {
      return _chapters;
    }
    return _chapters.where((chapter) {
      return chapter.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          chapter.number.toString().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.green,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Mathematics Chapters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green.shade900,
                          Colors.green.shade600,
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    right: -50,
                    top: -50,
                    child: CircleAvatar(
                      radius: 130,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                  const Positioned(
                    left: -30,
                    bottom: -30,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search chapters...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
          ),

          // Recent chapter section (if any history)
          if (_hasHistory && _searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: Colors.green.shade800,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Continue Reading',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRecentlyReadSection(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(thickness: 1),
                    ),
                  ],
                ),
              ),
            ),

          if (_isVerifyingAssets)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Verifying PDF resources...'),
                  ],
                ),
              ),
            )
          else if (_filteredChapters.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No chapters found matching your search.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chapter = _filteredChapters[index];
                    bool assetExists =
                        _assetExistence[chapter.assetPath] ?? false;
                    bool hasReadingHistory =
                        _readingHistory.containsKey(chapter.assetPath);
                    int lastPage = hasReadingHistory
                        ? _readingHistory[chapter.assetPath]['pageNumber']
                        : 0;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: assetExists
                            ? () => _openPdf(context, chapter)
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.calculate_rounded,
                                  size: 32,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Chapter ${chapter.number}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  chapter.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!assetExists)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade700,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Unavailable',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (hasReadingHistory)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.bookmark_rounded,
                                        color: Colors.green.shade700,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Page ${lastPage + 1}',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _filteredChapters.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentlyReadSection() {
    if (_readingHistory.isEmpty) return const SizedBox.shrink();

    // Find the most recently read math chapter
    String? mostRecentPath;
    DateTime mostRecentTime = DateTime(2000);

    _readingHistory.forEach((path, data) {
      // Only consider math chapters
      if (path.contains('maths')) {
        final lastReadTime = DateTime.parse(data['lastRead']);
        if (lastReadTime.isAfter(mostRecentTime)) {
          mostRecentTime = lastReadTime;
          mostRecentPath = path;
        }
      }
    });

    if (mostRecentPath == null) return const SizedBox.shrink();

    final recentChapter = _chapters.firstWhere(
      (chapter) => chapter.assetPath == mostRecentPath,
      orElse: () => ChapterInfo(number: 0, title: 'Unknown', assetPath: ''),
    );

    if (recentChapter.assetPath.isEmpty) return const SizedBox.shrink();

    final lastPage = _readingHistory[mostRecentPath]['pageNumber'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _openPdf(context, recentChapter, startPage: lastPage),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 32,
                  color: Colors.amber.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recentChapter.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Continue from page ${lastPage + 1}',
                      style: TextStyle(
                        color: Colors.amber.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.amber.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPdf(BuildContext context, ChapterInfo chapter,
      {int startPage = 0}) async {
    try {
      final String fileName = chapter.assetPath.split('/').last;
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/$fileName';

      // Check if file exists
      bool fileExists = await File(path).exists();

      // If file doesn't exist, copy from assets
      if (!fileExists) {
        final ByteData data = await rootBundle.load(chapter.assetPath);
        final Uint8List bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes);
      }

      if (!mounted) return;

      // Save to reading history - use the asset path as the key
      await _saveReadingHistory(chapter.assetPath, startPage);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            filePath: path,
            title: 'Chapter ${chapter.number}: ${chapter.title}',
            initialPage: startPage,
          ),
        ),
      ).then((_) {
        // Refresh reading history when returning from PDF viewer
        _loadReadingHistory();
      });
    } catch (e) {
      // Show error dialog
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Could not load PDF: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
