import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onGotIt;
  final VoidCallback onExplain;
  final VoidCallback onPractice;
  final VoidCallback onSkip;

  const ActionButtons({
    super.key,
    required this.onGotIt,
    required this.onExplain,
    required this.onPractice,
    required this.onSkip,
  });

  Widget buildButton({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildButton(
            color: const Color(0xFF34C759),
            icon: Icons.check_circle_outline,
            label: "Got It",
            onPressed: onGotIt,
          ),

          const SizedBox(height: 12),

          buildButton(
            color: Colors.orange,
            icon: Icons.lightbulb_outline,
            label: "Explain Again",
            onPressed: onExplain,
          ),

          const SizedBox(height: 12),

          buildButton(
            color: Colors.blue,
            icon: Icons.quiz_outlined,
            label: "Practice",
            onPressed: onPractice,
          ),

          const SizedBox(height: 12),

          buildButton(
            color: Colors.grey,
            icon: Icons.skip_next,
            label: "Skip",
            onPressed: onSkip,
          ),
        ],
      ),
    );
  }
}