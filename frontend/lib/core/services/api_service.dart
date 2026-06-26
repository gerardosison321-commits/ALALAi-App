import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // ── YOUR REAL IP ────────────────────────────────────────
  static const String _base = 'http://192.168.1.9:3000/api';

  static const Duration _timeout = Duration(seconds: 30);

  // ── TOPICS ──────────────────────────────────────────────

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

  static Future<Map<String, dynamic>> getTopic(int id) async {
    final uri = Uri.parse('$_base/topics/$id');
    final response = await http.get(uri).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

  // ── SESSION ─────────────────────────────────────────────

  static Future<Map<String, dynamic>> createSession({
    int? topicId,
    required int gradeLevel,
    required String subject,
    String language = 'mixed',
    String? content,
  }) async {
    final uri = Uri.parse('$_base/session');
    final bodyMap = <String, dynamic>{
      'gradeLevel': gradeLevel,
      'subject': subject,
      'language': language,
    };
    if (topicId != null) bodyMap['topicId'] = topicId;
    if (content != null) bodyMap['content'] = content;

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyMap),
    ).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getSession(String sessionId) async {
    final uri = Uri.parse('$_base/session/$sessionId');
    final response = await http.get(uri).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

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

  static Future<Map<String, dynamic>> completeSession(String sessionId) async {
    final uri = Uri.parse('$_base/session/$sessionId/complete');
    final response = await http.post(uri).timeout(_timeout);

    final body = _parse(response);
    return body['data'] as Map<String, dynamic>;
  }

  // ── LAYA — AI ───────────────────────────────────────────

  static Future<String> reExplain({
    required String sessionId,
    required String question,
    String? previousExplanation,
    String? content,
  }) async {
    final uri = Uri.parse('$_base/laya/reexplain');
    final bodyMap = <String, dynamic>{
      'sessionId': sessionId,
      'question': question,
    };
    if (previousExplanation != null) bodyMap['previousExplanation'] = previousExplanation;
    if (content != null) bodyMap['content'] = content;

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyMap),
    ).timeout(_timeout);

    final body = _parse(response);
    final data = body['data'] as Map<String, dynamic>;
    return data['explanation'] as String;
  }

  static Future<String> chat({
    required String sessionId,
    required String message,
    String? content,
  }) async {
    final uri = Uri.parse('$_base/laya/chat');
    final bodyMap = <String, dynamic>{
      'sessionId': sessionId,
      'message': message,
    };
    if (content != null) bodyMap['content'] = content;

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyMap),
    ).timeout(_timeout);

    final body = _parse(response);
    final data = body['data'] as Map<String, dynamic>;
    return data['reply'] as String;
  }

  // ── UPLOAD ──────────────────────────────────────────────

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

  // ── PRIVATE HELPER ──────────────────────────────────────

  static Map<String, dynamic> _parse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final error = body['error'] ?? 'Unknown error from server';
    throw ApiException(error.toString(), response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
