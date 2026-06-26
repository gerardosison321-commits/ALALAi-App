import 'card_model.dart';

/// Study session returned by the backend
class SessionModel {
  final String id;
  final int? topicId;
  final int gradeLevel;
  final String subject;
  final String language;
  final int totalCards;
  final int cardsCorrect;
  final int cardsWrong;
  final int cardsSkipped;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;

  const SessionModel({
    required this.id,
    this.topicId,
    required this.gradeLevel,
    required this.subject,
    required this.language,
    required this.totalCards,
    required this.cardsCorrect,
    required this.cardsWrong,
    required this.cardsSkipped,
    required this.status,
    required this.startedAt,
    this.completedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      topicId: json['topic_id'] as int?,
      gradeLevel: json['grade_level'] as int,
      subject: json['subject'] as String,
      language: json['language'] as String,
      totalCards: json['total_cards'] as int? ?? 0,
      cardsCorrect: json['cards_correct'] as int? ?? 0,
      cardsWrong: json['cards_wrong'] as int? ?? 0,
      cardsSkipped: json['cards_skipped'] as int? ?? 0,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}

/// Full session with cards — what the swipe screen needs
class SessionWithCards {
  final SessionModel session;
  final List<StudyCard> cards;

  const SessionWithCards({
    required this.session,
    required this.cards,
  });

  factory SessionWithCards.fromJson(Map<String, dynamic> json) {
    final sessionData = json['session'] as Map<String, dynamic>;
    final cardsData = json['cards'] as List<dynamic>;

    return SessionWithCards(
      session: SessionModel.fromJson(sessionData),
      cards: cardsData
          .map((c) => StudyCard.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
