import 'package:flutter/material.dart';
import '../../models/flashcard.dart';
import '../../widgets/flashcard_widget.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using the same sample data for now
    final List<FlashCard> sampleFlashCard = [
      FlashCard(question: 'What is Flutter?', answer: 'An open-source UI software development kit by Google.'),
      FlashCard(question: 'What language does Flutter use?', answer: 'Dart'),
      FlashCard(question: 'What are widgets?', answer: 'The basic building blocks of a UI in Flutter.')
    ];

    return PageView.builder(
      itemCount: sampleFlashCard.length,
      itemBuilder: (context, index) {
        return FlashCardWidget(flashCard: sampleFlashCard[index]);
      },
    );
  }
}