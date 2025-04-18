import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../../../mbti/presentation/pages/mbti_question_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F0F7), Color(0xFFEFF1F9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(24),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.05),
            //       blurRadius: 20,
            //       offset: const Offset(0, 10),
            //     ),
            //   ],
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("🚀 ",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(
                      "창업 네비게이션에 오신 걸 환영합니다!",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "✨ 당신만의 창업 스타일을 진단하고, "),
                      TextSpan(
                        text: "딱 맞는 콘텐츠",
                        style: TextStyle(color: Colors.pink),
                      ),
                      TextSpan(text: "를 만나보세요!"),
                    ],
                  ),
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      icon: const Icon(Icons.lock),
                      label: const Text("로그인"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MbtiQuestionPage()),
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text("MBTI 테스트 시작하기"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF73FA3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
