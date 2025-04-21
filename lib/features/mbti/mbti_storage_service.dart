import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_navigation/core/api/end_points.dart';

class MbtiStorageService {
  static const _storageKey = 'mbti_answers';

  /// 저장: 특정 페이지의 응답들을 저장
  static Future<void> savePageAnswers(int page, List<Map<String, dynamic>> answers) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_storageKey);
    final data = existing != null ? jsonDecode(existing) : {};

    data[page.toString()] = answers;
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  /// 전체 응답 불러오기
  static Future<Map<int, List<Map<String, dynamic>>>> loadAllAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) =>
        MapEntry(int.parse(key), List<Map<String, dynamic>>.from(value)));
  }

  static Future<void> submitFinalAnswers() async {
    final allAnswers = await loadAllAnswers();

    // 평탄화 후 변환: { "q1": 1, "q2": 4, ... }
    final Map<String, dynamic> payload = {};
    allAnswers.forEach((page, answers) {
      for (final entry in answers) {
        final idx = entry['question_idx'];
        final score = entry['score'];
        payload['q$idx'] = score;
      }
    });

    final dio = Dio();
    final response = await dio.post(
      EndPoints.mbtiSumit,
      data: payload,
    );

    print('[MBTI 제출 응답] ${response.data}');
  }

  /// 초기화
  static Future<void> clearAllAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
