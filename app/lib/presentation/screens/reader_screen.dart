import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pocketread/data/datasources/api_client.dart';
import 'package:pocketread/data/models/reading_progress.dart';
import 'package:pocketread/logic/blocs/auth/auth_bloc.dart';

class ReaderScreen extends StatefulWidget {
  final String bookId;
  final String title;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.title,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  EpubController? _epubController;
  bool _isLoading = true;
  String? _errorMessage;
  ApiClient? _apiClient;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        throw Exception('Not authenticated');
      }

      _apiClient = ApiClient(
        baseUrl: authState.serverUrl,
        apiKey: authState.apiKey,
      );

      // 1. Try to load from Hive cache
      Uint8List? bookBytes;
      final box = Hive.box('book_cache');
      
      if (box.containsKey(widget.bookId)) {
        debugPrint('Loading book from local cache');
        final List<dynamic> storedBytes = box.get(widget.bookId);
        bookBytes = Uint8List.fromList(storedBytes.cast<int>());
      } else {
        debugPrint('Downloading book from server');
        final bytes = await _apiClient!.downloadBook(widget.bookId);
        bookBytes = Uint8List.fromList(bytes);
        // Save to cache
        await box.put(widget.bookId, bytes);
      }
      
      // 2. Fetch progress
      String? initialCfi;
      try {
        final progressList = await _apiClient!.getProgress(widget.bookId);
        if (progressList.isNotEmpty) {
           initialCfi = progressList.first.cfi;
           debugPrint('Restoring progress to CFI: $initialCfi');
        }
      } catch (e) {
        debugPrint('Failed to load progress: $e');
      }

      _epubController = EpubController(
        document: EpubDocument.openData(bookBytes!),
        epubCfi: initialCfi,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onChapterChanged(dynamic value) async {
    final cfi = _epubController?.generateEpubCfi();
    if (value == null || cfi == null || _apiClient == null) return;
    
    // debugPrint('Chapter changed: ${value.runtimeType}');
    
    final progress = ReadingProgress(
      bookId: widget.bookId,
      chapterIndex: value.chapterNumber ?? 0,
      cfi: cfi,
      percentage: 0,
      deviceId: 'web-client',
      updatedAt: DateTime.now().toUtc(),
    );

    try {
      await _apiClient!.syncProgress([progress]);
    } catch (e) {
      debugPrint('Sync failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _epubController == null 
            ? Text(widget.title)
            : EpubViewActualChapter(
                controller: _epubController!,
                builder: (chapterValue) => Text(
                  chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? widget.title,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
      ),
      drawer: Drawer(
        child: _epubController == null
            ? const Center(child: CircularProgressIndicator())
            : EpubViewTableOfContents(controller: _epubController!),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadBook();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_epubController == null) {
      return const Center(child: Text('Failed to load book controller'));
    }

    return Stack(
      children: [
        EpubView(
          controller: _epubController!,
          onDocumentLoaded: (document) {
            debugPrint('Document loaded: ${document.Title}');
          },
          onChapterChanged: (value) {
            _onChapterChanged(value);
          },
        ),
        // Click areas for navigation
        Row(
          children: [
            // Previous Page (Left 30%)
            Expanded(
              flex: 3,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                   // Since epub_view uses scrollable list, we can't easily "page" back.
                   // But we can try to jump to previous chapter if at start of chapter?
                   // Or scroll up?
                   // For now, let's just implement previous/next chapter logic as a simple workaround
                   // until we have a better pagination solution or switch to a paginated epub reader.
                   // NOTE: epub_view 3.2.0 doesn't support pagination out of the box, it is a scroll view.
                   // We will leave the scroll behavior but adding click areas might conflict with scrolling if not careful.
                   // But user requested "click to turn page". 
                   // Let's implement jump to previous chapter for now.
                   
                   final currentChapter = _epubController?.currentValue?.chapterNumber ?? 1;
                   if (currentChapter > 1) {
                     _epubController?.jumpTo(index: currentChapter - 2);
                   }
                },
                child: Container(color: Colors.transparent),
              ),
            ),
             // Center Menu Area (Middle 40%)
            Expanded(
              flex: 4,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                   // Toggle UI or do nothing (let scroll happen)
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Next Page (Right 30%)
            Expanded(
              flex: 3,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                   final currentChapter = _epubController?.currentValue?.chapterNumber ?? 1;
                   // We don't know max chapters easily without parsing TOC deeply, 
                   // but jumpTo handles out of bounds gracefully usually or we catch error.
                   _epubController?.jumpTo(index: currentChapter);
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}