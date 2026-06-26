import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_radius.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/screen.dart';

class StudyCard extends StatelessWidget {
  final String question;
  final String? explanation;
  final String cardType;
  final int currentCard;
  final int totalCards;

  const StudyCard({
    super.key,
    required this.question,
    this.explanation,
    required this.cardType,
    required this.currentCard,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Screen.cardWidth(context),
        height: Screen.cardHeight(context),
        child: Stack(
          children: [
            // Shadow Layer
            Positioned(
              top: 10,
              left: 10,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffDDD8FF),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
            ),

            // Main Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(Screen.padding(context)),
                child: Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _typeColor(cardType),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _typeColor(cardType).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.round),
                          ),
                          child: Text(
                            cardType,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _typeColor(cardType),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lavender,
                            borderRadius: BorderRadius.circular(AppRadius.round),
                          ),
                          child: Text(
                            "Card $currentCard / $totalCards",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Question
                    Text(
                      question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Screen.title(context),
                        fontWeight: FontWeight.bold,
                        height: 1.35,
                      ),
                    ),

                    // Explanation (shown after re-explain swipe left)
                    if (explanation != null && explanation!.isNotEmpty) ...[
                      SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Text(
                          explanation!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: Screen.body(context),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: AppSpacing.md),

                    Text(
                      "Swipe or tap a button below",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.subtitle,
                        fontSize: Screen.body(context),
                      ),
                    ),

                    const Spacer(),

                    // Hint Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        icon: const Icon(Icons.lightbulb_outline),
                        label: const Text("Ask Laya"),
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Footer
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.lavender,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.smart_toy,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Laya is here to help whenever you need it 💜",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Notebook Ring
            Positioned(
              left: -4,
              top: 28,
              child: Container(
                width: 14,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Concept':
        return Colors.blue;
      case 'Quiz':
        return Colors.green;
      case 'Did You Know?':
        return Colors.purple;
      case 'Challenge':
        return Colors.red;
      case 'Answer':
        return Colors.orange;
      case 'Achievement!':
        return Colors.amber;
      default:
        return Colors.deepPurple;
    }
  }
}
