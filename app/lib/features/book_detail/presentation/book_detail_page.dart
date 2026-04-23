import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({
    required this.bookId,
    super.key,
  });

  final String bookId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Detail')),
      body: Center(
        child: Text('Book detail placeholder for $bookId'),
      ),
    );
  }
}
