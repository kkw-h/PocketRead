import 'package:flutter/material.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({
    required this.bookId,
    super.key,
  });

  final String bookId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: Center(
        child: Text('Reader placeholder for $bookId'),
      ),
    );
  }
}
