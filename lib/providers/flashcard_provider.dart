// lib/providers/flashcard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flashcard.dart';
import '../services/flashcard_api_service.dart';

class FlashcardNotifier extends StateNotifier<AsyncValue<List<Flashcard>>> {
  final FlashcardApiService _apiService;

  FlashcardNotifier(this._apiService) : super(const AsyncValue.loading());

  Future<void> fetchFlashcards(int page, int pageSize) async {
    state = const AsyncValue.loading();
    try {
      final flashcards = await _apiService.readFlashcards(page, pageSize);
      state = AsyncValue.data(flashcards);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createFlashcard(String question, String answer) async {
    try {
      final newCard = await _apiService.createFlashcard(question, answer);
      if (newCard != null) {
        state.whenData((flashcards) {
          state = AsyncValue.data([...flashcards, newCard]);
        });
      }
    } catch (e, st) {
      // Handle error, maybe show a snackbar
      print('Error creating flashcard: $e');
    }
  }

// You can add more methods for update, delete, fetch random, etc.
}

final flashcardsProvider = StateNotifierProvider<FlashcardNotifier, AsyncValue<List<Flashcard>>>((ref) {
  return FlashcardNotifier(ref.watch(flashcardApiServiceProvider));
});

// A provider for a single random flashcard
final randomFlashcardProvider = FutureProvider.autoDispose<Flashcard?>((ref) async {
  final apiService = ref.watch(flashcardApiServiceProvider);
  return apiService.readRandomFlashcard();
});