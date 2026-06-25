import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // ── Change this to your machine's local IP if testing on a real phone
  // ── Keep localhost if using an emulator
  static const String _base = 'http://192.168.1.x:3000/api';

  static const Duration _timeout = Duration(seconds: 30);

  // ────────────────────────────────────────────────────────
  // TOPICS
  // ────────────────────────────────────────────────────────

  /// Get all topics, optionally filtered by subject and/or grade level.
  /// Example: getTopics(subject: 'math', gradeLevel: 7)
  static Future<List<Map<String, dynamic>>> getTopics({
    String? subject,
    int? gradeLevel,
  }) async {
    final params = <String, String>{};
    if (subject != null) params['subject'] = subject;
    if (gradeLevel != null) params['grade_level'] = gradeLevel.toString();

    final uri = Uri.parse('$_base/topics').replace(queryParameters: params);
    final response = await http.get(uri).timeout(_timeout);

    final body = _parse(response);
    final data = body['data'] as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  /// Get a single topic by ID (includes full content field).
  static Future<Map<String, dynamic>> getTopic(int id) async {
    final uri = Uri.parse('$_base/topics/$id');
    final response = await http.get(uri).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

  // ────────────────────────────────────────────────────────
  // SESSION
  // ────────────────────────────────────────────────────────

  /// Create a new study session and generate cards from Laya.
  /// Pass either [topicId] (pre-loaded DepEd topic) or [content] (uploaded text).
  static Future<Map<String, dynamic>> createSession({
    int? topicId,
    required int gradeLevel,
    required String subject,
    String language = 'mixed',
    String? content,
  }) async {
    final uri = Uri.parse('$_base/session');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        if (topicId != null) 'topicId': topicId,
        'gradeLevel': gradeLevel,
        'subject': subject,
        'language': language,
        if (content != null) 'content': content,
      }),
    ).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Get an existing session and its cards.
  static Future<Map<String, dynamic>> getSession(String sessionId) async {
    final uri = Uri.parse('$_base/session/$sessionId');
    final response = await http.get(uri).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Record the result of a card swipe.
  /// [result] must be 'correct', 'wrong', or 'skipped'
  static Future<void> recordCardResult({
    required String sessionId,
    required String cardId,
    required String result,
  }) async {
    final uri = Uri.parse('$_base/session/$sessionId/card/$cardId');
    await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'result': result}),
    ).timeout(_timeout);
  }

  /// Mark a session as completed and get the summary.
  static Future<Map<String, dynamic>> completeSession(String sessionId) async {
    final uri = Uri.parse('$_base/session/$sessionId/complete');
    final response = await http.post(uri).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

  // ────────────────────────────────────────────────────────
  // LAYA — AI
  // ────────────────────────────────────────────────────────

  /// Ask Laya to re-explain a card the student swiped left on.
  static Future<String> reExplain({
    required String sessionId,
    required String question,
    String? previousExplanation,
    String? content,
  }) async {
    final uri = Uri.parse('$_base/laya/reexplain');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sessionId': sessionId,
        'question': question,
        if (previousExplanation != null)
          'previousExplanation': previousExplanation,
        if (content != null) 'content': content,
      }),
    ).timeout(_timeout);

    final body = _parse(response);
    final data = body['data'] as Map<String, dynamic>;
    return data['explanation'] as String;
  }

  /// Send a chat message to Laya and get a reply.
  static Future<String> chat({
    required String sessionId,
    required String message,
    String? content,
  }) async {
    final uri = Uri.parse('$_base/laya/chat');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sessionId': sessionId,
        'message': message,
        if (content != null) 'content': content,
      }),
    ).timeout(_timeout);

    final body = _parse(response);
    final data = body['data'] as Map<String, dynamic>;
    return data['reply'] as String;
  }

  // ────────────────────────────────────────────────────────
  // UPLOAD
  // ────────────────────────────────────────────────────────

  /// Upload a PDF or image file and get the extracted text back.
  static Future<String> uploadFile(File file) async {
    final uri = Uri.parse('$_base/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamed);

    final body = _parse(response);
    final data = body['data'] as Map<String, dynamic>;
    return data['content'] as String;
  }

  // ────────────────────────────────────────────────────────
  // PRIVATE HELPER
  // ────────────────────────────────────────────────────────

  static Map<String, dynamic> _parse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final error = body['error'] ?? 'Unknown error from server';
    throw ApiException(error.toString(), response.statusCode);
  }
}

// ── Custom exception so screens can show friendly errors ──
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}