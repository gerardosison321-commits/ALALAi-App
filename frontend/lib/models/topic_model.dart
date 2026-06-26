/// Pre-loaded DepEd topic from the backend
class TopicModel {
  final int id;
  final String subject;
  final int gradeLevel;
  final String title;
  final String description;
  final String content;
  final String language;
  final bool isActive;

  const TopicModel({
    required this.id,
    required this.subject,
    required this.gradeLevel,
    required this.title,
    required this.description,
    required this.content,
    required this.language,
    required this.isActive,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as int,
      subject: json['subject'] as String,
      gradeLevel: json['grade_level'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      content: json['content'] as String,
      language: json['language'] as String? ?? 'mixed',
      isActive: (json['is_active'] as int? ?? 1) == 1 ||
                (json['is_active'] as bool? ?? true) == true,
    );
  }

  String get displaySubject {
    switch (subject.toLowerCase()) {
      case 'math': return 'Mathematics';
      case 'science': return 'Science';
      case 'filipino': return 'Filipino';
      case 'english': return 'English';
      case 'araling_panlipunan': return 'Araling Panlipunan';
      default: return subject;
    }
  }
}
