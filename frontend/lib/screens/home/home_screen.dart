import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../widgets/feature_tile.dart';
import '../upload/upload_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text("ALALAi"),
        centerTitle: false,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Good Morning 👋",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Ready to Learn?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          FeatureTile(
            icon: Icons.play_circle_fill,
            title: "Continue Learning",
            subtitle: "Resume your last study session.",
            color: Colors.deepPurple,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.swipe,
              );
            },
          ),

          const SizedBox(height: 14),

          FeatureTile(
            icon: Icons.upload_file,
            title: "Upload Module",
            subtitle: "Turn your PDF into study cards.",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UploadScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          FeatureTile(
            icon: Icons.camera_alt,
            title: "Scan Worksheet",
            subtitle: "Capture notes with your camera.",
            color: Colors.green,
            onTap: () {},
          ),

          const SizedBox(height: 14),

          FeatureTile(
            icon: Icons.menu_book,
            title: "Browse Subjects",
            subtitle: "Use built-in DepEd lessons.",
            color: Colors.orange,
            onTap: () {},
          ),

          const SizedBox(height: 14),

          FeatureTile(
            icon: Icons.smart_toy,
            title: "Chat with Laya",
            subtitle: "Ask anything about your lesson.",
            color: Colors.purple,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}