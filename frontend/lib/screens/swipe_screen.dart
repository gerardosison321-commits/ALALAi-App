import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../models/card_model.dart';
import '../../models/session_model.dart';
import '../../widgets/swipe_deck.dart';
import '../../widgets/top_bar.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  String? _sessionId;
  List<StudyCard> _cards = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _error;

  int _xp = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    _sessionId = args?['sessionId'] as String?;

    if (_sessionId != null) {
      _loadSession();
    } else {
      setState(() {
        _isLoading = false;
        _error = 'No session ID provided.';
      });
    }
  }

  Future<void> _loadSession() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getSession(_sessionId!);
      final sessionWithCards = SessionWithCards.fromJson(data);
      setState(() {
        _cards = sessionWithCards.cards;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load session: $e';
        _isLoading = false;
      });
    }
  }

  StudyCard? get _currentCard {
    if (_cards.isEmpty || _currentIndex >= _cards.length) return null;
    return _cards[_currentIndex];
  }

  bool get _isFinished => _currentIndex >= _cards.length;

  double get _progress {
    if (_cards.isEmpty) return 0;
    return (_currentIndex + 1) / _cards.length;
  }

  Future<void> _onGotIt() async {
    if (_isProcessing || _currentCard == null) return;
    setState(() => _isProcessing = true);
    try {
      await ApiService.recordCardResult(
        sessionId: _sessionId!,
        cardId: _currentCard!.id,
        result: 'correct',
      );
      setState(() {
        _xp += 10;
        _currentIndex++;
      });
      _checkFinished();
    } on ApiException catch (e) {
      _showSnack('Error: ${e.message}');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _onExplain() async {
    if (_isProcessing || _currentCard == null) return;
    setState(() => _isProcessing = true);
    try {
      await ApiService.recordCardResult(
        sessionId: _sessionId!,
        cardId: _currentCard!.id,
        result: 'wrong',
      );
      final newExplanation = await ApiService.reExplain(
        sessionId: _sessionId!,
        question: _currentCard!.question,
        previousExplanation: _currentCard!.explanation,
      );
      setState(() {
        _cards[_currentIndex] = StudyCard(
          id: _currentCard!.id,
          sessionId: _currentCard!.sessionId,
          cardType: _currentCard!.cardType,
          question: _currentCard!.question,
          answer: _currentCard!.answer,
          choices: _currentCard!.choices,
          correctChoice: _currentCard!.correctChoice,
          explanation: newExplanation,
          position: _currentCard!.position,
          result: CardResult.wrong,
        );
      });
      _showSnack('💡 Laya explained it differently!');
    } on ApiException catch (e) {
      _showSnack('Error: ${e.message}');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _onPractice() async {
    if (_isProcessing || _currentCard == null) return;
    setState(() => _isProcessing = true);
    try {
      final practice = await ApiService.chat(
        sessionId: _sessionId!,
        message: 'Give me a practice exercise about: ${_currentCard!.question}',
      );
      _showSnack('📝 $practice', long: true);
    } on ApiException catch (e) {
      _showSnack('Error: ${e.message}');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _onSkip() async {
    if (_isProcessing || _currentCard == null) return;
    setState(() => _isProcessing = true);
    try {
      await ApiService.recordCardResult(
        sessionId: _sessionId!,
        cardId: _currentCard!.id,
        result: 'skipped',
      );
      setState(() => _currentIndex++);
      _checkFinished();
    } on ApiException catch (e) {
      _showSnack('Error: ${e.message}');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _checkFinished() async {
    if (!_isFinished) return;
    try {
      final summary = await ApiService.completeSession(_sessionId!);
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/summary',
        arguments: {'summary': summary},
      );
    } on ApiException catch (e) {
      _showSnack('Error completing session: ${e.message}');
    }
  }

  void _showSnack(String msg, {bool long = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: long ? const Duration(seconds: 5) : const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error ?? 'Unknown error', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadSession,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (_isFinished) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Finishing up...'),
            ],
          ),
        ),
      );
    }

    final card = _currentCard!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              xp: _xp,
              progress: _progress,
            ),
            Expanded(
              child: SwipeDeck(
                question: card.question,
                explanation: card.explanation,
                cardType: card.cardTypeLabel,
                currentCard: _currentIndex + 1,
                totalCards: _cards.length,
                onGotIt: _onGotIt,
                onExplain: _onExplain,
                onPractice: _onPractice,
                onSkip: _onSkip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
