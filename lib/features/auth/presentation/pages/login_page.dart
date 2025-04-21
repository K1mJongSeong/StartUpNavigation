import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_navigation/features/auth/data/repositories/auth_repository.dart';
import 'package:startup_navigation/features/mbti/bloc/mbti_question_event.dart';
import 'package:startup_navigation/features/mbti/data/datasources/mbti_remote_data_source.dart';
import 'package:startup_navigation/features/mbti/data/repositories/mbti_repository_impl.dart';
import 'package:startup_navigation/features/mbti/domain/usecases/fetch_questions_usecase.dart';
import 'package:startup_navigation/features/mbti/presentation/pages/mbti_question_page.dart';

import '../../../mbti/bloc/mbti_question_bloc.dart';
import '../../../welcome/presentation/pages/welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final id = _idController.text.trim();
    final pw = _passwordController.text.trim();

    final success = await _authRepository.login(id,pw);

    setState(() {
      _isLoading = false;
    });

    if(success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        final dio = Dio();
        final dataSource = MbtiRemoteDataSource(dio);
        final repository = MbtiRepositoryImpl(dataSource);
        final usecase = FetchMbtiQuestionsUseCase(repository);

        return BlocProvider(create: (_) => MbtiQuestionBloc(usecase)..add(LoadMbtiQuestions(1)),
        child: const MbtiQuestionPage(),
        );
      }
        //const MbtiQuestionPage()
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그인에 실패했습니다. 아이디 또는 비밀번호를 확인하세요."),)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🔐 로그인',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1E2F),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  :const Text(
                    '로그인',
                    style: TextStyle(fontSize: 18
                        ,color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomePage()),
                        (route) => false,
                  );
                },
                child: const Text(
                  '🏠 메인으로 돌아가기',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 14,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
