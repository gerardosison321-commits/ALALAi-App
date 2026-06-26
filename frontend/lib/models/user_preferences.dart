/// Saved user settings (grade, language, etc.)
class UserPreferences {
  final int? gradeLevel;
  final String? subject;
  final String language;

  const UserPreferences({
    this.gradeLevel,
    this.subject,
    this.language = 'mixed',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      gradeLevel: json['grade_level'] as int?,
      subject: json['subject'] as String?,
      language: json['language'] as String? ?? 'mixed',
    );
  }

  Map<String, dynamic> toJson() => {
    'grade_level': gradeLevel,
    'subject': subject,
    'language': language,
  };
}
