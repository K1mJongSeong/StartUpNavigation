import 'package:flutter/material.dart';

class MbtiResultPage extends StatelessWidget {
  final String mbtiType;
  final String strategyTag;
  final String description;
  final List<String> recommendedIndustries;
  final Map<String, double> scoreSummary;

  const MbtiResultPage({
    super.key,
    required this.mbtiType,
    required this.strategyTag,
    required this.description,
    required this.recommendedIndustries,
    required this.scoreSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('MBTI 결과'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MBTI 유형 및 전략
            Text(
              '💡 나의 MBTI는 ',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Text(
                  mbtiType,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                ),
                const Text(' 입니다!', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(strategyTag),
              backgroundColor: const Color(0xFFDDEAFE),
              labelStyle: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // 설명
            Text(description, style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87)),

            const SizedBox(height: 24),

            // 추천 업종
            const Text('📂 추천 업종', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...recommendedIndustries.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $item', style: const TextStyle(fontSize: 14)),
            )),

            const SizedBox(height: 24),

            // 점수 요약
            const Text('📊 점수 요약', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: scoreSummary.entries.map((entry) {
                return Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(entry.value.toStringAsFixed(1), style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // 자세히 보기 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 상세 페이지 이동
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('🔍 자세히 보기', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
