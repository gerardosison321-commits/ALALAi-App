class StudySession {
  final List<String> cards;

  int currentIndex;
  int xp;
  int streak;

  StudySession({
    required this.cards,
    this.currentIndex = 0,
    this.xp = 0,
    this.streak = 1,
  });

  // -----------------------------
  // Current Card
  // -----------------------------

  String get currentQuestion => cards[currentIndex];

  int get totalCards => cards.length;

  int get currentCardNumber => currentIndex + 1;

  double get progress => currentCardNumber / totalCards;

  bool get isFinished => currentIndex >= cards.length - 1;

  // -----------------------------
  // Actions
  // -----------------------------

  void gotIt() {
    xp += 10;
    next();
  }

  void explainAgain() {
    // Claude will plug into this later
  }

  void practice() {
    // Opens Practice screen later
  }

  void skip() {
    next();
  }

  void next() {
    if (!isFinished) {
      currentIndex++;
    }
  }

  void reset() {
    currentIndex = 0;
    xp = 0;
    streak = 1;
  }
}