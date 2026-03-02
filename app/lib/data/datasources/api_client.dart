import 'package:dio/dio.dart';
import 'package:pocketread/data/models/book.dart';
import 'package:pocketread/data/models/reading_progress.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;
  final String apiKey;

  ApiClient({
    required this.baseUrl,
    required this.apiKey,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ));

  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/api/status');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Book>> getBooks() async {
    try {
      final response = await _dio.get('/api/books');
      final List<dynamic> data = response.data['books'];
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  Future<void> syncProgress(List<ReadingProgress> progressList) async {
    try {
      await _dio.post('/api/sync', data: {
        'progress': progressList.map((p) => p.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('Failed to sync progress: $e');
    }
  }
  
  Future<List<ReadingProgress>> getProgress(String? bookId) async {
      try {
      final response = await _dio.get('/api/sync', queryParameters: bookId != null ? {'book_id': bookId} : null);
      final List<dynamic> data = response.data['progress'];
      return data.map((json) => ReadingProgress.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load progress: $e');
    }
  }

  Future<void> uploadBook({
    required List<int> fileBytes,
    required String filename,
    required String title,
    required String author,
    String format = 'epub',
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: filename),
        'title': title,
        'author': author,
        'format': format,
      });

      await _dio.post('/api/books', data: formData);
    } catch (e) {
      throw Exception('Failed to upload book: $e');
    }
  }

  Future<List<int>> downloadBook(String bookId) async {
    try {
      final response = await _dio.get(
        '/api/books/$bookId/download',
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to download book: $e');
    }
  }
}
