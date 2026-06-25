import 'package:flutter/material.dart';

import '../models/study_session.dart';

class SwipeController extends ChangeNotifier {
  final StudySession session;

  SwipeController(this.session);

  void gotIt() {
    session.gotIt();
    notifyListeners();
  }

  void explainAgain() {
    session.explainAgain();
    notifyListeners();
  }

  void practice() {
    session.practice();
    notifyListeners();
  }

  void skip() {
    session.skip();
    notifyListeners();
  }

  void reset() {
    session.reset();
    notifyListeners();
  }
}