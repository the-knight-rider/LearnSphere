import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PDFViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;
  final int initialPage;

  const PDFViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
    this.initialPage = 0,
  });

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int _pages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = '';
  Timer? _hideButtonsTimer;
  Timer? _progressSaveTimer;
  bool _showButtons = true;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _pageJumpController = TextEditingController();
  Map<int, String> _notes = {};
  bool _showNoteEditor = false;
  bool _showJumpToPage = false;
  String _assetPath = '';

  // Page notes storage key
  String get _notesStorageKey => 'notes_${widget.filePath}';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _loadNotes();
    _hideButtonsTimer = Timer(const Duration(seconds: 3), _hideButtons);

    // Extract asset path from file path for history tracking
    final fileName = widget.filePath.split('/').last;
    _assetPath = 'assets/$fileName';

    // Start periodic progress saving
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _saveReadingProgress();
    });
  }

  @override
  void dispose() {
    _hideButtonsTimer?.cancel();
    _progressSaveTimer?.cancel();
    _noteController.dispose();
    _pageJumpController.dispose();

    // Save progress one last time when leaving
    _saveReadingProgress();

    super.dispose();
  }

  Future<void> _saveReadingProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get existing reading history or create new
      final historyString = prefs.getString('reading_history') ?? '{}';
      final Map<String, dynamic> history = json.decode(historyString);

      // Update with current reading position
      history[_assetPath] = {
        'lastRead': DateTime.now().toIso8601String(),
        'pageNumber': _currentPage,
      };

      await prefs.setString('reading_history', json.encode(history));
    } catch (e) {
      print('Error saving reading progress: $e');
    }
  }

  void _hideButtons() {
    if (mounted) {
      setState(() {
        _showButtons = false;
      });
    }
  }

  void _resetHideButtonsTimer() {
    _hideButtonsTimer?.cancel();
    setState(() {
      _showButtons = true;
    });
    _hideButtonsTimer = Timer(const Duration(seconds: 3), _hideButtons);
  }

  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesString = prefs.getString(_notesStorageKey);
      if (notesString != null) {
        final Map<String, dynamic> notesMap = json.decode(notesString);
        final Map<int, String> notes = {};
        notesMap.forEach((key, value) {
          notes[int.parse(key)] = value.toString();
        });
        setState(() {
          _notes = notes;
        });
      }
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> notesMap = {};
      _notes.forEach((key, value) {
        notesMap[key.toString()] = value;
      });
      await prefs.setString(_notesStorageKey, json.encode(notesMap));
    } catch (e) {
      print('Error saving notes: $e');
    }
  }

  void _saveNote() {
    final text = _noteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _notes[_currentPage] = text;
        _showNoteEditor = false;
      });
      _saveNotes();
    } else {
      // Delete the note if the text is empty
      _deleteNote();
    }
  }

  void _deleteNote() {
    setState(() {
      _notes.remove(_currentPage);
      _showNoteEditor = false;
    });
    _saveNotes();
  }

  void _toggleNoteEditor() {
    setState(() {
      _showNoteEditor = !_showNoteEditor;
      _showJumpToPage = false;
      if (_showNoteEditor) {
        _noteController.text = _notes[_currentPage] ?? '';
      }
    });
  }

  void _toggleJumpToPage() {
    setState(() {
      _showJumpToPage = !_showJumpToPage;
      _showNoteEditor = false;
      if (_showJumpToPage) {
        _pageJumpController.text = (_currentPage + 1).toString();
      }
    });
  }

  void _jumpToPage() async {
    try {
      final pageNumber = int.parse(_pageJumpController.text);
      if (pageNumber >= 1 && pageNumber <= _pages) {
        final pdfController = await _controller.future;
        await pdfController.setPage(pageNumber - 1); // Convert to 0-indexed
        setState(() {
          _showJumpToPage = false;
        });
      } else {
        // Show error for invalid page number
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a page number between 1 and $_pages'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error for invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid page number'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Page ${_currentPage + 1} of $_pages',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: Tooltip(
                message: 'Jump to specific page',
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: _toggleJumpToPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.skip_next_rounded),
                        const SizedBox(width: 4),
                        Text(
                          '${_currentPage + 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.note_add_rounded),
                  if (_notes.containsKey(_currentPage))
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: _toggleNoteEditor,
              tooltip: 'Add note',
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _resetHideButtonsTimer,
        child: Stack(
          children: [
            // Main PDF View Container
            Container(
              color: Colors.grey.shade100,
              child: PDFView(
                filePath: widget.filePath,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: true,
                pageFling: true,
                pageSnap: true,
                defaultPage: _currentPage,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: false,
                onRender: (_pages) {
                  setState(() {
                    this._pages = _pages!;
                    _isReady = true;
                  });
                },
                onError: (error) {
                  setState(() {
                    _errorMessage = error.toString();
                  });
                  print(error.toString());
                },
                onPageError: (page, error) {
                  setState(() {
                    _errorMessage =
                        'Error while loading page ${page! + 1}: ${error.toString()}';
                  });
                  print(
                      'Error while loading page ${page! + 1}: ${error.toString()}');
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  _controller.complete(pdfViewController);
                },
                onPageChanged: (int? page, int? total) {
                  if (page != null) {
                    setState(() {
                      _currentPage = page;
                      _showNoteEditor = false;
                      _showJumpToPage = false;
                    });
                    _resetHideButtonsTimer();
                  }
                },
              ),
            ),

            // Error message
            if (_errorMessage.isNotEmpty)
              Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red.shade700,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            // Loading indicator
            if (!_isReady)
              Container(
                color: Colors.white,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading PDF...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Page indicator with note icon
            if (_showButtons)
              Positioned(
                bottom: _showNoteEditor || _showJumpToPage ? 200 : 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Page ${_currentPage + 1} of $_pages',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_notes.containsKey(_currentPage))
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.note_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Note editor at bottom
            if (_showNoteEditor)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Note for Page ${_currentPage + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (_notes.containsKey(_currentPage))
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                        onPressed: _deleteNote,
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                      onPressed: _saveNote,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () => setState(
                                          () => _showNoteEditor = false),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _noteController,
                                maxLines: 5,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: 'Write your notes here...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
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

            // Jump to page dialog at bottom
            if (_showJumpToPage)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Jump to Page',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      setState(() => _showJumpToPage = false),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _pageJumpController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter page number (1-$_pages)',
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onSubmitted: (_) => _jumpToPage(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _jumpToPage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade800,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Go',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _notes.containsKey(_currentPage) &&
              !_showNoteEditor &&
              !_showJumpToPage
          ? FloatingActionButton(
              onPressed: _toggleNoteEditor,
              backgroundColor: Colors.amber,
              elevation: 4,
              child: const Icon(
                Icons.note_rounded,
                size: 28,
              ),
            )
          : null,
    );
  }
}
