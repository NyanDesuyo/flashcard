import "package:flutter/material.dart";
import "../models/flashcard.dart";

class FlashCardWidget extends StatefulWidget {
  final FlashCard flashCard;

  const FlashCardWidget({
    super.key,
    required this.flashCard
});

  @override
  State<FlashCardWidget> createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget> {
  bool _showQuestion = true;

  void _flipCard(){
    setState(() {
      _showQuestion = !_showQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
              child: Text(
                _showQuestion ? widget.flashCard.question : widget.flashCard.answer,
                textAlign: TextAlign.center,
                style:Theme.of(context).textTheme.headlineMedium
              ),
          )
        ),
      )
    );
  }
}