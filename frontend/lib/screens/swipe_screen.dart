import 'package:flutter/material.dart';

import '../models/study_session.dart';
import '../widgets/swipe_deck.dart';
import '../widgets/top_bar.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late StudySession session;

  @override
  void initState() {
    super.initState();

    session = StudySession(
      cards: [
        "The Earth revolves around the Sun.",
        "Water boils at 100°C.",
        "Jose Rizal wrote Noli Me Tangere.",
        "Plants make food through photosynthesis.",
        "A triangle has three sides.",
      ],
    );
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              xp: session.xp,
              progress: session.progress,
            ),

            Expanded(
              child: SwipeDeck(
                question: session.currentQuestion,
                currentCard: session.currentCardNumber,
                totalCards: session.totalCards,

                onGotIt: () {
                  session.gotIt();
                  refresh();
                },

                onExplain: () {
                  session.explainAgain();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "💡 Claude will explain this differently.",
                      ),
                    ),
                  );
                },

                onPractice: () {
                  session.practice();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "📝 Practice mode coming soon.",
                      ),
                    ),
                  );
                },

                onSkip: () {
                  session.skip();
                  refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}