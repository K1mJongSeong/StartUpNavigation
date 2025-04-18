import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:startup_navigation/mbti/mbti_question.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '창업 네비게이션',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFCB07E),
          secondary: Color(0xFFFEEBCB),
          surface: Color(0xFFFFF8F3),
          background: Color(0xFFFFF4ED),
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.black87,
          onSurface: Colors.black87,
          onBackground: Colors.black87,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF4ED),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '당신만의 창업 여정을\n지금 시작해보세요!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '비즈내비 아이디',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFCB07E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                _handleLogin(context);
              },
              child: const Text('로그인', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }


  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, '이메일과 비밀번호를 입력해주세요.');
      return;
    }

    final externalResponse = await http.post(
      Uri.parse('https://api.biznavi.co.kr/api/v1/member/m_access'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'id': email,
        'password': password,
        'device_platform': 'ios',
        'device_id': 'mobileapi',
      },
    );

    final externalData = jsonDecode(utf8.decode(externalResponse.bodyBytes));

    if (externalData['code'] == '00') {
      final name = externalData['result']['name'];
      final id = externalData['result']['id'];

      final syncResponse = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/sync-user/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': id,
        }),
      );

      if (syncResponse.statusCode == 200 || syncResponse.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MbtiQuestion()),
        );
      } else {
        _showDialog(context, '내부 사용자 등록 실패');
      }
    } else {
      _showDialog(context, '비즈내비 로그인 실패: 아이디 또는 비밀번호 확인');
    }
  }


  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('로그인 실패'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('확인'),
          )
        ],
      ),
    );
  }
}
