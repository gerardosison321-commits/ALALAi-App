import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _subjectStats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final userId = await AuthService.getUserId();
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final profile = await ApiService.getProfile(userId);
      final subjectData = await ApiService.getSessionStats(userId);

      setState(() {
        _stats = profile;
        _subjectStats = subjectData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final xp = _stats?['xp'] ?? 0;
    final streak = _stats?['streak'] ?? 0;
    final subjectsCompleted = _stats?['subjectsCompleted'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            title: 'Current Streak',
            subtitle: '$streak Days',
            trailing: '🔥',
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.star,
            iconColor: Colors.amber,
            title: 'Total XP',
            subtitle: '$xp XP',
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.school,
            iconColor: Colors.deepPurple,
            title: 'Subjects Completed',
            subtitle: '$subjectsCompleted subjects',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Goal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: (xp % 200) / 200,
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('${xp % 200} / 200 XP'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Subjects',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_subjectStats.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No completed subjects yet.\nStart learning!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            )
          else
            ..._subjectStats.map((s) => _buildSubjectCard(
                  _subjectIcon(s['subject'] as String),
                  _subjectName(s['subject'] as String),
                  '${s['completed']} sessions',
                )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing != null
            ? Text(trailing, style: Theme.of(context).textTheme.headlineMedium)
            : null,
      ),
    );
  }

  Widget _buildSubjectCard(IconData icon, String title, String sessions) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          sessions,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  IconData _subjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'science':
        return Icons.science;
      case 'math':
      case 'mathematics':
        return Icons.calculate;
      case 'english':
        return Icons.menu_book;
      case 'filipino':
        return Icons.chat;
      case 'araling_panlipunan':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  String _subjectName(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
        return 'Mathematics';
      case 'araling_panlipunan':
        return 'Araling Panlipunan';
      default:
        return subject[0].toUpperCase() + subject.substring(1);
    }
  }
}