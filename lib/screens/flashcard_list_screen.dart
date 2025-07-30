// lib/screens/flashcard_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flashcard_provider.dart';
import '../models/flashcard.dart'; // Make sure you have this model

class FlashcardListScreen extends ConsumerWidget {
  const FlashcardListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardsAsyncValue = ref.watch(flashcardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to a screen to add new flashcards
              // For simplicity, let's just add a dummy one here
              ref.read(flashcardsProvider.notifier).createFlashcard(
                "New Question ${DateTime.now().millisecond}",
                "New Answer ${DateTime.now().millisecond}",
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(flashcardsProvider.notifier).fetchFlashcards(1, 10);
            },
          ),
        ],
      ),
      body: flashcardsAsyncValue.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const Center(child: Text('No flashcards yet. Add some!'));
          }
          return ListView.builder(
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              final card = flashcards[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(card.question),
                  subtitle: Text(card.answer),
                  onTap: () {
                    // Navigate to a detail page to view/edit the flashcard
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(randomFlashcardProvider); // Just re-fetches the random card
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fetching new random card... (check console)')),
          );
        },
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}