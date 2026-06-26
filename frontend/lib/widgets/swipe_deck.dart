import 'package:flutter/material.dart';

import 'action_buttons.dart';
import 'study_card.dart';

class SwipeDeck extends StatefulWidget {
  final String question;
  final String? explanation;
  final String cardType;
  final int currentCard;
  final int totalCards;
  final VoidCallback onGotIt;
  final VoidCallback onExplain;
  final VoidCallback onPractice;
  final VoidCallback onSkip;

  const SwipeDeck({
    super.key,
    required this.question,
    this.explanation,
    required this.cardType,
    required this.currentCard,
    required this.totalCards,
    required this.onGotIt,
    required this.onExplain,
    required this.onPractice,
    required this.onSkip,
  });

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> {
  Offset offset = Offset.zero;
  static const double threshold = 120;

  @override
  Widget build(BuildContext context) {
    final dx = offset.dx;
    final dy = offset.dy;

    String label = '';
    Color color = Colors.transparent;

    if (dx > 40) {
      label = '✔ GOT IT';
      color = Colors.green;
    } else if (dx < -40) {
      label = '💡 EXPLAIN';
      color = Colors.orange;
    } else if (dy < -40) {
      label = '📝 PRACTICE';
      color = Colors.blue;
    } else if (dy > 40) {
      label = '⏭ SKIP';
      color = Colors.grey;
    }

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                offset += details.delta;
              });
            },
            onPanEnd: (_) {
              if (offset.dx > threshold) {
                widget.onGotIt();
              } else if (offset.dx < -threshold) {
                widget.onExplain();
              } else if (offset.dy < -threshold) {
                widget.onPractice();
              } else if (offset.dy > threshold) {
                widget.onSkip();
              }
              setState(() => offset = Offset.zero);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  transform: Matrix4.identity()
                    ..setEntry(0, 3, offset.dx)
                    ..setEntry(1, 3, offset.dy)
                    ..rotateZ(offset.dx * 0.001),
                  child: StudyCard(
                    question: widget.question,
                    explanation: widget.explanation,
                    cardType: widget.cardType,
                    currentCard: widget.currentCard,
                    totalCards: widget.totalCards,
                  ),
                ),
                IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: label.isEmpty ? 0 : 1,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ActionButtons(
          onGotIt: widget.onGotIt,
          onExplain: widget.onExplain,
          onPractice: widget.onPractice,
          onSkip: widget.onSkip,
        ),
      ],
    );
  }
}
