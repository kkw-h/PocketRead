import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pocketread/logic/blocs/bookshelf/bookshelf_bloc.dart';
import 'package:pocketread/logic/blocs/auth/auth_bloc.dart';
import 'package:pocketread/presentation/screens/reader_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickAndUploadBook(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'txt'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final filename = file.name;
      final extension = file.extension ?? 'epub';
      final bytes = file.bytes;

      if (bytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to read file data')),
          );
        }
        return;
      }

      if (!context.mounted) return;

      final titleController = TextEditingController(text: filename.replaceAll('.$extension', ''));
      final authorController = TextEditingController(text: 'Unknown');

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Upload Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Upload'),
            ),
          ],
        ),
      );

      if (confirmed == true && context.mounted) {
        context.read<BookshelfBloc>().add(
          BookshelfBookUploadRequested(
            fileBytes: bytes,
            filename: filename,
            title: titleController.text,
            author: authorController.text,
            format: extension,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookshelf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               context.read<BookshelfBloc>().add(BookshelfRefreshRequested());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
               context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<BookshelfBloc, BookshelfState>(
        builder: (context, state) {
          if (state is BookshelfLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookshelfError) {
             return Center(child: Text('Error: ${state.message}'));
          } else if (state is BookshelfLoaded) {
             if (state.books.isEmpty) {
               return const Center(child: Text('No books found. Add some!'));
             }
             return ListView.builder(
               itemCount: state.books.length,
               itemBuilder: (context, index) {
                 final book = state.books[index];
                 return ListTile(
                   title: Text(book.title),
                   subtitle: Text(book.author ?? 'Unknown Author'),
                   leading: const Icon(Icons.book),
                   onTap: () {
                     Navigator.of(context).push(
                       MaterialPageRoute(
                         builder: (context) => ReaderScreen(
                           bookId: book.id,
                           title: book.title,
                         ),
                       ),
                     );
                   },
                 );
               },
             );
          }
          return const Center(child: Text('Welcome! Pull to refresh.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickAndUploadBook(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
