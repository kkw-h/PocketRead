import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketread/data/models/book.dart';
import 'package:pocketread/data/datasources/api_client.dart';

// States
abstract class BookshelfState extends Equatable {
  const BookshelfState();
  @override
  List<Object?> get props => [];
}

class BookshelfInitial extends BookshelfState {}
class BookshelfLoading extends BookshelfState {}
class BookshelfLoaded extends BookshelfState {
  final List<Book> books;
  const BookshelfLoaded(this.books);
  @override
  List<Object?> get props => [books];
}
class BookshelfError extends BookshelfState {
  final String message;
  const BookshelfError(this.message);
  @override
  List<Object?> get props => [message];
}

// Events
abstract class BookshelfEvent extends Equatable {
  const BookshelfEvent();
  @override
  List<Object?> get props => [];
}

class BookshelfLoadRequested extends BookshelfEvent {}
class BookshelfRefreshRequested extends BookshelfEvent {}

class BookshelfBookUploadRequested extends BookshelfEvent {
  final List<int> fileBytes;
  final String filename;
  final String title;
  final String author;
  final String format;

  const BookshelfBookUploadRequested({
    required this.fileBytes,
    required this.filename,
    required this.title,
    required this.author,
    required this.format,
  });

  @override
  List<Object?> get props => [fileBytes, filename, title, author, format];
}

// Bloc
class BookshelfBloc extends Bloc<BookshelfEvent, BookshelfState> {
  final ApiClient _apiClient;

  BookshelfBloc(this._apiClient) : super(BookshelfInitial()) {
    on<BookshelfLoadRequested>(_onLoadRequested);
    on<BookshelfRefreshRequested>(_onRefreshRequested);
    on<BookshelfBookUploadRequested>(_onBookUploadRequested);
  }

  Future<void> _onLoadRequested(BookshelfLoadRequested event, Emitter<BookshelfState> emit) async {
    emit(BookshelfLoading());
    try {
      // TODO: Fetch from local DB first, then sync
      final books = await _apiClient.getBooks();
      emit(BookshelfLoaded(books));
    } catch (e) {
      emit(BookshelfError(e.toString()));
    }
  }

  Future<void> _onRefreshRequested(BookshelfRefreshRequested event, Emitter<BookshelfState> emit) async {
     // Force sync
     try {
       final books = await _apiClient.getBooks();
       emit(BookshelfLoaded(books));
     } catch (e) {
       // Keep old state or emit error toast
     }
  }

  Future<void> _onBookUploadRequested(BookshelfBookUploadRequested event, Emitter<BookshelfState> emit) async {
    emit(BookshelfLoading());
    try {
      await _apiClient.uploadBook(
        fileBytes: event.fileBytes,
        filename: event.filename,
        title: event.title,
        author: event.author,
        format: event.format,
      );
      // Refresh list after upload
      add(BookshelfRefreshRequested());
    } catch (e) {
      emit(BookshelfError(e.toString()));
    }
  }
}
