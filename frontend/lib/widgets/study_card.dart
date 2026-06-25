import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_radius.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/screen.dart';

class StudyCard extends StatelessWidget {
  final String question;
  final int currentCard;
  final int totalCards;

  const StudyCard({
    super.key,
    required this.question,
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
                  borderRadius: BorderRadius.circular(
                    AppRadius.xl,
                  ),
                ),
              ),
            ),

            // Main Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppRadius.xl),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  )
                ],
              ),

              child: Padding(
                padding: EdgeInsets.all(
                  Screen.padding(context),
                ),

                child: Column(
                  children: [

                    //-----------------------------------
                    // Header
                    //-----------------------------------

                    Row(
                      children: [

                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lavender,
                            borderRadius:
                                BorderRadius.circular(
                              AppRadius.round,
                            ),
                          ),

                          child: Text(
                            "Card $currentCard / $totalCards",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.star_border,
                          ),
                        ),

                      ],
                    ),

                    const Spacer(),

                    //-----------------------------------
                    // Question
                    //-----------------------------------

                    Text(
                      question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            Screen.title(context),
                        fontWeight:
                            FontWeight.bold,
                        height: 1.35,
                      ),
                    ),

                    SizedBox(height: AppSpacing.md),

                    Text(
                      "Swipe or tap a button below",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.subtitle,
                        fontSize:
                            Screen.body(context),
                      ),
                    ),

                    const Spacer(),

                    //-----------------------------------
                    // Hint Button
                    //-----------------------------------

                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: FilledButton.icon(
                        onPressed: () {},

                        style: FilledButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              AppRadius.md,
                            ),
                          ),
                        ),

                        icon: const Icon(
                          Icons.lightbulb_outline,
                        ),

                        label: const Text(
                          "Need a Hint",
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    //-----------------------------------
                    // Footer
                    //-----------------------------------

                    Container(
                      padding:
                          const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: AppColors.lavender,
                        borderRadius:
                            BorderRadius.circular(
                          AppRadius.lg,
                        ),
                      ),

                      child: const Row(
                        children: [

                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Colors.white,
                            child: Icon(
                              Icons.smart_toy,
                              color:
                                  AppColors.primary,
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

            //-----------------------------------
            // Notebook Ring
            //-----------------------------------

            Positioned(
              left: -4,
              top: 28,
              child: Container(
                width: 14,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}