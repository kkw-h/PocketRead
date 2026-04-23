import 'package:flutter/material.dart';

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketRead'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Bookshelf',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'T001-T003 completed. The Flutter project skeleton, routing, and lint configuration are ready.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Book import and local data modules will land in T004-T016.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
