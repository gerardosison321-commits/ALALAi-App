import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final int xp;
  final double progress;

  const TopBar({
    super.key,
    required this.xp,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xffECE8FF),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Good Morning 👋",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Ready to Learn?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: Row(
                  children: [

                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 18,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      "$xp XP",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Today's Goal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}