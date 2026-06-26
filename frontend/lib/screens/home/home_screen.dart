import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/services/api_service.dart';
import '../../models/topic_model.dart';
import '../../widgets/feature_tile.dart';
import '../chat/chat_screen.dart';
import '../upload/upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingTopics = false;
  List<TopicModel> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  /// Load available DepEd topics from backend
  Future<void> _loadTopics() async {
    setState(() => _isLoadingTopics = true);
    try {
      final data = await ApiService.getTopics();
      setState(() {
        _topics = data.map((t) => TopicModel.fromJson(t)).toList();
        _isLoadingTopics = false;
      });
    } catch (e) {
      setState(() => _isLoadingTopics = false);
      // Silently fail — topics will load when user taps Browse
    }
  }

  /// Start a session from a pre-loaded DepEd topic
  Future<void> _startTopicSession(TopicModel topic) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final sessionData = await ApiService.createSession(
        topicId: topic.id,
        gradeLevel: topic.gradeLevel,
        subject: topic.subject,
        language: topic.language,
      );

      final sessionId = sessionData['session']['id'] as String;

      if (!mounted) return;
      Navigator.pop(context); // close loading

      Navigator.pushNamed(
        context,
        AppRoutes.swipe,
        arguments: {'sessionId': sessionId},
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showSnack('Error: ${e.message}');
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showSnack('Failed to start session: $e');
    }
  }

  /// Show topic picker bottom sheet
  void _showTopicPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Choose a Subject',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pre-loaded DepEd lessons ready to learn',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoadingTopics
                        ? const Center(child: CircularProgressIndicator())
                        : _topics.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.menu_book_outlined,
                                        size: 48, color: Colors.grey.shade400),
                                    const SizedBox(height: 12),
                                    const Text('No topics available yet'),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: _topics.length,
                                itemBuilder: (context, index) {
                                  final topic = _topics[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      leading: CircleAvatar(
                                        backgroundColor: _subjectColor(topic.subject),
                                        child: Text(
                                          topic.subject[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        topic.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${topic.displaySubject} • Grade ${topic.gradeLevel}',
                                      ),
                                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _startTopicSession(topic);
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _subjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'math': return Colors.blue;
      case 'science': return Colors.green;
      case 'filipino': return Colors.orange;
      case 'english': return Colors.purple;
      case 'araling_panlipunan': return Colors.red;
      default: return Colors.deepPurple;
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('ALALAi'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Good Morning 👋',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ready to Learn?',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // Continue Learning — goes to last session or shows message
          FeatureTile(
            icon: Icons.play_circle_fill,
            title: 'Continue Learning',
            subtitle: 'Resume your last study session.',
            color: Colors.deepPurple,
            onTap: () {
              _showSnack('Continue from last session — coming soon!');
              // TODO: Load last session ID from SharedPreferences
            },
          ),
          const SizedBox(height: 14),

          // Upload Module
          FeatureTile(
            icon: Icons.upload_file,
            title: 'Upload Module',
            subtitle: 'Turn your PDF into study cards.',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadScreen()),
              );
            },
          ),
          const SizedBox(height: 14),

          // Scan Worksheet
          FeatureTile(
            icon: Icons.camera_alt,
            title: 'Scan Worksheet',
            subtitle: 'Capture notes with your camera.',
            color: Colors.green,
            onTap: () {
              // Same as upload but with camera pre-selected
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UploadScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          // Browse Subjects — DepEd topics
          FeatureTile(
            icon: Icons.menu_book,
            title: 'Browse Subjects',
            subtitle: 'Use built-in DepEd lessons.',
            color: Colors.orange,
            onTap: _showTopicPicker,
          ),
          const SizedBox(height: 14),

          // Chat with Laya
          FeatureTile(
            icon: Icons.smart_toy,
            title: 'Chat with Laya',
            subtitle: 'Ask anything about your lesson.',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatScreen(sessionId: null),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
